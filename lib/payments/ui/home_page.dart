import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:stripe_app/payments/bloc/payment_bloc.dart';
import 'package:stripe_app/payments/ui/cards_page.dart';
import 'package:stripe_app/payments/data/test_data.dart';
import 'package:stripe_app/payments/helpers/helpers.dart';
import 'package:stripe_app/payments/ui/payment_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/payments/services/stripe_service.dart';

class HomePage extends StatelessWidget {
  final stripeService = new StripeService();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final paymentBloc = context.read<PaymentBloc>();
    return Scaffold(
        appBar: AppBar(
          title: Text('Complete Payment'),
          actions: [
            IconButton(
                icon: Icon(Icons.add),
                onPressed: () async {
                  showLoading(context);
                  final currency = paymentBloc.state.currency;
                  final amount = paymentBloc.state.amountToPay;
                  final response = await stripeService.payWithNewCard(
                      amount: amount, currency: currency);
                  Navigator.pop(context);
                  if (response.success) {
                    showAlert(context, 'Success', 'Success');
                  } else {
                    print(response.message);
                    if (response.message != 'Cancelled by user') {
                      showAlert(context, 'Error', response.message);
                    }
                  }
                }),
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
                      context.read<PaymentBloc>().add(OnCardSelected(card));
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
