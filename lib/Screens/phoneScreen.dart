import 'package:dealsdrays_app/Services/otpServices.dart';
import 'package:dealsdrays_app/Screens/otpScreen.dart';
import 'package:flutter/material.dart';

class PhoneLoginScreen extends StatefulWidget {
  @override
  _PhoneLoginScreenState createState() => _PhoneLoginScreenState();
}

class _PhoneLoginScreenState extends State<PhoneLoginScreen> {
  TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                // Logo
                Image.asset(
                  'Assets/DealsDray_Logo.png',
                  height: 250,
                  width: 300,
                ),
                // Tabs for Phone and Email
                Container(
                  height: 40,
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  child: TabBar(
                    indicator: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: Colors.white,
                    unselectedLabelColor: Colors.grey,
                    tabs: [
                      Tab(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: const Text("Phone"))),
                      Tab(
                          child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 2),
                              child: const Text("Email"))),
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                // Title
                const Text(
                  "Glad to see you!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please provide your phone number",
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 20),
                // Phone Input
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 300,
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone",
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: () async {
                    final phoneNumber = _phoneController.text.trim();

                    // Validate phone number length and content
                    if (phoneNumber.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Please enter a phone number")),
                      );
                    } else if (phoneNumber.length != 10 ||
                        !RegExp(r'^[0-9]{10}$').hasMatch(phoneNumber)) {
                      // Check if phone number is exactly 10 digits and contains only numbers
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                                "Please enter a valid 10-digit phone number")),
                      );
                    } else {
                      // Send OTP if validation is successful
                      final isSuccessful = await OtpService.sendOtp(
                        mobileNumber: phoneNumber,
                        context: context,
                      );

                      if (isSuccessful) {
                        // Navigate to OTP Verification Screen on success
                        Navigator.push(
                          // ignore: use_build_context_synchronously
                          context,
                          MaterialPageRoute(
                            builder: (context) => OTPVerificationScreen(
                              phoneNumber: phoneNumber,
                            ),
                          ),
                        );
                      } else if (!isSuccessful) {
                        // ignore: use_build_context_synchronously
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text("Please enter a phone number")),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    fixedSize: const Size(300, 50),
                  ),
                  child: const Text(
                    "SEND CODE",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
