// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doctor.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DoctorAdapter extends TypeAdapter<Doctor> {
  @override
  final int typeId = 3;

  @override
  Doctor read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Doctor()
      .._id = fields[0] as String?
      .._name = fields[1] as String?
      .._speciality = fields[2] as String?
      .._photo = fields[3] as String?
      .._phoneNo = fields[4] as String?
      .._officeNo = fields[5] as String?
      .._email = fields[6] as String?
      .._note = fields[7] as String?;
  }

  @override
  void write(BinaryWriter writer, Doctor obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._speciality)
      ..writeByte(3)
      ..write(obj._photo)
      ..writeByte(4)
      ..write(obj._phoneNo)
      ..writeByte(5)
      ..write(obj._officeNo)
      ..writeByte(6)
      ..write(obj._email)
      ..writeByte(7)
      ..write(obj._note);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DoctorAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
