import 'package:flutter/material.dart';

const MaterialColor greenprimary = MaterialColor(_greenprimaryPrimaryValue, <int, Color>{
  50: Color(0xFFE1EAEC),
  100: Color(0xFFB3CCD1),
  200: Color(0xFF81AAB2),
  300: Color(0xFF4E8793),
  400: Color(0xFF286E7B),
  500: Color(_greenprimaryPrimaryValue),
  600: Color(0xFF024D5C),
  700: Color(0xFF014352),
  800: Color(0xFF013A48),
  900: Color(0xFF012936),
});
const int _greenprimaryPrimaryValue = 0xFF025464;

const MaterialColor greenprimaryAccent = MaterialColor(_greenprimaryAccentValue, <int, Color>{
  100: Color(0xFF6ED2FF),
  200: Color(_greenprimaryAccentValue),
  400: Color(0xFF08B3FF),
  700: Color(0xFF00A4ED),
});
const int _greenprimaryAccentValue = 0xFF3BC3FF;
