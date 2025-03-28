import 'dart:async';
import 'package:flutter/material.dart';
import 'package:strip/Paymentintegration/UI_Layer/payHome.dart';

class Donepayment extends StatefulWidget {
  const Donepayment({super.key});

  @override
  _DonepaymentState createState() => _DonepaymentState();
}

class _DonepaymentState extends State<Donepayment> {
  int _countdown = 7; // Start countdown from 5 seconds

  @override
  void initState() {
    super.initState();
    startCountdown();
  }

  void startCountdown() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown == 1) {
        timer.cancel();
        navigateToHome();
      } else {
        setState(() {
          _countdown--;
        });
      }
    });
  }

  void navigateToHome() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          return Payscreen();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green.shade900, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful!",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "Thank you for your payment.",
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30),
            Text(
              "Redirecting to home in $_countdown seconds...",
              style: const TextStyle(fontSize: 16, color: Colors.white),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
