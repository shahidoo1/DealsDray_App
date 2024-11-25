import 'package:dealsdrays_app/Services/emailRegistration.dart';
import 'package:dealsdrays_app/model/sharedPeferences.dart';

import 'package:flutter/material.dart';

class EmailRegistrationScreen extends StatefulWidget {
  @override
  _EmailRegistrationScreenState createState() =>
      _EmailRegistrationScreenState();
}

class _EmailRegistrationScreenState extends State<EmailRegistrationScreen> {
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  final FocusNode _referralFocusNode = FocusNode();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _referralController = TextEditingController();

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _referralFocusNode.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _referralController.dispose();
    super.dispose();
  }

  // Function to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'Assets/DealsDray_Logo.png',
                height: 250,
                width: 300,
              ),
              const Text(
                "Let's Begin!",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Please enter your credentials to proceed",
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 300,
                    child: TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                      ),
                      controller: _emailController,
                      focusNode: _emailFocusNode,
                      textInputAction: TextInputAction.next,
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_passwordFocusNode);
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Create Password",
                  ),
                  controller: _passwordController,
                  focusNode: _passwordFocusNode,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) {
                    FocusScope.of(context).requestFocus(_referralFocusNode);
                  },
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: TextFormField(
                  decoration: const InputDecoration(
                    labelText: "Referral Code (Optional)",
                  ),
                  controller: _referralController,
                  focusNode: _referralFocusNode,
                  textInputAction: TextInputAction.done,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await EmailRegistrationServices.registerUser(
                    context: context,
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    referralCode: _referralController.text.trim(),
                    userId: SharedPreferencesService.getUserId()
                        .toString(), // userId retrieved from SharedPreferences or another method
                  );

                  //_registerUser(); // Call the API when the button is pressed
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
                  "CONTINUE",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
