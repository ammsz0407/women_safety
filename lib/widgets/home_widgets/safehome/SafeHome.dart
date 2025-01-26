import 'package:flutter/material.dart' show AlertDialog, AppBar, BuildContext, Center, Colors, Column, EdgeInsets, ElevatedButton, FontWeight, MainAxisAlignment, Navigator, Scaffold, ScaffoldMessenger, SizedBox, SnackBar, State, StatefulWidget, Text, TextAlign, TextButton, TextStyle, Widget, showDialog;
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:async';



class SafeHome extends StatefulWidget {
  @override
  _SafeHomeState createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  ShakeDetector? detector;
  bool isShakeTriggered = false;
  Timer? _cancelTimer;

  @override
  void initState() {
    super.initState();
    _initializeShakeDetector();
  }

  void _initializeShakeDetector() {
    detector = ShakeDetector.autoStart(
      onPhoneShake: () {
        if (!isShakeTriggered) {
          isShakeTriggered = true;
          _showCancelAlertDialog();
        }
      },
      shakeThresholdGravity: 2.7, // Adjust sensitivity if needed
      minimumShakeCount: 3, // Require 3 shakes before triggering
      shakeSlopTimeMS: 500, // Time between shakes
      shakeCountResetTime: 3000, // Reset counter after 3 seconds
    );
  }

  void _showCancelAlertDialog() {
    _cancelTimer = Timer(Duration(seconds: 5), () {
      _sendSOSAlert();
      isShakeTriggered = false; // Reset trigger after sending alert
    });

    showDialog(
      context: context,
      barrierDismissible: false, // Prevents accidental dismissal
      builder: (context) {
        return AlertDialog(
          title: Text("Emergency Alert"),
          content: Text("You shook the phone! Sending an alert in 5 seconds. Click Cancel if this was a mistake."),
          actions: [
            TextButton(
              onPressed: () {
                _cancelTimer?.cancel();
                isShakeTriggered = false;
                Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _sendSOSAlert() async {
    List<String> emergencyContacts = [
      "+917671087632"
          "+919398871849",
      "+917842661978",
      "+918309426011",
      "+919502467614",
// Add your contacts here
    ];

    String alertMessage = "🚨 EMERGENCY ALERT! 🚨\nI am in danger. Please help me.\nMy location: ";

    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      String locationUrl =
          "https://www.google.com/maps/search/?api=1&query=${position.latitude},${position.longitude}";

      String fullMessage = "$alertMessage $locationUrl";

      for (String contact in emergencyContacts) {
        Uri smsUri = Uri.parse("sms:$contact?body=${Uri.encodeComponent(fullMessage)}");

        if (await canLaunchUrl(smsUri)) {
          await launchUrl(smsUri);
        } else {
          print("Could not send SMS to $contact");
        }
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Emergency alert sent successfully!")),
      );
    } catch (e) {
      print("Error getting location: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to retrieve location.")),
      );
    }
  }

  @override
  void dispose() {
    detector?.stopListening();
    _cancelTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Safe Home"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Shake your phone 3 times to send an SOS alert.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _sendSOSAlert,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                backgroundColor: Colors.red,
              ),
              child: Text(
                "Send SOS Alert",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}