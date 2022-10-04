import 'package:flutter/material.dart';
import 'package:medicine_reminder/widgets/top_bar.dart';

class UsersScreen extends StatefulWidget {
  static String routeName = '/users';

  const UsersScreen({Key? key}) : super(key: key);

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        scaffoldKey: scaffoldKey,
        title: "Users",
      ),
      body: const Center(
        child: Text("Users Screen"),
      ),
    );
  }
}
