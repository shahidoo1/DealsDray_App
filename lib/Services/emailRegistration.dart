import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailRegistrationServices {
  static const String _registrationUrl =
      'http://devapiv4.dealsdray.com/api/v2/user/email/referral';

  /// Registers a user and handles navigation or error display
  static Future<void> registerUser({
    required BuildContext context,
    required String email,
    required String password,
    String? referralCode,
    required String userId,
  }) async {
    final Map<String, String> data = {
      'email': email,
      'password': password,
      if (referralCode != null && referralCode.isNotEmpty)
        'referral_code': referralCode,
      'userId': userId,
    };

    try {
      final response = await http.post(
        Uri.parse(_registrationUrl),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: data,
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data['status'] == 1 &&
            data['data']?['message'] == 'Successfully Added') {
          // Registration successful, navigate to Home screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration Successful!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          // Show error message and stay on the current screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Registration failed. Please try again.')),
          );
        }
      } else {
        // Handle unsuccessful response
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error['message']}')),
        );
      }
    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}
