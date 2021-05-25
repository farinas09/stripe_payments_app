import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stripe_app/payments/bloc/payment_bloc.dart';
import 'package:stripe_app/payments/cards_page.dart';
import 'package:stripe_app/payments/home_page.dart';
import 'package:stripe_app/payments/services/stripe_service.dart';
import 'package:stripe_app/payments/success_payment.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    new StripeService()..init();
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PaymentBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.light().copyWith(
          primaryColor: Color(0xff284879),
          scaffoldBackgroundColor: Colors.blue[50],
        ),
        title: 'Stripe App',
        initialRoute: 'home',
        routes: {
          'home': (_) => HomePage(),
          'cards': (_) => CardsPage(),
          'success': (_) => SuccessPayment(),
        },
      ),
    );
  }
}
