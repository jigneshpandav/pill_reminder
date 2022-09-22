// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'medicine.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AddMedicineAdapter extends TypeAdapter<AddMedicine> {
  @override
  final int typeId = 0;

  @override
  AddMedicine read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AddMedicine(
      id: fields[0] as String?,
      medId: fields[1] as String?,
      specificWeekDay: (fields[9] as List?)?.cast<dynamic>(),
      date: fields[24] as String?,
      medicineName: fields[2] as String?,
      diseaseName: fields[3] as String?,
      medicineType: fields[4] as String?,
      doseQuantity: fields[5] as String?,
      takeItInDay: fields[6] as String?,
      dose: fields[10] as String?,
      doseType: fields[11] as String?,
      firstDose: fields[7] as String?,
      firstDoseType: fields[12] as String?,
      secondDose: fields[13] as String?,
      secondDoseType: fields[14] as String?,
      frequency: fields[19] as String?,
      startDate: fields[20] as String?,
      endDate: fields[21] as String?,
      thirdDose: fields[16] as String?,
      thirdDoseType: fields[17] as String?,
      isCompleted: fields[22] as bool?,
      doseTime: fields[8] as String?,
      secondDoseTime: fields[15] as String?,
      thirdDoseTime: fields[18] as String?,
      description: fields[23] as String?,
      whichDose: fields[25] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, AddMedicine obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.medId)
      ..writeByte(2)
      ..write(obj.medicineName)
      ..writeByte(3)
      ..write(obj.diseaseName)
      ..writeByte(4)
      ..write(obj.medicineType)
      ..writeByte(5)
      ..write(obj.doseQuantity)
      ..writeByte(6)
      ..write(obj.takeItInDay)
      ..writeByte(7)
      ..write(obj.firstDose)
      ..writeByte(8)
      ..write(obj.doseTime)
      ..writeByte(9)
      ..write(obj.specificWeekDay)
      ..writeByte(10)
      ..write(obj.dose)
      ..writeByte(11)
      ..write(obj.doseType)
      ..writeByte(12)
      ..write(obj.firstDoseType)
      ..writeByte(13)
      ..write(obj.secondDose)
      ..writeByte(14)
      ..write(obj.secondDoseType)
      ..writeByte(15)
      ..write(obj.secondDoseTime)
      ..writeByte(16)
      ..write(obj.thirdDose)
      ..writeByte(17)
      ..write(obj.thirdDoseType)
      ..writeByte(18)
      ..write(obj.thirdDoseTime)
      ..writeByte(19)
      ..write(obj.frequency)
      ..writeByte(20)
      ..write(obj.startDate)
      ..writeByte(21)
      ..write(obj.endDate)
      ..writeByte(22)
      ..write(obj.isCompleted)
      ..writeByte(23)
      ..write(obj.description)
      ..writeByte(24)
      ..write(obj.date)
      ..writeByte(25)
      ..write(obj.whichDose);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddMedicineAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
