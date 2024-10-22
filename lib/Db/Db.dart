import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class FirebaseDb{
  CollectionReference users = FirebaseFirestore.instance.collection('users');



// Updated function to accept Map for details
  Future<void> addUser({
    required String name,
    required String imageid,
    required String phoneNumber,
    required String email,
    required Map<String, dynamic> pickUpDetails,
    required Map<String, dynamic> dropOffDetails,
    required Map<String, dynamic> schedule,
  }) async {
    // Define the URL for the FastAPI add_user endpoint
    final url = Uri.parse('https://api.247doordelivery.co.uk/add_user/');
int image_id = int.parse(imageid);
    // Create the user data to be sent in the request body
    final userData = {
      "name": name,
      "phone_number": phoneNumber,
      "email": email,
      "pick_up_details": pickUpDetails,  // Use Map directly
      "drop_off_details": dropOffDetails, // Use Map directly
      "schedule": schedule, // Use Map directly
      "image_id": image_id
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


