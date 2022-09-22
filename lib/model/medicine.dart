import 'package:hive/hive.dart';

part 'medicine.g.dart';

@HiveType(typeId: 0)
class AddMedicine {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? medId;
  @HiveField(2)
  final String? medicineName;
  @HiveField(3)
  final String? diseaseName;
  @HiveField(4)
  final String? medicineType;
  @HiveField(5)
  final String? doseQuantity;
  @HiveField(6)
  final String? takeItInDay;
  @HiveField(7)
  final String? firstDose;
  @HiveField(8)
  final String? doseTime;
  @HiveField(9)
  final List? specificWeekDay;
  @HiveField(10)
  final String? dose;
  @HiveField(11)
  final String? doseType;
  @HiveField(12)
  final String? firstDoseType;
  @HiveField(13)
  final String? secondDose;
  @HiveField(14)
  final String? secondDoseType;
  @HiveField(15)
  final String? secondDoseTime;
  @HiveField(16)
  final String? thirdDose;
  @HiveField(17)
  final String? thirdDoseType;
  @HiveField(18)
  final String? thirdDoseTime;
  @HiveField(19)
  final String? frequency;
  @HiveField(20)
  final String? startDate;
  @HiveField(21)
  final String? endDate;
  @HiveField(22)
  final bool? isCompleted;
  @HiveField(23)
  final String? description;
  @HiveField(24)
  final String? date;
  @HiveField(25)
  final String? whichDose;

  AddMedicine({
    this.id,
    this.medId,
    this.specificWeekDay,
    this.date,
    this.medicineName,
    this.diseaseName,
    this.medicineType,
    this.doseQuantity,
    this.takeItInDay,
    this.dose,
    this.doseType,
    this.firstDose,
    this.firstDoseType,
    this.secondDose,
    this.secondDoseType,
    this.frequency,
    this.startDate,
    this.endDate,
    this.thirdDose,
    this.thirdDoseType,
    this.isCompleted,
    this.doseTime,
    this.secondDoseTime,
    this.thirdDoseTime,
    this.description,
    this.whichDose,
  });
}
