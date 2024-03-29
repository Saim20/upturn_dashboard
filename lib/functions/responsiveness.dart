import 'package:flutter/material.dart';

bool isWideScreen(BuildContext context) {
  return MediaQuery.of(context).size.width > 1200;
}

double getPercentageOfScreenWidth(BuildContext context, double percentage) {
  return MediaQuery.of(context).size.width * percentage;
}