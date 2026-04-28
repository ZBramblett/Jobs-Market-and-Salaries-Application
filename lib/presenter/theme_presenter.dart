// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';

class ThemePresenter extends ChangeNotifier {
  String _override = "";
  late final Timer _timer;

  ThemePresenter() {
    // Notify listeners every minute so time-based themes update automatically.
    _timer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => notifyListeners(),
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final sunriseGradientColors = [
    Color.fromARGB(50, 244, 188, 103),
    Color.fromARGB(125, 247, 138, 174),
    Color.fromARGB(255, 255, 255, 255),
  ];
  final dayGradientColors = [
    Color.fromARGB(184, 255, 255, 255),
    Color.fromARGB(200, 237, 237, 237),
    Color.fromARGB(255, 255, 255, 255),
  ];
  final sunsetGradientColors = [
    Color.fromARGB(255, 255, 139, 15),
    Color.fromARGB(255, 236, 143, 42),
    Color.fromARGB(255, 255, 238, 221),
  ];
  final nightGradientColors = [
    Color.fromARGB(125, 80, 100, 160),
    Color.fromARGB(125, 50, 60, 120),
    Color.fromARGB(255, 125, 125, 150),
  ];

  final BORDER_RADIUS = 4;

  List<Color> getGradient() {
    String filter = "";
    if (_override == "") {
      filter = _getTime();
    } else {
      filter = _override;
    }
    switch (filter) {
      case "sunrise":
        return sunriseGradientColors;
      case "sunset":
        return sunsetGradientColors;
      case "night":
        return nightGradientColors;
      default:
        return dayGradientColors;
    }
  }

  ColorScheme getColorScheme() {
    String filter = "";
    if (_override == "") {
      filter = _getTime();
    } else {
      filter = _override;
    }
    switch (filter) {
      case "sunrise":
        return ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 248, 210, 154),
          onPrimary: Color.fromARGB(255, 50, 0, 50),
          secondary: Color.fromARGB(255, 247, 138, 174),
          onSecondary: Color.fromARGB(255, 50, 0, 50),
          error: Color.fromARGB(255, 214, 69, 69),
          onError: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 255, 240, 240),
          onSurface: Color.fromARGB(255, 50, 0, 50),
        );
      case "sunset":
        return ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 235, 192, 143),
          onPrimary: Color.fromARGB(255, 26, 19, 11),
          secondary: Color.fromARGB(255, 255, 139, 15),
          onSecondary: Color.fromARGB(255, 26, 19, 11),
          error: Color.fromARGB(255, 214, 69, 69),
          onError: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 255, 232, 205),
          onSurface: Color.fromARGB(255, 26, 19, 11),
        );
      case "night":
        return ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(255, 53, 70, 110),
          onPrimary: Color.fromARGB(255, 240, 241, 243),
          secondary: Color.fromARGB(255, 150, 179, 232),
          onSecondary: Color.fromARGB(255, 8, 16, 40),
          error: Color.fromARGB(255, 207, 102, 121),
          onError: Colors.black,
          surface: Color.fromARGB(255, 8, 16, 40),
          onSurface: Color.fromARGB(255, 240, 241, 243),
        );
      default: //day
        return ColorScheme(
          brightness: Brightness.light,
          primary: Color.fromARGB(255, 214, 222, 234),
          onPrimary: Color.fromARGB(255, 18, 19, 22),
          secondary: Color.fromARGB(255, 158, 177, 206),
          onSecondary: Color.fromARGB(255, 18, 19, 22),
          error: Color.fromARGB(255, 214, 69, 69),
          onError: Color.fromARGB(255, 255, 255, 255),
          surface: Color.fromARGB(255, 249, 249, 251),
          onSurface: Color.fromARGB(255, 18, 19, 22),
        );
    }
  }

  String _getTime() {
    // final now = DateTime.now();
    // final afterSunrise = now.hour > 7 || (now.hour == 7 && now.minute >= 45);
    // final afterSunset = now.hour > 18 || (now.hour == 18 && now.minute >= 45);
    // if (afterSunrise && afterSunset) {
    //   return "night";
    // }

    // if (afterSunrise) {
    //   return "sunrise";
    // }
    // if (afterSunset) {
    //   return "sunset";
    // }
    // return "day";
    final now = DateTime.now();
    final sunriseStart = DateTime(now.year, now.month, now.day, 6, 0);
    final sunriseEnd = DateTime(now.year, now.month, now.day, 9, 0);
    final sunsetStart = DateTime(now.year, now.month, now.day, 17, 30);
    final sunsetEnd = DateTime(now.year, now.month, now.day, 20, 30);

    if (now.isAfter(sunriseStart) && now.isBefore(sunriseEnd)) {
      return "sunrise";
    } else if (now.isAfter(sunsetStart) && now.isBefore(sunsetEnd)) {
      return "sunset";
    } else if (now.isAfter(sunriseEnd) && now.isBefore(sunsetStart)) {
      return "day";
    } else {
      return "night";
    }
  }

  void setOverride(String input) {
    _override = input;
    notifyListeners();
  }

  void clearOverride() {
    _override = "";
    notifyListeners();
  }

  String getOverride() {
    return _override;
  }
}

final themePresenter = ThemePresenter();
