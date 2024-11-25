import 'dart:convert';
import 'dart:io';
import 'package:dealsdrays_app/model/sharedPeferences.dart';
import 'package:dealsdrays_app/Screens/phoneScreen.dart';
import 'package:http/http.dart' as http;
import 'package:dealsdrays_app/model/DeviceInfoModel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    sendDeviceInfo();
    checkFirstLaunch();
  }

  Future<void> checkFirstLaunch() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if the app is launched for the first time
    final isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // App launched for the first time
      await prefs.setBool('isFirstLaunch', false);
      sendDeviceInfo(); // Call sendDeviceInfo on first launch
    } else {
      // Navigate directly to the next screen
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => PhoneLoginScreen()),
        (Route<dynamic> route) =>
            false, // This condition removes all previous screens
      );
    }
  }

  Future<void> sendDeviceInfo() async {
    const String url = "http://devapiv4.dealsdray.com/api/v2/user/device/add";

    try {
      // Gather all device info
      final deviceId = await getDeviceId();
      final deviceName = await getDeviceName();
      final deviceOSVersion = await getOSVersion();
      final deviceIPAddress = await getIPAddress();
      final position = await getCurrentLocation();
      final appInfo = await getAppInfo();

// Print all details in a structured format
      print("===== Device Info =====");
      print("Device ID: $deviceId");
      print("Device Name: $deviceName");
      print("OS Version: $deviceOSVersion");
      print("IP Address: $deviceIPAddress");
      print("Latitude: ${position.latitude}");
      print("Longitude: ${position.longitude}");
      print("===== App Info =====");
      print("App Version: ${appInfo.version}");
      print("Install Timestamp: ${appInfo.installTimeStamp}");
      print("Uninstall Timestamp: ${appInfo.uninstallTimeStamp}");
      print("Download Timestamp: ${appInfo.downloadTimeStamp}");

      // Create model instance
      final deviceInfo = DeviceInfoModel(
        deviceType: "android",
        deviceId: deviceId,
        deviceName: deviceName,
        deviceOSVersion: deviceOSVersion,
        deviceIPAddress: deviceIPAddress,
        latitude: position.latitude,
        longitude: position.longitude,
        buyerGcmId: "",
        buyerPemId: "",
        appInfo: appInfo,
      );
      // Convert to JSON and print
      final deviceInfoJson = jsonEncode(deviceInfo.toJson());
      print("===== JSON Payload =====");
      print(deviceInfoJson);
      // Send POST request
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(deviceInfo.toJson()),
      );
      print("Response received. Status code: ${response.statusCode}");
      if (response.statusCode == 200) {
        await SharedPreferencesService.saveDeviceId(deviceInfo.deviceId);
        print(
            await SharedPreferencesService.getDeviceId()); // Correctly awaited

        print("Device info sent successfully!");
        // Navigate to the next screen on success
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  PhoneLoginScreen()), // Replace `NextScreen` with your actual next screen widget
        );
      } else {
        print(
            "Failed to send device info. Status code: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (error) {
      print("Error occurred: $error");
    }
  }

  // Get Device ID
  Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id;
  }

  // Get Device Name
  Future<String> getDeviceName() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return "${androidInfo.brand} ${androidInfo.model}";
  }

  // Get OS Version
  Future<String> getOSVersion() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    final androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.release;
  }

  // Get IP Address
  Future<String> getIPAddress() async {
    for (var interface in await NetworkInterface.list()) {
      for (var address in interface.addresses) {
        if (address.type == InternetAddressType.IPv4) {
          return address.address;
        }
      }
    }
    return "Unknown";
  }

  // Get Current Location
  Future<Position> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }

  // Get App Info
  Future<AppInfo> getAppInfo() async {
    final PackageInfo packageInfo = await PackageInfo.fromPlatform();

    return AppInfo(
      version: packageInfo.version,
      installTimeStamp: DateTime.now().toIso8601String(),
      uninstallTimeStamp: DateTime.now().toIso8601String(),
      downloadTimeStamp: DateTime.now().toIso8601String(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('Assets/Converted_SplashScreen.png'),
            fit: BoxFit.cover, // Ensure the image covers the entire screen
          ),
        ),
      ),
    );
  }
}
