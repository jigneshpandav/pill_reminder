import 'dart:convert';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:hive_flutter/hive_flutter.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:medicine_reminder/provider/home_provider.dart';
import 'package:medicine_reminder/routes/routes.dart';
import 'package:medicine_reminder/screens/home/home_screen.dart';
import 'package:medicine_reminder/utils/theme.dart';
import 'package:medicine_reminder/widgets/flavor.dart';
import 'package:provider/provider.dart';

import 'provider/medicine_provider.dart';
import 'widgets/local_notifications.dart' as notify;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await initializeService();
  notify.initNotifications();
  final NotificationAppLaunchDetails? data =
      await notify.localNotificationsPlugin.getNotificationAppLaunchDetails();
  print("Payload:-${data!.payload}");

  await Hive.initFlutter();

  const secureStorage = FlutterSecureStorage();
  final secureKey = await secureStorage.read(key: 'key');
  secureStorage.write(
      key: "updateDataTime", value: DateTime.now().toString());
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
  Hive.registerAdapter(AddMedicineAdapter());
  await Hive.openBox(
    "medicine_reminder",
    encryptionCipher: HiveAesCipher(encryptionKey),
  );

  runApp(MyApp(
    payload: data.payload,
  ));
}

class MyApp extends StatelessWidget {
  final String? payload;

  const MyApp({Key? key, required this.payload}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        Provider<Flavor>.value(value: Flavor.dev),
        ChangeNotifierProvider(
          create: (ctx) => AddMedicineProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: themeData(),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(
          payload: payload,
        ),
        routes: routes,
      ),
    );
  }
}
