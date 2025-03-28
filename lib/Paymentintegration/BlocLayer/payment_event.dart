
import 'package:flutter/cupertino.dart';

@immutable
sealed class PaymentEvent {}


class MakePaymentEvent extends PaymentEvent {
  final String amount;
  final String currency;

  MakePaymentEvent({required this.amount, required this.currency});
}