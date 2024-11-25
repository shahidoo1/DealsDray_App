import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class VerifyOtpServices {
  static const String _otpVerificationUrl =
      'http://devapiv4.dealsdray.com/api/v2/user/otp/verification';

  /// Sends OTP verification request and handles navigation or error display
  static Future<void> verifyOtpAndNavigate({
    required BuildContext context,
    required String otp,
    required String deviceId,
    required String userId,
  }) async {
    final body = jsonEncode({
      "otp": otp,
      "deviceId": deviceId,
      "userId": userId,
    });

    try {
      final response = await http.post(
        Uri.parse(_otpVerificationUrl),
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 1) {
          // OTP verified successfully, navigate to Home screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('OTP Verified Successfully!')),
          );
          Navigator.pushReplacementNamed(context, '/home');
        } else if (data['status'] == 0) {
          // OTP verification failed, navigate to Email Registration screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('OTP verification failed. Please try again.')),
          );
          Navigator.pushReplacementNamed(context, '/emailRegistration');
        } else if (data['status'] == 3) {
          // Invalid OTP, show the message from the API
          final message = data['data']['message'] ?? 'Invalid OTP';
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        } else {
          // Handle unexpected status values
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Unexpected response.')),
          );
        }
      } else {
        final error = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${error['message']}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('An error occurred. Please try again.')),
      );
    }
  }
}
