import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PaymentButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Container(
      height: 100.0,
      width: width,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
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
                '\$250',
                style: Theme.of(context).textTheme.headline6,
              ),
            ],
          ),
          _PayButton()
        ],
      ),
    );
  }
}

class _PayButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return true ? buidCardButton(context) : buildAppleAndGooglePay(context);
  }

  Widget buildAppleAndGooglePay(BuildContext context) {
    return MaterialButton(
      height: 45,
      minWidth: 150,
      shape: StadiumBorder(),
      color: Colors.black,
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
      color: Colors.black,
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
      onPressed: () {},
    );
  }
}
