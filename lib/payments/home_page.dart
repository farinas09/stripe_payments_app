import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_app/payments/cards_page.dart';
import 'package:stripe_app/payments/data/test_data.dart';
import 'package:stripe_app/payments/helpers/helpers.dart';
import 'package:stripe_app/payments/payment_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text('Complete Payment'),
          actions: [
            IconButton(icon: Icon(Icons.add), onPressed: () {}),
          ],
        ),
        body: Stack(
          children: [
            Positioned(
              width: size.width,
              height: size.height,
              top: 100,
              child: PageView.builder(
                controller: PageController(viewportFraction: 0.9),
                physics: BouncingScrollPhysics(),
                itemCount: cardsList.length,
                itemBuilder: (_, index) {
                  final card = cardsList[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context, fadeInNavigation(context, CardsPage()));
                    },
                    child: Hero(
                      tag: card.cardNumber,
                      child: CreditCardWidget(
                          cardNumber: card.cardNumber,
                          expiryDate: card.expiracyDate,
                          cardHolderName: card.cardHolderName,
                          cvvCode: card.cvv,
                          showBackView: false),
                    ),
                  );
                },
              ),
            ),
            Positioned(bottom: 0, child: PaymentButton())
          ],
        ));
  }
}
