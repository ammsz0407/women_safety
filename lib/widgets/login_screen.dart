import 'package:flutter/material.dart';
import 'package:women_safety/utils/constants.dart';
import 'package:women_safety/components/PrimaryButton.dart';
import 'package:women_safety/components/custom_textfield.dart';
import 'package:women_safety/components/SecondaryButton.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}):super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "USER LOGIN",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
              Image.asset(
                  'assets.logo.png',
                  height:100,
                  width:100
              ),
              CustomTextField(
                hintText: 'enter name',
                prefix: Icon(Icons.person),
              ),
              CustomTextField(
                hintText: 'enter name',
                prefix: Icon(Icons.person),
              ),
              PrimaryButton(title: 'REGISTER', onPressed: () {}),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 18),
                  ),
                  SecondaryButton(title: 'Click here', onPressed: () {}),
                ],
              ),
              SecondaryButton(title: 'REGISTER new user', onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}