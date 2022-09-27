library medicine_reminder.utils.constants;

import 'package:flutter/material.dart';

const FontWeight boldText = FontWeight.bold;
const FontWeight gilroyBlack = FontWeight.w900;
const FontWeight gilroyExtraBold = FontWeight.w800;
const FontWeight gilroyBold = FontWeight.w700;
const FontWeight gilroySemiBold = FontWeight.w600;
const FontWeight gilroyMedium = FontWeight.w500;
const FontWeight gilroyRegular = FontWeight.w400;
const FontWeight gilroyLight = FontWeight.w300;

const kPrimaryColor = Color(0xFF1C4A5A);
const kSecondaryColor = Color(0xFFFFB057);
const kScaffoldColor = Color(0xFFFAFAFA);
const kCardColor = Color(0xFFFFB057);
const kCardColor2 = Color(0xFFFFEEDB);
const kDateTextColor = Color(0xFF889EA6);
const kTextColor = Color(0xFF1C4A5A);
const kTextColor2 = Color(0xFFC4C4C4);
const kCheckColor = Color(0xFF01B414);
const kCheckBackGround = Color(0xFFECFAEE);
// const kCardColor2 = Color(0xFF23212E);

// const kBorderColor2 = Color(0xFF2B313F);
// const kIconColor = Color(0xFF7D8399);
// const kBottomNavIconColor = Color(0xFF919096);
// const kPrimaryTextColor = Color(0xFF05030E);
// const kPurpleColor = Color(0xFF764F9C);
// const kGoldYellowColor = Color(0xFFF7CB17);
// const kBlueColor = Color(0xFF189DD6);
// const kGreenColor = Color(0xFF9DC84D);

String getUpperCase(String value) {
  return value[0].toUpperCase() + value.substring(1);
}

String medicineAssetsPath = "assets/medicines/";

Map<String, String> medicines = {
  "antiseptic": "${medicineAssetsPath}antiseptic.png",
  "aspirin": "${medicineAssetsPath}aspirin.png",
};

int currentYear = DateTime.now().year;

int? daysInMonth(final int month, final int year) {
  if (month > 12) {
    return null;
  }
  List<int> monthLength = List.filled(12, 0);
  monthLength[0] = 31;
  monthLength[2] = 31;
  monthLength[4] = 31;
  monthLength[6] = 31;
  monthLength[7] = 31;
  monthLength[9] = 31;
  monthLength[11] = 31;
  monthLength[3] = 30;
  monthLength[8] = 30;
  monthLength[5] = 30;
  monthLength[10] = 30;

  if (leapYear(year) == true) {
    monthLength[1] = 29;
  } else {
    monthLength[1] = 28;
  }

  return monthLength[month - 1];
}

bool leapYear(int year) {
  bool leapYear = false;
  bool leap = ((year % 100 == 0) && (year % 400 != 0));
  if (leap == true) {
    leapYear = false;
  } else if (year % 4 == 0) {
    leapYear = true;
  }

  return leapYear;
}

List<String> years = [
  "$currentYear",
  "${currentYear - 1}",
  "${currentYear - 2}",
];

var months = [
  "January",
  "February",
  "March",
  "April",
  "May",
  "Jun",
  "July",
  "August",
  "September",
  "October",
  "November",
  "December",
];
