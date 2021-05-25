part of 'payment_bloc.dart';

@immutable
abstract class PaymentEvent {}

class OnCardSelected extends PaymentEvent {
  final PaymentCard cardSelected;

  OnCardSelected(this.cardSelected);
}

class OnCardUnselect extends PaymentEvent {}
