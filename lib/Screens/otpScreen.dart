import 'dart:async';
import 'package:dealsdrays_app/Services/otpServices.dart';
import 'package:dealsdrays_app/Services/verifyOtp.dart';
import 'package:dealsdrays_app/model/sharedPeferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pinput/pinput.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String phoneNumber;

  const OTPVerificationScreen({
    super.key,
    required this.phoneNumber,
  });
  @override
  _OTPVerificationScreenState createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  late Timer _timer;
  int _remainingSeconds = 180; // 3 minutes in seconds
  final otpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    otpController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return "$minutes : $remainingSeconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            const Icon(
              Icons.sms_outlined,
              size: 80,
              color: Colors.red,
            ),
            const SizedBox(height: 20),
            const Text(
              "OTP Verification",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              "We have sent a unique OTP number to your mobile",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            Pinput(
              length: 4,
              autofocus: true,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: otpController,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () async {
                final otp = otpController.text.trim();
                if (otp.isEmpty || otp.length != 4) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter a valid 4-digit OTP.')),
                  );
                  return;
                }

                final deviceId = await SharedPreferencesService.getDeviceId();
                final userId = await SharedPreferencesService.getUserId();

                // Call the OtpService method
                await VerifyOtpServices.verifyOtpAndNavigate(
                  context: context,
                  otp: otp,
                  deviceId: deviceId.toString(),
                  userId: userId.toString(),
                );
              },
              child: const Text(
                "Verify OTP",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  _formatTime(_remainingSeconds),
                  style: const TextStyle(color: Colors.grey, fontSize: 16),
                ),
                TextButton(
                  onPressed: () {
                    OtpService.sendOtp(
                        mobileNumber: widget.phoneNumber, context: context);
                  },
                  child: const Text(
                    "SEND AGAIN",
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
