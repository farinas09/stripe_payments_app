import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:stripe_app/payments/models/payment_intent_response.dart';
import 'package:stripe_app/payments/models/stripe_response.dart';
import 'package:stripe_payment/stripe_payment.dart';
import '.env.dart';

class StripeService {
  StripeService._privateConstructor();
  static final StripeService _instance = StripeService._privateConstructor();

  factory StripeService() => _instance;

  String _paymentApiURL = 'https://api.stripe.com/v1/payment_intents';

  final headerOptions = new Options(
      contentType: Headers.formUrlEncodedContentType,
      headers: {'Authorization': 'Bearer $key'});

  void init() {
    StripePayment.setOptions(StripeOptions(
        publishableKey: apiKey, merchantId: "test", androidPayMode: 'test'));
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

  Future<StripeCustomResponse> payWithAppleGoogle({
    @required String amount,
    @required currency,
  }) async {
    final amountPay = double.parse(amount) / 100;
    try {
      final paymentToken = await StripePayment.paymentRequestWithNativePay(
        androidPayOptions: AndroidPayPaymentRequest(
            currencyCode: currency, totalPrice: amount),
        applePayOptions: ApplePayPaymentOptions(
            countryCode: 'US',
            currencyCode: currency,
            items: [
              ApplePayItem(amount: '$amountPay', label: 'Product detail')
            ]),
      );
      final paymentMethod = await StripePayment.createPaymentMethod(
        PaymentMethodRequest(
          card: CreditCard(token: paymentToken.tokenId),
        ),
      );

      final resp = await this._finishPayment(
        amount: amount,
        currency: currency,
        paymentMethod: paymentMethod,
      );

      await StripePayment.completeNativePayRequest();
      return resp;
    } catch (e) {
      return StripeCustomResponse(
        success: false,
        message: e.message,
      );
    }
  }

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
