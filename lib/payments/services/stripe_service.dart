import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stripe_app/payments/models/payment_intent_response.dart';
import 'package:stripe_app/payments/models/stripe_response.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeService {
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();

  factory StripeService() => _instance;

  String _paymentApiURL = 'https://api.stripe.com/v1/payment_intents';
  String _apiKey =
      'pk_test_51Iuu8HFgO3yjnhZRGOYTxpwhKueXobCgDGkn33TBCrEiKnvCf86e8LH3913H72VZt3lnxSaNZpylZTuSlran3w0z00aRRJlOSS';
  static String _key =
      'sk_test_51Iuu8HFgO3yjnhZRCdc6cDqUcfolClBWLStY1gBCp6JL9smvyjQk9pzr7nVlklov79qQoZdlIb71vlhiR6fXURkF008szJtNxA';

  final headerOptions = new Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer ${StripeService._key}'});

  void init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: _apiKey, merchantId: "test", androidPayMode: 'test'));
  }

  Future<StripeCustomResponse> payWithExistingCard({
    @required String amount,
    @required currency,
    @required CreditCard card,
  }) async {
    try {
      final PaymentMethod paymentMethod =
          await StripePayment.createPaymentMethod(
              PaymentMethodRequest(card: card));

      final resp = await this._finishPayment(
          amount: amount, currency: currency, paymentMethod: paymentMethod);

      return resp;
    } catch (e) {
      return StripeCustomResponse(success: false, message: e.message);
    }
  }

  Future<StripeCustomResponse> payWithNewCard({
    @required String amount,
    @required currency,
  }) async {
    try {
      final PaymentMethod paymentMethod =
          await StripePayment.paymentRequestWithCardForm(
        CardFormPaymentRequest(),
      );

      final resp = await this._finishPayment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      return resp;
    } catch (e) {
      return StripeCustomResponse(success: false, message: e.message);
    }
  }

  Future payWithAppleGoogle({
    @required String amount,
    @required currency,
  }) async {}

  Future<PaymentIntentResponse> _createPaymentIntent({
    @required String amount,
    @required currency,
  }) async {
    try {
      final dio = Dio();
      final data = {
        'amount': amount,
        'currency': currency,
      };

      final response =
          await dio.post(_paymentApiURL, data: data, options: headerOptions);

      return PaymentIntentResponse.fromJson(response.data);
    } catch (e) {
      print(e.toString());
      return PaymentIntentResponse(
        status: '400',
      );
    }
  }

  Future<StripeCustomResponse> _finishPayment({
    @required String amount,
    @required currency,
    @required PaymentMethod paymentMethod,
  }) async {
    try {
      final paymentIntent = await this._createPaymentIntent(
        amount: amount,
        currency: currency,
      );

      final paymentResult =
          await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: paymentIntent.clientSecret,
        paymentMethodId: paymentMethod.id,
      ));

      if (paymentResult.status == 'succeeded') {
        return StripeCustomResponse(
            success: true, message: 'Payment Successfuly');
      } else {
        return StripeCustomResponse(
            success: false, message: 'Cannot confirm payment');
      }
    } catch (e) {
      return StripeCustomResponse(success: false, message: e.message);
    }
  }
}
