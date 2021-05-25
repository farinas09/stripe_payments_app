import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:stripe_app/payments/bloc/payment_bloc.dart';
import 'package:stripe_app/payments/services/stripe_service.dart';
import 'package:stripe_payment/stripe_payment.dart';

import 'helpers/helpers.dart';

class PaymentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final paymentBloc = context.read<PaymentBloc>();
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 100.0,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            blurRadius: 5.0,
            color: Colors.grey,
            offset: Offset(0, 5),
          )
        ],
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        color: Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Total',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${paymentBloc.state.paymentAmount} ${paymentBloc.state.currency}',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          BlocBuilder<PaymentBloc, PaymentState>(
            builder: (context, state) {
              return _PayButton(state: state);
            },
          )
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  final PaymentState state;

  const _PayButton({Key key, @required this.state}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return state.cardIsActive
        ? buidCardButton(context)
        : buildAppleAndGooglePay(context);
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      color: Theme.of(context).primaryColor,
      elevation: 0.0,
      child: Row(
        children: [
          Icon(
            Platform.isAndroid
                ? FontAwesomeIcons.google
                : FontAwesomeIcons.apple,
            color: Colors.white,
          ),
          Text(
            ' Pay',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
      onPressed: () {},
    );
  }

  Widget buidCardButton(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      color: Theme.of(context).primaryColor,
      elevation: 0.0,
      child: Row(
        children: [
          Icon(
            FontAwesomeIcons.creditCard,
            color: Colors.white,
          ),
          Text(
            '  Pay',
            style: Theme.of(context).textTheme.headline6.copyWith(
                  color: Colors.white,
                ),
          ),
        ],
      ),
      onPressed: () async {
        final stripeService = StripeService();
        final blocState = context.read<PaymentBloc>().state;
        final card = state.paymentCard;
        final monthYear = card.expiracyDate.split('/');
        showLoading(context);

        final response = await stripeService.payWithExistingCard(
            amount: blocState.amountToPay,
            currency: state.currency,
            card: CreditCard(
              number: card.cardNumber,
              expMonth: int.parse(monthYear[0]),
              expYear: int.parse(monthYear[1]),
            ));
        Navigator.pop(context);
        if (response.success) {
          showAlert(context, 'Success', 'Success');
        } else {
          print(response.message);
          if (response.message != 'Cancelled by user') {
            showAlert(context, 'Error', response.message);
          }
        }
      },
    );
  }
}
