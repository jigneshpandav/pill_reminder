import 'package:flutter/material.dart';
import 'package:medicine_reminder/screens/home/components/medicine_details_screen.dart';

import '../screens/add-medicine/add_medicine2_screen.dart';
import '../screens/add-medicine/add_medicine_screen.dart';
import '../screens/home/home_screen.dart';

final Map<String, WidgetBuilder> routes = {
  HomeScreen.routeName: (context) => const HomeScreen(),
  AddMedicineScreen.routeName: (context) => const AddMedicineScreen(),
  AddMedicine2.routeName: (context) => const AddMedicine2(),
  MedicineDetailScreen.routeName: (context) => const MedicineDetailScreen(),
};
