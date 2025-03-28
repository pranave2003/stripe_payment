import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../payment.dart';
import '../BlocLayer/payment_bloc.dart';
import '../BlocLayer/payment_event.dart';
import '../BlocLayer/payment_state.dart';
import 'DonePayment.dart';

class Payscreen extends StatelessWidget {
  const Payscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Center(
        child: BlocConsumer<PaymentBloc, PaymentState>(
          listener: (context, state) {
            if (state is PaymentSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const Donepayment()),
              );
            } else if (state is PaymentFailed) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(state.error)));
            }
          },
          builder: (context, state) {
            return ElevatedButton(
              onPressed:
                  state is PaymentProcessing
                      ? null
                      : () {
                        context.read<PaymentBloc>().add(
                          MakePaymentEvent(amount: "5000", currency: "USD"),
                        );
                      },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                textStyle: const TextStyle(fontSize: 18),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child:
                  state is PaymentProcessing
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text("Pay \500"),
            );
          },
        ),
      ),
    );
  }
}
