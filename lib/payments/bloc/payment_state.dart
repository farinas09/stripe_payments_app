part of 'payment_bloc.dart';

@immutable
class PaymentState {
  final double paymentAmount;
  final String currency;
  final bool cardIsActive;
  final PaymentCard paymentCard;

  String get amountToPay => '${(this.paymentAmount * 100).floor()}';

  PaymentState({
    this.paymentAmount = 350.55,
    this.currency = 'USD',
    this.cardIsActive = false,
    this.paymentCard,
  });

  PaymentState copyWith({
    paymentAmount,
    currency,
    cardIsActive,
    paymentCard,
  }) =>
      PaymentState(
        paymentAmount: paymentAmount ?? this.paymentAmount,
        currency: currency ?? this.currency,
        cardIsActive: cardIsActive ?? this.cardIsActive,
        paymentCard: paymentCard ?? this.paymentCard,
      );
}
