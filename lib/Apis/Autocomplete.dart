import 'dart:convert';  // For encoding the request body
import 'package:http/http.dart' as http;

// Function to send the API request
Future<List> sendPlaceAutocompleteRequest(String input) async {
  List<dynamic> suggestions = [];
  const String apiKey = 'AIzaSyDBNzspYcUAQ__IEW97taBErU9edZKMGKg';  // Replace with your actual API key
  const String baseUrl = 'https://places.googleapis.com/v1/places:autocomplete';

  Map<String, dynamic> requestBody = {
    "input": input,
    "locationBias": {
      "circle": {
        "center": {
          "latitude": 9.103740,
          "longitude": -7.492060,
        },
        "radius": 500.0
      }
    }
  };

  try {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
        'X-Goog-Api-Key': apiKey,
      },
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      // Parse the response and update the state with the suggestions
      var responseData = jsonDecode(response.body);

      suggestions = responseData['suggestions'];  // Store the suggestions


    } else {
      print('Request failed with status: ${response.statusCode}');
      print('Error: ${response.body}');
    }
  } catch (error) {
    print('Error occurred on the last line in autocomplete: $error');
  }
  return suggestions;
}