import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shake/shake.dart';
import 'package:url_launcher/url_launcher.dart';

class SafeHome extends StatefulWidget {
  @override
  _SafeHomeState createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  ShakeDetector? _shakeDetector;
  Timer? _sosCancelTimer;
  bool _isShakeTriggered = false;

  @override
  void initState() {
    super.initState();
    _initializeShakeDetector();
  }

  void _initializeShakeDetector() {
    _shakeDetector = ShakeDetector.autoStart(
      onPhoneShake: _handleShakeEvent,
      shakeThresholdGravity: 2.7, // Adjust sensitivity if needed
    );
  }

  void _handleShakeEvent() {
    if (_isShakeTriggered) return; // Prevent multiple triggers

    setState(() {
      _isShakeTriggered = true;
    });

    // Show confirmation dialog with 5-second countdown
    _showShakeConfirmationDialog();
  }

  void _showShakeConfirmationDialog() {
    int countdown = 5;

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing by tapping outside
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            _sosCancelTimer = Timer.periodic(Duration(seconds: 1), (timer) {
              if (countdown > 1) {
                setDialogState(() {
                  countdown--;
                });
              } else {
                timer.cancel();
                Navigator.of(context).pop(); // Close dialog
                _sendSOSAlert(); // Send alert if not canceled
              }
            });

            return AlertDialog(
              title: Text("Emergency Alert"),
              content: Text("Sending SOS in $countdown seconds.\nPress 'Cancel' to stop."),
              actions: [
                TextButton(
                  onPressed: () {
                    _sosCancelTimer?.cancel();
                    setState(() {
                      _isShakeTriggered = false;
                    });
                    Navigator.of(context).pop(); // Close dialog
                  },
                  child: Text("Cancel", style: TextStyle(color: Colors.red)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _sendSOSAlert() async {
    List<String> emergencyContacts = [
      "+917671087632",
      "+919398871849",
      "+917842661978",
      "+918309426011",
      "+919502467614",
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

        if (await canLaunchUrl(smsUri, mode: LaunchMode.externalApplication)) {
          await launchUrl(smsUri, mode: LaunchMode.externalApplication);
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
    _shakeDetector?.stopListening();
    _sosCancelTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: InkWell(
        onTap: _sendSOSAlert, // Manually send SOS on tap
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            height: 180, // Fixed height to prevent infinite constraints
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 180, // Constrain height to prevent infinite size issue
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ListTile(
                          title: Text("Send Location"),
                          subtitle: Text("Tap to share location"),
                        ),
                      ],
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/route.jpg',
                    fit: BoxFit.cover,
                    height: 180, // Ensure image does not take infinite height
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

