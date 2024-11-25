import 'dart:convert';
import 'package:dealsdrays_app/model/sharedPeferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class OtpService {
  static const String _url = 'http://devapiv4.dealsdray.com/api/v2/user/otp';

  static Future<bool> sendOtp({
    required String mobileNumber,
    required BuildContext context,
  }) async {
    try {
      // Example deviceId, fetched dynamically
      final deviceId = await SharedPreferencesService.getDeviceId();

      // Prepare the request body
      final body = jsonEncode({
        'mobileNumber': mobileNumber,
        'deviceId': deviceId,
      });

      // Send the POST request
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Debugging logs
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Extract userId from the response
        final String userId = responseData['data']['userId'];
        await SharedPreferencesService.saveUserId(userId);

        print("User ID saved: ${await SharedPreferencesService.getUserId()}");
        print("OTP sent successfully!");

        // Return success
        return true;
      } else {
        // Handle API failure
        print("Failed to send OTP. Status code: ${response.statusCode}");
        print("Response: ${response.body}");

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP. Please try again.')),
        );

        return false;
      }
    } catch (error) {
      // Handle unexpected errors
      print("Error occurred: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred. Please try again later.')),
      );

      return false;
    }
  }
}
