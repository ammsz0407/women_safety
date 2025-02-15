import 'package:flutter/material.dart';
import 'package:women_safety/utils/constants.dart';

class  PrimaryButton extends StatefulWidget {
  final String title;
  final Function onPressed;
  bool loading;
  PrimaryButton(
      {required this.title, required this.onPressed, this.loading= false}
      );

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height:60,
      width: double.maxFinite,
      child: ElevatedButton(
          onPressed: () {
            widget.onPressed();
          },
          child: Text(
            widget.title,
            style: TextStyle(fontSize: 18),
          ),
          style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)))

      ),
    );
  }
}