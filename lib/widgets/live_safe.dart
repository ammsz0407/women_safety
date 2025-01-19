import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'live_safe/PoliceStationCard.dart'; // Assuming you have this card widget for each location.

class LiveSafe extends StatefulWidget {
  const LiveSafe({Key? key}) : super(key: key);

  @override
  _LiveSafeState createState() => _LiveSafeState();
}

class _LiveSafeState extends State<LiveSafe> {
  List<Widget> policeStations = [];

  // Get current location
  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      Fluttertoast.showToast(msg: 'Location services are disabled.');
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        Fluttertoast.showToast(msg: 'Location permissions are denied.');
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Fluttertoast.showToast(msg: 'Location permissions are permanently denied.');
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  // Find nearby police stations
  Future<void> findNearbyPoliceStations(Position position) async {
    String url = 'https://overpass-api.de/api/interpreter?data=[out:json];node(around:10000,${position.latitude},${position.longitude})[amenity=police];out;';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        if (data['elements'].isEmpty) {
          Fluttertoast.showToast(msg: 'No nearby police stations found.');
        } else {
          List<Widget> stations = [];
          for (var element in data['elements']) {
            double lat = element['lat'];
            double lon = element['lon'];

            stations.add(
              PoliceStationCard(
                onMapFunction: openMap,
                policeStationsFuture: Future.value([
                  {'latitude': lat.toString(), 'longitude': lon.toString()},
                ]),  // This returns a future that resolves immediately with the list of stations
              ),
            );

          }

          // Update the UI after the layout phase
          WidgetsBinding.instance.addPostFrameCallback((_) {
            setState(() {
              policeStations = stations;
            });
          });
        }
      } else {
        Fluttertoast.showToast(msg: 'Failed to fetch data.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error: $e');
    }
  }

  // Open map with coordinates
  static Future<void> openMap(String latitude, String longitude) async {
    String osmUrl = 'https://www.openstreetmap.org/?mlat=$latitude&mlon=$longitude#map=16/$latitude/$longitude';

    final Uri _url = Uri.parse(osmUrl);
    try {
      await launchUrl(_url);
    } catch (e) {
      Fluttertoast.showToast(msg: 'Could not launch map!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
    child: Column(
    children: [
          ElevatedButton(
            onPressed: () async {
              Position position = await _getCurrentLocation();
              findNearbyPoliceStations(position);
            },
            child: Text('Find Nearby Police Stations'),
          ),
          SizedBox(height: 20),
          ...policeStations,
        ],
      ),
      ),
    );
  }
}
