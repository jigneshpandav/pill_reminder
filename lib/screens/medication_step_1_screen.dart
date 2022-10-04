import 'package:flutter/material.dart';
import 'package:medicine_reminder/widgets/top_bar.dart';

class MedicationStep1Screen extends StatefulWidget {
  static String routeName = '/medication-step-1';

  const MedicationStep1Screen({Key? key}) : super(key: key);

  @override
  State<MedicationStep1Screen> createState() => _MedicationStep1ScreenState();
}

class _MedicationStep1ScreenState extends State<MedicationStep1Screen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        scaffoldKey: scaffoldKey,
        title: "Add medication",
      ),
      body: const Center(
        child: Text("Hello"),
      ),
    );
  }
}
