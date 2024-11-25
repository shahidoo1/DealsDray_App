import 'package:dealsdrays_app/Screens/homescreen.dart';
import 'package:dealsdrays_app/Screens/splashScreen.dart';
import 'package:dealsdrays_app/Screens/emailRegistrationScreen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DealsDray App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      // Registering named routes
      initialRoute: '/', // Initial route is the splash screen
      routes: {
        '/': (context) => SplashScreen(), // Home screen route
        '/home': (context) => HomeScreen(), // Navigate to home screen
        '/emailRegistration': (context) =>
            EmailRegistrationScreen(), // Navigate to email registration screen
      },
    );
  }
}
