// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medication.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MedicationAdapter extends TypeAdapter<Medication> {
  @override
  final int typeId = 0;

  @override
  Medication read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Medication()
      .._id = fields[0] as String?
      .._name = fields[1] as String?
      .._disease = fields[2] as String?
      .._imagePath = fields[3] as String?
      .._user = fields[4] as User?
      .._frequency = fields[5] as String?
      .._frequencyOccurrence = fields[6] as dynamic
      .._startDate = fields[7] as String?
      .._duration = fields[8] as dynamic
      .._reminders = (fields[9] as List?)?.cast<Reminder>()
      .._autoSnooze = fields[10] as bool?
      .._snoozeDuration = fields[11] as int?
      .._snoozeFrequency = fields[12] as int?
      .._doctor = fields[13] as Doctor?
      .._note = fields[14] as String?;
  }

  @override
  void write(BinaryWriter writer, Medication obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._disease)
      ..writeByte(3)
      ..write(obj._imagePath)
      ..writeByte(4)
      ..write(obj._user)
      ..writeByte(5)
      ..write(obj._frequency)
      ..writeByte(6)
      ..write(obj._frequencyOccurrence)
      ..writeByte(7)
      ..write(obj._startDate)
      ..writeByte(8)
      ..write(obj._duration)
      ..writeByte(9)
      ..write(obj._reminders)
      ..writeByte(10)
      ..write(obj._autoSnooze)
      ..writeByte(11)
      ..write(obj._snoozeDuration)
      ..writeByte(12)
      ..write(obj._snoozeFrequency)
      ..writeByte(13)
      ..write(obj._doctor)
      ..writeByte(14)
      ..write(obj._note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MedicationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
