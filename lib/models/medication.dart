import 'package:hive/hive.dart';
import 'package:medicine_reminder/models/user.dart';

import 'doctor.dart';
import 'reminder.dart';

part 'medication.g.dart';

enum Frequency {
  daily,
  everyXDays,
  daysOfTheWeek,
  cycle,
  asNeeded,
}

extension FrequencyExtension on Frequency {
  String get label {
    switch (this) {
      case Frequency.daily:
        return 'Daily';
      case Frequency.everyXDays:
        return 'Every X Days';
      case Frequency.daysOfTheWeek:
        return 'Days of the Week';
      case Frequency.cycle:
        return 'Cycle';
      default:
        return 'As Needed';
    }
  }
}

enum Duration {
  totalDays,
  endDate,
  forever,
}

extension DurationExtension on Duration {
  String get label {
    switch (this) {
      case Duration.totalDays:
        return 'Total Days';
      case Duration.endDate:
        return 'End Date';
      default:
        return 'Forever';
    }
  }
}

@HiveType(typeId: 0)
class Medication {
  /* first screen data*/
  @HiveField(0)
  String? _id;
  @HiveField(1)
  String? _name;
  @HiveField(2)
  String? _disease;
  @HiveField(3)
  String? _imagePath;
  @HiveField(4)
  User? _user;

  /* end of first screen data*/

  /* second screen data*/
  @HiveField(5)
  String? _frequency;

  /*
  It can be any duration of frequency
  - will be null on daily
  - Int day 1 when every n day selected
  - List<String> [Monday, Tuesday]when days of the week selected
  - Cycle - Map<String,int> {"on":2,"off":2"}
  - will be null when AsNeeded selected
   */
  @HiveField(6)
  dynamic _frequencyOccurrence;
  @HiveField(7)
  String? _startDate;

  /*
  End date is dynamic bcz it can be any of below
  End Date - DateTime object for specific end day
  Total Days - String value total x days where days will be integer
  Forever - String forever for daily remainder without end date
   */
  @HiveField(8)
  dynamic _duration; //end date can be Days/Date/Forever

  @HiveField(9)
  List<Reminder>? _reminders;

  /* end of second screen data */

  /* third screen data */
  @HiveField(10)
  bool? _autoSnooze;
  @HiveField(11)
  int? _snoozeDuration;
  @HiveField(12)
  int? _snoozeFrequency;
  @HiveField(13)
  Doctor? _doctor;
  @HiveField(14)
  String? _note;

  String? get id => _id;

  set id(String? value) {
    _id = value;
  }

  String? get name => _name;

  set name(String? value) {
    _name = value;
  }

  String? get disease => _disease;

  set disease(String? value) {
    _disease = value;
  }

  String? get imagePath => _imagePath;

  set imagePath(String? value) {
    _imagePath = value;
  }

  User? get user => _user;

  set user(User? value) {
    _user = value;
  }

  String? get frequency => _frequency;

  set frequency(String? value) {
    _frequency = value;
  }

  dynamic get frequencyOccurrence => _frequencyOccurrence;

  set frequencyOccurrence(dynamic value) {
    _frequencyOccurrence = value;
  }

  String? get startDate => _startDate;

  set startDate(String? value) {
    _startDate = value;
  }

  dynamic get duration => _duration;

  set duration(dynamic value) {
    _duration = value;
  }

  List<Reminder>? get reminders => _reminders;

  set reminders(List<Reminder>? value) {
    _reminders = value;
  }

  bool? get autoSnooze => _autoSnooze;

  set autoSnooze(bool? value) {
    _autoSnooze = value;
  }

  int? get snoozeDuration => _snoozeDuration;

  set snoozeDuration(int? value) {
    _snoozeDuration = value;
  }

  int? get snoozeFrequency => _snoozeFrequency;

  set snoozeFrequency(int? value) {
    _snoozeFrequency = value;
  }

  Doctor? get doctor => _doctor;

  set doctor(Doctor? value) {
    _doctor = value;
  }

  String? get note => _note;

  set note(String? value) {
    _note = value;
  }

/* end of third screen data */

  Medication({
    String? id,
    String? name,
    String? disease,
    String? imagePath,
    User? user,
    String? frequency,
    String? startDate,
    dynamic duration,
    List<Reminder>? reminders,
    bool? autoSnooze,
    int? snoozeDuration,
    int? snoozeFrequency,
    Doctor? doctor,
    String? note,
  });

  Medication.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _disease = json['disease'];
    _imagePath = json['imagePath'];
    _user = json['user'] != null ? User.fromJson(json['user']) : null;
    _frequency = json['frequency'];
    _startDate = json['startDate'];
    _duration = json['duration'];

    if (json['reminders'] != null) {
      _reminders = <Reminder>[];
      json['reminders'].forEach((v) {
        _reminders!.add(Reminder.fromJson(v));
      });
    }

    _autoSnooze = json['autoSnooze'];
    _snoozeDuration = json['snoozeDuration'];
    _snoozeFrequency = json['snoozeFrequency'];
    _doctor = json['doctor'] != null ? Doctor.fromJson(json['doctor']) : null;
    _note = json['note'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = _id;
    data['name'] = _name;
    data['disease'] = _disease;
    data['imagePath'] = _imagePath;
    if (_user != null) {
      data['user'] = _user!.toJson();
    }
    data['frequency'] = _frequency;
    data['startDate'] = _startDate;
    data['duration'] = _duration;

    if (_reminders != null) {
      data['reminders'] = _reminders!.map((v) => v.toJson()).toList();
    }

    data['autoSnooze'] = _autoSnooze;
    data['snoozeDuration'] = _snoozeDuration;
    data['snoozeFrequency'] = _snoozeFrequency;
    if (_doctor != null) {
      data['doctor'] = _doctor!.toJson();
    }
    data['note'] = _note;
    return data;
  }
}
