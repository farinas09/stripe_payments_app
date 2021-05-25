import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:stripe_app/payments/models/payment_card.dart';

part 'payment_event.dart';
part 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  PaymentBloc() : super(PaymentState());

  @override
  Stream<PaymentState> mapEventToState(PaymentEvent event) async* {
    if (event is OnCardSelected) {
      yield state.copyWith(cardIsActive: true, paymentCard: event.cardSelected);
    } else if (event is OnCardUnselect) {
      yield state.copyWith(cardIsActive: false);
    }
  }
}
