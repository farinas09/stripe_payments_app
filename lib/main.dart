import 'package:flutter/material.dart';
import 'package:stripe_app/payments/cards_page.dart';
import 'package:stripe_app/payments/home_page.dart';
import 'package:stripe_app/payments/success_payment.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        primaryColor: Color(0xff284879),
        scaffoldBackgroundColor: Color(0xff21232a),
      ),
      title: 'Stripe App',
      initialRoute: 'success',
      routes: {
        'home': (_) => HomePage(),
        'cards': (_) => CardsPage(),
        'success': (_) => SuccessPayment(),
      },
    );
  }
}
