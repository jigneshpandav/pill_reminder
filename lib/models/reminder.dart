import 'package:hive_flutter/hive_flutter.dart';

part 'reminder.g.dart';

@HiveType(typeId: 1)
class Reminder {
  @HiveField(0)
  String? _time;
  @HiveField(1)
  double? _quantity;
  @HiveField(2)
  bool? _startTime;

  String? get time => _time;

  set time(String? value) {
    _time = value;
  }

  double? get quantity => _quantity;

  set quantity(double? value) {
    _quantity = value;
  }

  bool? get startTime => _startTime;

  set startTime(bool? value) {
    _startTime = value;
  }

  Reminder({
    String? time,
    double? quantity,
    bool startTime = true,
  });

  Reminder.fromJson(Map<String, dynamic> json) {
    _startTime = json['startTime'];
    _quantity = json['quantity'];
    _time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['startTime'] = _startTime;
    data['quantity'] = _quantity;
    data['time'] = _time;
    return data;
  }
}
