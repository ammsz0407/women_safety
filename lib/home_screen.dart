import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart'; // For animation effects
import 'widgets/home_widgets/custom_appBar.dart';
import 'utils/quotes.dart';
import 'widgets/home_widgets/CustomCarouel.dart';
import 'widgets/home_widgets/emergency.dart';
import 'widgets/live_safe.dart';
import 'widgets/home_widgets/safehome/SafeHome.dart';
import 'widgets/emergency_contacts.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int qIndex = 0;

  // Generate a random quote index
  getRandomQuote() {
    Random random = Random();
    setState(() {
      qIndex = random.nextInt(sweetSayings.length);
    });
  }

  @override
  void initState() {
    super.initState();
    getRandomQuote();
  }

  List<String> contacts = [];

  void updateContacts(List<String> updatedContacts) {
    setState(() {
      contacts = updatedContacts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF3ADAD), Color(0xFFFFFFFF)], // Vibrant gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Animated App Title
                  FadeInDown(
                    duration: Duration(milliseconds: 1000),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: Text(
                        "✨ A3 presents EmpowerHer App ✨",
                        textAlign: TextAlign.center,
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              blurRadius: 6,
                              offset: Offset(2, 3),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),

                  QuoteCard(
                    quoteIndex: qIndex,
                    onTap: getRandomQuote,
                  ),

                  CustomCarouel(),

                  _buildSectionTitle("Emergency"),
                  Emergency(),

                  _buildSectionTitle("Explore Livesafe Locations"),
                  LiveSafe(),

                  SafeHome(contacts: contacts, updateContacts: updateContacts),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Method to create stylish section titles
  Widget _buildSectionTitle(String text) {
    return AnimatedDefaultTextStyle(
      duration: Duration(seconds: 2),
      style: GoogleFonts.poppins(
        fontSize: 18,  // Smaller font size for a more subtle effect
        fontWeight: FontWeight.bold,
        color: Colors.white,
        letterSpacing: 1.1,
        shadows: [
          Shadow(
            offset: Offset(2.0, 2.0),  // Subtle shadow offset
            blurRadius: 5.0,  // Mild blur effect for the shadow
            color: Colors.black.withOpacity(0.5),  // Soft black shadow
          ),
        ],
      ),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 18,  // Keeping the font size consistent
          fontWeight: FontWeight.bold,
          color: Colors.white,
          letterSpacing: 1.1,
        ),
      ),
    );
  }}