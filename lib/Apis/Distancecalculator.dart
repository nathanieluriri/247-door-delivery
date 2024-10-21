import 'dart:convert';
import 'package:http/http.dart' as http;


import 'dart:async';

Future<double?> getDistance({
  required String originPlaceId,
  required String destinationPlaceId,
  int retryCount = 0,  // Retry counter
  int maxRetries = 5,  // Maximum retries
}) async {
  final url = Uri.parse(
      'https://distanceapi-i86r19cj.b4a.run/get_distance/?origin_place_id=$originPlaceId&destination_place_id=$destinationPlaceId');

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['distance_miles'] as double?;
    } else {
      print('Error: Unable to fetch distance (Status code: ${response.statusCode}). Retrying in 20 seconds...');
      if (retryCount < maxRetries) {
        await Future.delayed(Duration(seconds: 20));
        return await getDistance(
            originPlaceId: originPlaceId,
            destinationPlaceId: destinationPlaceId,
            retryCount: retryCount + 1, // Increment the retry count
            maxRetries: maxRetries);
      } else {
        print('Max retries reached. Unable to fetch distance.');
        return null;
      }
    }
  } catch (e) {
    print('Error: $e. Retrying in 20 seconds...');
    if (retryCount < maxRetries) {
      await Future.delayed(Duration(seconds: 30));
      return await getDistance(
          originPlaceId: originPlaceId,
          destinationPlaceId: destinationPlaceId,
          retryCount: retryCount + 1,
          maxRetries: maxRetries);
    } else {
      print('Max retries reached. Unable to fetch distance.');
      return null;
    }
  }
}
