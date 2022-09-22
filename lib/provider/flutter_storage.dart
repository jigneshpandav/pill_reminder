import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterStorage {
  final storage = FlutterSecureStorage();
  List<SecItem> items = [];

  Future<void> readAll() async {
    final all = await storage.readAll();
    items = all.entries
        .map((entry) => SecItem(entry.key, entry.value))
        .toList(growable: false);
  }

  Future<void> deleteAll() async {
    await storage.deleteAll(
      aOptions: _getAndroidOptions(),
    );
    readAll();
  }

  Future<void> addNewItem({required String key, required String value}) async {
    print({key, value});
    await storage.write(
      key: key,
      value: value,
    );
    readAll();
  }

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
        // sharedPreferencesName: 'Test2',
        // preferencesKeyPrefix: 'Test'
      );
}

class SecItem {
  SecItem(this.key, this.value);

  final String key;
  final String value;
}
