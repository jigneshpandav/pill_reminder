import 'package:flutter/material.dart';

import 'text_utils.dart';


ThemeData themeData() {
  return ThemeData(
      scaffoldBackgroundColor: kScaffoldColor,
      primarySwatch: Palette.kPrimaryButtonColor,
      fontFamily: 'Gilroy',
      colorScheme: const ColorScheme.light(
        onPrimary: kDateTextColor, // selected text color
        onSurface: Colors.white, // default text color
        primary: kPrimaryColor, // circle color
      ),
      timePickerTheme: timePickerThemeData(),
      primaryColor: kPrimaryColor,
      dialogBackgroundColor: kCardColor);
}

TimePickerThemeData timePickerThemeData() {
  return const TimePickerThemeData(
    backgroundColor: kCardColor,
    dialTextColor: Colors.white,
    dayPeriodColor: kCardColor,
    helpTextStyle: TextStyle(color: kPrimaryColor, fontFamily: "Gilroy"),
    hourMinuteColor: kPrimaryColor,
    hourMinuteTextColor: Colors.white,
    dayPeriodBorderSide: BorderSide(),
    dialHandColor: kCardColor,
    dialBackgroundColor: kPrimaryColor,
  );
}

class Palette {
  static const MaterialColor kPrimaryButtonColor = MaterialColor(
    0xffD6FF00,
    <int, Color>{
      50: Color(0xffD6FF00), //10%
      100: Color(0xffc1e500), //20%
      200: Color(0xffaccb00), //30%
      300: Color(0xff97b100), //40%
      400: Color(0xff829700), //50%
      500: Color(0xff6d7d00), //60%
      600: Color(0xff586300), //70%
      700: Color(0xff2e2f00), //80%
      800: Color(0xff191500), //90%
      900: Color(0xff000000), //100%
    },
  );
}
