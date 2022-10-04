import 'package:flutter/material.dart';
import 'package:medicine_reminder/widgets/top_bar.dart';

class DoctorsScreen extends StatefulWidget {
  static String routeName = '/doctors';

  const DoctorsScreen({Key? key}) : super(key: key);

  @override
  State<DoctorsScreen> createState() => _DoctorsScreenState();
}

class _DoctorsScreenState extends State<DoctorsScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        scaffoldKey: scaffoldKey,
        title: "Doctors",
      ),
      body: const Center(
        child: Text("Doctors screen"),
      ),
    );
  }
}
