import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine_reminder/screens/medication_screen.dart';
import 'package:provider/provider.dart';

import 'models/doctor.dart';
import 'models/medication.dart';
import 'models/reminder.dart';
import 'models/user.dart';
import 'screens/home_screen.dart';
import 'utils/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage();
  final secureKey = await secureStorage.read(key: 'key');

  if (secureKey == null) {
    final key = Hive.generateSecureKey();
    await secureStorage.write(
      key: 'key',
      value: base64UrlEncode(key),
    );
  }
  final key = await secureStorage.read(key: 'key');
  final encryptionKey = base64Url.decode(key!);
  if (kDebugMode) {
    print('Encryption key: $encryptionKey');
  }
  Hive.registerAdapter(MedicationAdapter());
  Hive.registerAdapter(ReminderAdapter());
  Hive.registerAdapter(DoctorAdapter());
  Hive.registerAdapter(UserAdapter());
  await Hive.openBox(
    "medicine_reminder",
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Medicine Reminder',
      theme: themeData(),
      debugShowCheckedModeBanner: false,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        MedicationScreen.routeName: (context) => MedicationScreen()
      },
    );
  }
}
