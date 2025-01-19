import 'dart:math'; // Import required for Random
import 'package:flutter/material.dart';
import 'widgets/home_widgets/custom_appBar.dart';
import 'utils/quotes.dart';
import 'widgets/home_widgets/CustomCarouel.dart';
import 'widgets/home_widgets/emergency.dart';
import 'widgets/live_safe.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qIndex = 0;

  // Method to get a random quote index
  getRandomQuote() {
    Random random = Random();
    // Ensure the index is within range
    setState(() {
      qIndex = random.nextInt(sweetSayings.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getRandomQuote();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(  // Wrap the Column with SingleChildScrollView
            child: Column(
              children: [
                CustomAppBar(
                  quoteIndex: qIndex,
                  onTap: getRandomQuote, // Call the method to generate the quote index
                ),
                CustomCarouel(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Emergency",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                Emergency(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Explore Livesafe Locations",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                LiveSafe(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
