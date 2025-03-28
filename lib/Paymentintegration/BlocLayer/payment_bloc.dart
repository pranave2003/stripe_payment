import 'package:bloc/bloc.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:strip/Paymentintegration/BlocLayer/payment_event.dart';
import 'package:strip/Paymentintegration/BlocLayer/payment_state.dart';

import '../Datalayer/Repository/payment_repository.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository paymentRepository;

  PaymentBloc({required this.paymentRepository}) : super(PaymentInitial()) {
    on<MakePaymentEvent>((event, emit) async {
      emit(PaymentProcessing());

      try {
        // Get payment intent data
        final paymentIntentData = await paymentRepository.createPaymentIntent(
          event.amount,
          event.currency,
        );
        if (paymentIntentData == null) throw Exception("Payment Intent Failed");

        // Initialize Stripe payment sheet
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: paymentIntentData["client_secret"],
            merchantDisplayName: "MyApp",
          ),
        );

        // Show Payment Sheet
        await Stripe.instance.presentPaymentSheet();
        emit(PaymentSuccess());
      } catch (error) {
        emit(PaymentFailed(error: error.toString()));
      }
    });
  }
}
