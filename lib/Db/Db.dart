import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MongoDb{
  String sanitizeInput(String input) {
    // Escape special characters to prevent injection
    return input
        .replaceAll('\$', '\\\$')  // Escape dollar signs
        .replaceAll('\'', '\\\'')  // Escape single quotes
        .replaceAll('\"', '\\\"')  // Escape double quotes
        .replaceAll('\n', '\\n')    // Escape new lines
        .replaceAll('\r', '\\r')    // Escape carriage returns
        .replaceAll('`', '\\`');     // Escape backticks
  }




// Updated function to accept Map for details
  Future<void> addUser({
    required String name,
    required String imageid,
    required String phoneNumber,
    required String email,
    required String additional_info,
    required Map<String, dynamic> pickUpDetails,
    required Map<String, dynamic> dropOffDetails,
    required Map<String, dynamic> schedule,
  }) async {
    // Define the URL for the FastAPI add_user endpoint
    final url = Uri.parse('https://api.247doordelivery.co.uk/add_user/');
int image_id = int.parse(imageid);
    // Create the user data to be sent in the request body
    final userData = {
      "name": sanitizeInput(name),
      "phone_number": sanitizeInput(phoneNumber),
      "email": sanitizeInput(email),
      "pick_up_details": pickUpDetails,  // Use Map directly
      "drop_off_details": dropOffDetails, // Use Map directly
      "schedule": schedule, // Use Map directly
      "image_id": image_id,
      "additional_info": sanitizeInput(additional_info)
    };

    try {
      // Make the POST request
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(userData),  // Convert the user data to JSON
      );

      // Check for a successful response
      if (response.statusCode == 200) {
        // Parse the response
        final responseData = jsonDecode(response.body);
        print('User added successfully: ${responseData}');
      } else {
        // Handle errors
        print('Failed to add user: ${response.statusCode} ${response.body}');
      }
    } catch (error) {
      print('Error occurred: $error');
    }
  }


}


