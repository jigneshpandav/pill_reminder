import 'package:flutter/material.dart';

class HomeProvider with ChangeNotifier {
  DateTime selectedValue = DateTime.now();
  DateTime selectedInitialValue = DateTime.now();
  int bottomIndex = 0;
  String? date;
  int index = 0;
  String? id;
  bool isEnable = false;

  Future showNotification1(String payload) async {
    print("INNNN");
    bottomIndex = 0;
    date = payload;
    print(date);
    DateTime temp = DateTime.parse(payload);
    print(temp);
    if (temp.hour < 12) {
      index = 0;
    } else if (temp.hour < 17 && temp.hour >= 12) {
      index = 1;
    } else if (temp.hour >= 17 && temp.hour < 24) {
      index = 2;
    }
    print("OUTTTT");
    notifyListeners();
  }
}
