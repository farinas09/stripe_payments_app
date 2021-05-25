import 'package:flutter/material.dart';
import 'package:flutter_credit_card/credit_card_widget.dart';
import 'package:stripe_app/payments/payment_button.dart';

import 'models/payment_card.dart';

class CardsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final card = PaymentCard(
        cardNumberHidden: '4242',
        cardNumber: '4242424242424242',
        brand: 'visa',
        cvv: '213',
        expiracyDate: '01/25',
        cardHolderName: 'Erick Farinas');
    return Scaffold(
        appBar: AppBar(
          title: Text('Complete Payment'),
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
