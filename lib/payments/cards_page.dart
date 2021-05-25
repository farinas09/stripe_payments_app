import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/payments/bloc/payment_bloc.dart';
import 'package:stripe_app/payments/payment_button.dart';

class CardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final card = context.read<PaymentBloc>().state.paymentCard;

    return Scaffold(
        appBar: AppBar(
          title: Text('Complete Payment'),
          leading: IconButton(
            icon: Icon(CupertinoIcons.chevron_back),
            onPressed: () {
              context.read<PaymentBloc>().add(OnCardUnselect());
              Navigator.pop(context);
            },
          ),
        ),
        body: Stack(
          children: [
            Container(),
            Hero(
              tag: card.cardNumber,
              child: CreditCardWidget(
                  cardNumber: card.cardNumber,
                  expiryDate: card.expiracyDate,
                  cardHolderName: card.cardHolderName,
                  cvvCode: card.cvv,
                  showBackView: false),
            ),
            Positioned(bottom: 0, child: PaymentButton())
          ],
        ));
  }
}
