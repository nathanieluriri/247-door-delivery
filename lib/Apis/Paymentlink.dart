import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;

Future<String?> createPaymentLink(double distance, int price, String currency,String origin , String destination, String pickupdate, String dropoffdate, String pickupTime, String dropOffTime) async {
  // FastAPI URL (replace with your actual server's IP/URL if different)
  destination = Uri.encodeComponent(destination);
  pickupTime = Uri.encodeComponent(pickupTime);
  pickupdate = Uri.encodeComponent(pickupdate);
  origin = Uri.encodeComponent(origin);
  dropoffdate = Uri.encodeComponent(dropoffdate);
  dropOffTime = Uri.encodeComponent(dropOffTime);
  currency = Uri.encodeComponent(currency);
  final url = Uri.parse("https://api.247doordelivery.co.uk/create-payment-link?distance=$distance&unitAmount=$price&currency=$currency&origin=$origin&destination=$destination&pickupDate=$pickupdate&pickupTime=$pickupTime&dropoffDate=$dropoffdate&dropoffTime=$dropOffTime");

  // No need to add body for the curl request (since we send data as query parameters)
  final headers = {
    "accept": "application/json",
  };

  try {
    // Sending POST request to the FastAPI endpoint
    final response = await http.post(url, headers: headers);

    // If the request was successful
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      log(jsonResponse);
      return jsonResponse.toString();  // Return the response (payment link)
    } else {
      print('Failed to create payment link. Status code: ${response.statusCode}');
      return null;
    }
  } catch (error) {
    print('Error occurred: $error');
    return null;
  }
}
