import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
// Import the success page

class HomeScreen_payment extends StatefulWidget {
  const HomeScreen_payment({super.key});

  @override
  State<HomeScreen_payment> createState() => _HomeScreen_paymentState();
}

class _HomeScreen_paymentState extends State<HomeScreen_payment> {
  final String publishableKey = "pk_test_51R7TtNQRW8Q2GZ29K4rUWMv5WslGdKOdNQJYZWR4FtMXU9R9xid647GxU8aONf2iWDYrSIEbal3VyTcWaiZKiESR00RMnyY8fM";
  final String secretKey = "sk_test_51R7TtNQRW8Q2GZ295WxEb30QXYwU2cQ5ImIm7waGxrV0rMWWUHpZPQjWUiYyjdowCJXYWFmQuiRtjzbmo5mkejIo00wlR5EnUd";

  double amount = 100; // Amount in USD
  Map<String, dynamic>? intentPaymentData;

  // Show Payment Sheet
  Future<void> showPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        intentPaymentData = null;

        // Navigate to Payment Success Page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const PaymentSuccessPage()),
        );
      }).onError((error, stackTrace) {
        if (kDebugMode) {
          print("Error: $error \n$stackTrace");
        }
      });
    } on StripeException catch (error) {
      if (kDebugMode) {
        print("Stripe Exception: $error");
      }
      showDialog(
        context: context,
        builder: (c) => const AlertDialog(content: Text("Payment Cancelled")),
      );
    } catch (e, s) {
      if (kDebugMode) {
        print("Error: $e \n$s");
      }
    }
  }

  // Make Payment
  Future<Map<String, dynamic>?> makePayment(String amountCharged, String currency) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": (int.parse(amountCharged) * 100).toString(), // Convert to cents
        "currency": currency,
        "payment_method_types[]": "card",
      };

      var response = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentInfo,
        headers: {
          "Authorization": "Bearer $secretKey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      if (kDebugMode) {
        print("Response from Stripe API: ${response.body}");
      }

      return jsonDecode(response.body);
    } catch (error) {
      if (kDebugMode) {
        print("Payment Error: $error");
      }
      return null;
    }
  }

  // Initialize Payment
  Future<void> initializePayment(String amountCharged, String currency) async {
    try {
      intentPaymentData = await makePayment(amountCharged, currency);
      if (intentPaymentData != null) {
        await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
            paymentIntentClientSecret: intentPaymentData!["client_secret"],
            merchantDisplayName: "MyApp",
          ),
        );
        showPaymentSheet();
      }
    } catch (error) {
      if (kDebugMode) {
        print("Payment Initialization Error: $error");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Payment")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            initializePayment(amount.round().toString(), "USD");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: const TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("Pay \$${amount.toStringAsFixed(2)}"),
        ),
      ),
    );
  }
}





class PaymentSuccessPage extends StatelessWidget {
  const PaymentSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Payment Successful")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 80),
            const SizedBox(height: 20),
            const Text(
              "Payment Successful!",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("Thank you for your payment."),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Go back to Home
              },
              child: const Text("Back to Home"),
            ),
          ],
        ),
      ),
    );
  }
}
