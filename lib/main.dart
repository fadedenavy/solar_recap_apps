import 'package:flutter/material.dart';
import 'package:solar_recap_app/views/Homepage.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(primaryColor: Colors.white),
    home: Homepage(),
  ));
}

