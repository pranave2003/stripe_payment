import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  var Publishablekey =
      "pk_test_51R7TtNQRW8Q2GZ29K4rUWMv5WslGdKOdNQJYZWR4FtMXU9R9xid647GxU8aONf2iWDYrSIEbal3VyTcWaiZKiESR00RMnyY8fM";
  var Secretkey =
      "sk_test_51R7TtNQRW8Q2GZ295WxEb30QXYwU2cQ5ImIm7waGxrV0rMWWUHpZPQjWUiYyjdowCJXYWFmQuiRtjzbmo5mkejIo00wlR5EnUd";
  double amount = 10000;

  Map<String, dynamic>? intentpaymentData;

  showpaymentsheet() async {
    try {
      await Stripe.instance
          .presentPaymentSheet()
          .then((value) {
            intentpaymentData = null;
          })
          .onError((error, stackTrace) {
            if (kDebugMode) {
              print(error.toString() + stackTrace.toString());
            }
          });
    } on StripeException catch (error) {
      if (kDebugMode) {
        print(error);
      }

      showDialog(
        context: context,
        builder: (c) => const AlertDialog(content: Text("Cancelled")),
      );
    } catch (e, s) {
      if (kDebugMode) {
        print(s);
      }

      print(e);
    }
  }

  makepayment(amountcharged, currency) async {
    try {
      Map<String, dynamic>? paymentinfo = {
        "amount": (int.parse(amountcharged) * 100).toString(),
        "currency": currency,
        "payment_method_types[]": "card",
      };
      var responseFromStripeAPI = await http.post(
        Uri.parse("https://api.stripe.com/v1/payment_intents"),
        body: paymentinfo,

        headers: {
          "Authorization": "Bearer $Secretkey",
          "Content-Type": "application/x-www-form-urlencoded",
        },
      );

      print(
        "..........................................Response From API :" +
            responseFromStripeAPI.body,
      );

      return jsonDecode(responseFromStripeAPI.body);
    } catch (errrorMsg) {
      if (kDebugMode) {
        print(errrorMsg);
      }
      print(errrorMsg);
    }
  }

  paymentinitialization(amountcharged, currency) async {
    try {
      intentpaymentData = await makepayment(amountcharged, currency);
      await Stripe.instance
          .initPaymentSheet(
            paymentSheetParameters: SetupPaymentSheetParameters(
              allowsDelayedPaymentMethods: true,
              paymentIntentClientSecret: intentpaymentData!["client_secret"],
              style: ThemeMode.dark,
              merchantDisplayName: "MagicalDrone",
            ),
          )
          .then((value) {
            print(value);
          });
      showpaymentsheet();
    } catch (errrorMsg, s) {
      if (kDebugMode) {
        print(s);
      }
      print(errrorMsg);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Your button's onPressed logic here
            print("Pay button pressed!");

            paymentinitialization(amount.round().toString(), "USD");
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            textStyle: TextStyle(fontSize: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Text("Pay $amount"),
        ),
      ),
    );
  }
}
