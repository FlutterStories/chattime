import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyButton extends StatelessWidget {
  final String name;
  final onPressed;

  MyButton({required this.name, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 1,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          child: Center(
            child: Text(
              '$name',
              style: GoogleFonts.balooDa(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
          margin: EdgeInsets.only(bottom: 10),
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white38,
          ),
        ),
      ),
    );
  }
}

class LoginRegisButton extends StatelessWidget {
  final onTap;
  final String buttonName;
  final Color buttonColor;
  final double buttonTextSize;
  LoginRegisButton(
      {required this.onTap,
      required this.buttonName,
      required this.buttonColor,
      required this.buttonTextSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10, left: 10, right: 10, top: 9),
        height: 50,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.black,
        ),
        child: Center(
          child: Text(
            '$buttonName',
            style: GoogleFonts.balooDa(
              fontSize: buttonTextSize,
              color: buttonColor,
            ),
          ),
        ),
      ),
    );
  }
}
