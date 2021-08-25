import 'package:flutter/material.dart';

final kTextFieldDecoration = InputDecoration(
  hintText: "hintText",
  contentPadding: EdgeInsets.symmetric(vertical: 1, horizontal: 14),
  fillColor: Colors.black54,
  filled: true,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(30),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.circular(30),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white38, width: 3.0),
    borderRadius: BorderRadius.circular(30),
  ),
);

const kTextFieldStyle = TextStyle(
  color: Colors.white,
  fontSize: 15,
);
