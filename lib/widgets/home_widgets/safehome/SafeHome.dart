import 'package:background_sms/background_sms.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SafeHome extends StatefulWidget {
  @override
  _SafeHomeState createState() => _SafeHomeState();
}

class _SafeHomeState extends State<SafeHome> {
  // Define the contacts to send the alert
  List<String> contacts = [
    "+917671087632",
    "+919398871849",
    "+917842661978",
    "+918309426011",
    "+919502467614"
  ];

  // Method to get current location
  Future<Position> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    return position;
  }

  Future<void> sendSOSAlert(Position position) async {
    String locationUrl = "https://www.google.com/maps?q=${position.latitude},${position.longitude}";
    String message = "I am in danger! Please help. My location: $locationUrl";

    for (String contact in contacts) {
      // Send SMS to the contact
      SmsStatus result = await BackgroundSms.sendMessage(phoneNumber: contact, message: message);

      // Log the result for each contact
      if (result == SmsStatus.sent) {
        print("SMS sent successfully to $contact");
      } else {
        print("Failed to send SMS to $contact");
      }

      // Optional: Add a slight delay to avoid overlapping operations
      await Future.delayed(Duration(milliseconds: 500));
    }

    // Show success message after all messages are attempted
    Fluttertoast.showToast(msg: "SOS alerts sent!");
  }

  // Function to show modal when the card is tapped
  void showModelSafeHome(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Safe Home'),
          content: Text('Sending SOS alert to your contacts'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        Position position = await _getCurrentLocation();
        sendSOSAlert(position);
        showModelSafeHome(context);
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.8,
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center, // Center the text
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text("Send Location"),
                      subtitle: Text("Share Location"),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/route.jpg',
                  fit: BoxFit.cover,
                  height: 180,
                  width: MediaQuery.of(context).size.width * 0.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
