import 'dart:convert';
import 'package:http/http.dart' as http;

class PaymentRepository {
  final String secretKey =
      "sk_test_51R7TtNQRW8Q2GZ295WxEb30QXYwU2cQ5ImIm7waGxrV0rMWWUHpZPQjWUiYyjdowCJXYWFmQuiRtjzbmo5mkejIo00wlR5EnUd";

  Future<Map<String, dynamic>?> createPaymentIntent(
    String amount,
    String currency,
  ) async {
    try {
      Map<String, dynamic> paymentInfo = {
        "amount": (int.parse(amount) * 100).toString(), // Convert to cents
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

      return jsonDecode(response.body);
    } catch (error) {
      throw Exception("Payment API Error: $error");
    }
  }
}
