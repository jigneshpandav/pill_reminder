import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_manager/firebase_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:medicine_reminder/provider/flutter_storage.dart';

import '../model/medicine.dart';

class AddMedicineProvider with ChangeNotifier {
  List<AddMedicine> data = [];
  List<AddMedicine> allMedicineDetails = [];
  List<AddMedicine> medicineDetails = [];
  List<AddMedicine> medicineSchedule = [];
  List<AddMedicine> finalData = [];
  List<AddMedicine> historyData = [];
  List week = [];
  List weekList = [];
  List doseTime = [];
  List<String> doseType = [];
  String? medicineId;
  bool isLoading = true;
  bool isCheckLoading = true;
  List medicineType = [];
  List<String> medName = [];
  String medicineName = "";
  String? barcode;
  String? userId;
  FirebaseManager firebaseManager = FirebaseManager(apiKey: "");
  FlutterStorage flutterStorage = FlutterStorage();

  Future getUserId() async {
    var deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      userId = iosDeviceInfo.identifierForVendor; // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      userId = androidDeviceInfo.id; // unique ID on Android
    }
    notifyListeners();
  }

  Future submitMedicineForm(AddMedicine addMedicine) async {
    try {
      var medicine = {
        'user_id': userId,
        'medicine_name': addMedicine.medicineName,
        "disease_name": addMedicine.diseaseName,
        "medicine_type": addMedicine.medicineType,
        "dose_quantity": addMedicine.doseQuantity,
        "description": addMedicine.description,
        "end_date": addMedicine.endDate,
      };
      var id = await firebaseManager.create(
        collection: "medicine",
        data: medicine,
      );
      if (id.id != null) {
        var addNew = AddMedicine(
          id: id.id,
          medicineName: addMedicine.medicineName,
          diseaseName: addMedicine.diseaseName,
          medicineType: addMedicine.medicineType,
          doseQuantity: addMedicine.doseQuantity,
          description: addMedicine.description,
          endDate: addMedicine.endDate,
        );
        data.add(addNew);
      }
      await Hive.box("medicine_reminder").put("medicine", data);
      medicineId = id.id;
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future submitMedicineDetailsForm(AddMedicine addMedicine) async {
    try {
      if (addMedicine.firstDose == "morning" ||
          addMedicine.firstDose == "afternoon" ||
          addMedicine.firstDose == "night") {
        var medicine = {
          'medicine_id': "$medicineId",
          'user_id': userId,
          "take_it_in_day": addMedicine.takeItInDay,
          "dose": addMedicine.firstDose,
          "dose_type": addMedicine.firstDoseType,
          "frequency": addMedicine.frequency,
          "start_date": addMedicine.startDate,
          "end_date": addMedicine.endDate,
          "week_days": week.isNotEmpty ? week : [],
          "first_dose": addMedicine.doseTime,
          "which_dose": "firstDose",
        };
        var id = await firebaseManager.create(
          collection: "medicine_details",
          data: medicine,
        );
        if (id.id != null) {
          var addNew = AddMedicine(
            id: medicineId,
            medId: id.id,
            takeItInDay: addMedicine.takeItInDay,
            dose: addMedicine.firstDose,
            doseTime: addMedicine.doseTime,
            doseType: addMedicine.firstDoseType,
            frequency: addMedicine.frequency,
            startDate: addMedicine.startDate,
            endDate: addMedicine.endDate,
            specificWeekDay: week.isNotEmpty ? week : [],
            isCompleted: false,
            whichDose: "firstDose",
          );
          allMedicineDetails.add(addNew);
          medicineDetails.add(addNew);
        }
      }
      if (addMedicine.secondDose != null &&
          addMedicine.secondDose == "morning") {
        var medicine = {
          'medicine_id': "$medicineId",
          'user_id': userId,
          "take_it_in_day": addMedicine.takeItInDay,
          "dose": addMedicine.secondDose,
          "dose_type": addMedicine.secondDoseType,
          "frequency": addMedicine.frequency,
          "start_date": addMedicine.startDate,
          "end_date": addMedicine.endDate,
          "week_days": week.isNotEmpty ? week : [],
          "second_dose": addMedicine.secondDoseTime,
          "which_dose": "secondDose",
        };
        var id = await firebaseManager.create(
            collection: "medicine_details", data: medicine);
        if (id.id != null) {
          var addNew = AddMedicine(
            id: medicineId,
            medId: id.id,
            takeItInDay: addMedicine.takeItInDay,
            dose: addMedicine.secondDose,
            doseTime: addMedicine.secondDoseTime,
            doseType: addMedicine.secondDoseType,
            frequency: addMedicine.frequency,
            startDate: addMedicine.startDate,
            endDate: addMedicine.endDate,
            specificWeekDay: week.isNotEmpty ? week : [],
            whichDose: "secondDose",
            isCompleted: false,
          );
          medicineDetails.add(addNew);
          allMedicineDetails.add(addNew);
        }
      }
      if (addMedicine.secondDose == "afternoon" ||
          addMedicine.secondDose == "night") {
        var medicine = {
          'medicine_id': "$medicineId",
          'user_id': userId,
          "take_it_in_day": addMedicine.takeItInDay,
          "dose": addMedicine.secondDose,
          "dose_type": addMedicine.secondDoseType,
          "frequency": addMedicine.frequency,
          "start_date": addMedicine.startDate,
          "end_date": addMedicine.endDate,
          "week_days": week.isNotEmpty ? week : [],
          "second_dose": addMedicine.secondDoseTime,
          "which_dose": "secondDose",
        };
        var id = await firebaseManager.create(
            collection: "medicine_details", data: medicine);
        if (id.id != null) {
          var addNew = AddMedicine(
            id: medicineId,
            medId: id.id,
            takeItInDay: addMedicine.takeItInDay,
            dose: addMedicine.secondDose,
            doseTime: addMedicine.secondDoseTime,
            doseType: addMedicine.secondDoseType,
            frequency: addMedicine.frequency,
            startDate: addMedicine.startDate,
            endDate: addMedicine.endDate,
            specificWeekDay: week.isNotEmpty ? week : [],
            whichDose: "secondDose",
            isCompleted: false,
          );
          medicineDetails.add(addNew);
          allMedicineDetails.add(addNew);
        }
      }
      if (addMedicine.thirdDose == "night" ||
          addMedicine.thirdDose == "afternoon" ||
          addMedicine.thirdDose == "morning") {
        var medicine = {
          'medicine_id': "$medicineId",
          'user_id': userId,
          "take_it_in_day": addMedicine.takeItInDay,
          "dose": addMedicine.thirdDose,
          "dose_type": addMedicine.thirdDoseType,
          "frequency": addMedicine.frequency,
          "start_date": addMedicine.startDate,
          "end_date": addMedicine.endDate,
          "week_days": week.isNotEmpty ? week : [],
          "third_dose": addMedicine.thirdDoseTime,
          "which_dose": "thirdDose",
        };
        var id = await firebaseManager.create(
            collection: "medicine_details", data: medicine);
        if (id.id != null) {
          var addNew = AddMedicine(
            id: medicineId,
            medId: id.id,
            takeItInDay: addMedicine.takeItInDay,
            dose: addMedicine.thirdDose,
            doseTime: addMedicine.thirdDoseTime,
            doseType: addMedicine.thirdDoseType,
            frequency: addMedicine.frequency,
            startDate: addMedicine.startDate,
            endDate: addMedicine.endDate,
            specificWeekDay: week.isNotEmpty ? week : [],
            whichDose: "thirdDose",
            isCompleted: false,
          );
          medicineDetails.add(addNew);
          allMedicineDetails.add(addNew);
        }
      }
      await Hive.box("medicine_reminder")
          .put("medicine_details", medicineDetails);
      await Hive.box("medicine_reminder")
          .put("all_medicine_details", allMedicineDetails);
      getHistory(DateTime(
          DateTime.now().year, DateTime.now().month, DateTime.now().day));
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future getMedicineTypeData() async {
    try {
      var response = await firebaseManager.get(collection: "medicine_type");
      response.docs.forEach((element) {
        medicineType.clear();
        medName.clear();
        element['data'].forEach((value) {
          medicineType.add(value);
          medName.add(value['name']);
        });
      });
      await Hive.box("medicine_reminder").put("medicine_type", medicineType);
      await Hive.box("medicine_reminder").put("medicine_type_name", medName);
      medicineName = medicineType[0]['name'];
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future getData({DateTime? date}) async {
    try {
      data.clear();
      var medicineResponse = await firebaseManager.get(collection: "medicine");
      medicineResponse.docs.forEach((element) {
        DateTime endDate = DateTime.parse(element['end_date']);
        var end = DateTime.utc(endDate.year, endDate.month, endDate.day);
        if (element['user_id'] == userId && end.compareTo(date!) > 0) {
          data.add(
            AddMedicine(
              id: element.id,
              medicineName: element['medicine_name'],
              diseaseName: element['disease_name'],
              medicineType: element['medicine_type'],
              doseQuantity: element['dose_quantity'],
              description: element['description'],
            ),
          );
        }
      });
      await Hive.box("medicine_reminder").put("medicine", data);
      var medicineDetailsResponse =
          await firebaseManager.get(collection: "medicine_details");
      allMedicineDetails.clear();
      medicineDetailsResponse.docs.forEach((element) {
        if (element['user_id'] == userId) {
          var data = element.data() as Map;
          data.forEach((key, value) {
            if (key == "first_dose") {
              allMedicineDetails.add(
                AddMedicine(
                  id: element['medicine_id'],
                  medId: element.id,
                  takeItInDay: element['take_it_in_day'],
                  dose: element["dose"],
                  doseTime: element["first_dose"],
                  doseType: element["dose_type"],
                  frequency: element["frequency"],
                  startDate: element["start_date"],
                  endDate: element["end_date"],
                  specificWeekDay: element['week_days'],
                  isCompleted: false,
                  whichDose: element['which_dose'],
                ),
              );
            } else if (key == "second_dose") {
              allMedicineDetails.add(
                AddMedicine(
                  id: element['medicine_id'],
                  medId: element.id,
                  takeItInDay: element['take_it_in_day'],
                  dose: element["dose"],
                  doseTime: element["second_dose"],
                  doseType: element["dose_type"],
                  frequency: element["frequency"],
                  startDate: element["start_date"],
                  endDate: element["end_date"],
                  specificWeekDay: element['week_days'],
                  whichDose: element['which_dose'],
                  isCompleted: false,
                ),
              );
            } else if (key == "third_dose") {
              allMedicineDetails.add(
                AddMedicine(
                  id: element['medicine_id'],
                  medId: element.id,
                  takeItInDay: element['take_it_in_day'],
                  dose: element["dose"],
                  doseTime: element["third_dose"],
                  doseType: element["dose_type"],
                  frequency: element["frequency"],
                  startDate: element["start_date"],
                  endDate: element["end_date"],
                  specificWeekDay: element['week_days'],
                  whichDose: element['which_dose'],
                  isCompleted: false,
                ),
              );
            }
          });
        }
      });
      await Hive.box("medicine_reminder")
          .put("all_medicine_details", allMedicineDetails)
          .then((value) {
        sortData(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day));
      });
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future taken(AddMedicine addMedicine, DateTime date, String time) async {
    try {
      var schedule = {
        "date": date.toString(),
        "user_id": userId,
        "med_time": time.toString(),
        "med_detail_id": addMedicine.medId,
        "medicine_id": addMedicine.id,
        "dose": addMedicine.dose,
        "is_completed": true,
      };
      await firebaseManager.create(
          collection: "medicine_schedule", data: schedule);
      getTakenData(date);
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future getHistory(DateTime date) async {
    try {
      historyData.clear();
      doseType.clear();
      for (var value in data) {
        for (var medDetails in medicineDetails) {
          if (value.id == medDetails.id) {
            for (var element in medicineSchedule) {
              if (medDetails.id == element.id &&
                  medDetails.dose == element.dose &&
                  date.isAtSameMomentAs(
                      DateTime.parse(element.date.toString()))) {
                if (!doseType.contains(element.dose)) {
                  doseType.add(element.dose.toString());
                }
                historyData.add(AddMedicine(
                  medicineName: value.medicineName,
                  medicineType: value.medicineType,
                  diseaseName: value.diseaseName,
                  doseQuantity: value.doseQuantity,
                  description: value.description,
                  dose: medDetails.dose,
                  doseType: medDetails.doseType,
                  doseTime: medDetails.doseTime,
                  isCompleted: element.isCompleted,
                ));
              }
            }
          }
        }
      }
      doseTime.clear();
      for (var element in medicineDetails) {
        if (!doseTime.contains(element.doseTime)) {
          doseTime.add(element.doseTime.toString());
        }
      }
      if (doseType.length == 3) {
        doseType[0] = "morning";
        doseType[1] = "afternoon";
        doseType[2] = "night";
      }
      final d = jsonEncode(doseTime);
      flutterStorage.addNewItem(key: "time", value: d);
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future getTakenData(DateTime date) async {
    try {
      var response = await firebaseManager.get(collection: "medicine_schedule");
      medicineSchedule.clear();
      response.docs.forEach((element) {
        if (element['user_id'] == userId) {
          medicineSchedule.add(AddMedicine(
            id: element['medicine_id'],
            date: element['date'],
            medId: element['med_detail_id'],
            doseTime: element['med_time'],
            dose: element['dose'],
            isCompleted: element['is_completed'],
          ));
        }
      });
      await Hive.box("medicine_reminder")
          .put("medicine_schedule", medicineSchedule);
      getHistory(date);
    } catch (err) {
      rethrow;
    }
    isCheckLoading = false;
    notifyListeners();
  }

  Future deleteMedicine(String id) async {
    try {
      await firebaseManager.delete(collection: "medicine", id: id);
      doseTime.clear();
      allMedicineDetails.forEach((element) async {
        if (element.id == id) {
          await firebaseManager.delete(
              collection: "medicine_details", id: element.medId.toString());
          allMedicineDetails.remove(element);
          notifyListeners();
        }
        if (!doseTime.contains(element.doseTime)) {
          doseTime.add(element.doseTime.toString());
        }
      });
      medicineDetails.forEach((element) async {
        if (element.id == id) {
          await firebaseManager.delete(
              collection: "medicine_details", id: element.medId.toString());
          medicineDetails.remove(element);
          notifyListeners();
        }
        if (!doseTime.contains(element.doseTime)) {
          doseTime.add(element.doseTime.toString());
        }
      });
      final d = jsonEncode(doseTime);
      flutterStorage.addNewItem(key: "time", value: d);
      await Hive.box("medicine_reminder")
          .put("all_medicine_details", allMedicineDetails);
      await Hive.box("medicine_reminder")
          .put("medicine_details", medicineDetails);
    } catch (err) {
      rethrow;
    }
    notifyListeners();
  }

  Future updateMedicineData(
      AddMedicine addMedicine, String id, Map medId) async {
    try {
      var medicine = {
        'user_id': userId,
        'medicineName': addMedicine.medicineName,
        "diseaseName": addMedicine.diseaseName,
        "medicineType": addMedicine.medicineType,
        "doseQuantity": addMedicine.doseQuantity,
        "description": addMedicine.description
      };
      await firebaseManager.update(
          collection: "medicine", id: id, data: medicine);
      var ind = data.indexWhere((element) => element.id == id);
      data[ind] = AddMedicine(
        id: id,
        medicineName: addMedicine.medicineName,
        diseaseName: addMedicine.diseaseName,
        medicineType: addMedicine.medicineType,
        doseQuantity: addMedicine.doseQuantity,
        description: addMedicine.description,
      );
      await Hive.box("medicine_reminder").put("medicine", data);
      if (addMedicine.frequency.toString() != "Specific days of the week") {
        week.clear();
      }

      allMedicineDetails.forEach((element) async {
        if (element.id == id) {
          medId.forEach((key, value) async {
            if (value[0].toString() == element.medId.toString() &&
                value[1].toString() == "firstDose") {
              var medicine = {
                'medicine_id': id,
                'user_id': userId,
                "take_it_in_day": addMedicine.takeItInDay,
                "dose": addMedicine.firstDose,
                "dose_type": addMedicine.firstDoseType,
                "frequency": addMedicine.frequency,
                "start_date": addMedicine.startDate,
                "end_date": addMedicine.endDate,
                "week_days": week.isNotEmpty ? week : [],
                "first_dose": addMedicine.doseTime,
                "which_dose": value[1].toString(),
              };
              var index = allMedicineDetails.indexWhere(
                  (element) => value[0].toString() == element.medId.toString());
              var index1 = medicineDetails.indexWhere(
                  (element) => value[0].toString() == element.medId.toString());

              await firebaseManager.update(
                  collection: "medicine_details",
                  id: element.medId.toString(),
                  data: medicine);
              var updatedData = AddMedicine(
                id: id,
                medId: element.medId,
                takeItInDay: addMedicine.takeItInDay,
                dose: addMedicine.firstDose,
                doseTime: addMedicine.doseTime,
                doseType: addMedicine.firstDoseType,
                frequency: addMedicine.frequency,
                startDate: addMedicine.startDate,
                endDate: addMedicine.endDate,
                specificWeekDay: week.isNotEmpty ? week : [],
                whichDose: value[1].toString(),
              );
              allMedicineDetails[index] = updatedData;
              medicineDetails[index1] = updatedData;
            }
            if (value[0].toString() == element.medId.toString() &&
                value[1].toString() == "secondDose") {
              var index = allMedicineDetails.indexWhere(
                  (element) => value[0].toString() == element.medId.toString());
              var index1 = medicineDetails.indexWhere(
                  (element) => value[0].toString() == element.medId.toString());
              var medicine = {
                'medicine_id': id,
                'user_id': userId,
                "take_it_in_day": addMedicine.takeItInDay,
                "dose": addMedicine.secondDose,
                "dose_type": addMedicine.secondDoseType,
                "frequency": addMedicine.frequency,
                "start_date": addMedicine.startDate,
                "end_date": addMedicine.endDate,
                "week_days": week.isNotEmpty ? week : [],
                "second_dose": addMedicine.secondDoseTime,
                "which_dose": value[1].toString(),
              };
              await firebaseManager.update(
                  collection: "medicine_details",
                  id: element.medId.toString(),
                  data: medicine);
              var updatedData = AddMedicine(
                id: id,
                medId: element.medId,
                takeItInDay: addMedicine.takeItInDay,
                dose: addMedicine.secondDose,
                doseTime: addMedicine.secondDoseTime,
                doseType: addMedicine.secondDoseType,
                frequency: addMedicine.frequency,
                startDate: addMedicine.startDate,
                endDate: addMedicine.endDate,
                specificWeekDay: week.isNotEmpty ? week : [],
                whichDose: value[1].toString(),
              );
              allMedicineDetails[index] = updatedData;
              medicineDetails[index1] = updatedData;
            }
            if (value[0].toString() == element.medId.toString() &&
                value[1].toString() == "thirdDose") {
              var index = allMedicineDetails.indexWhere(
                  (element) => value[0].toString() == element.medId.toString());
              var index1 = medicineDetails.indexWhere(
                  (element) => value[0].toString() == element.medId.toString());
              var medicine = {
                'medicine_id': id,
                'user_id': userId,
                "take_it_in_day": addMedicine.takeItInDay,
                "dose": addMedicine.thirdDose,
                "dose_type": addMedicine.thirdDoseType,
                "frequency": addMedicine.frequency,
                "start_date": addMedicine.startDate,
                "end_date": addMedicine.endDate,
                "week_days": week.isNotEmpty ? week : [],
                "third_dose": addMedicine.thirdDoseTime,
                "which_dose": value[1].toString(),
              };
              await firebaseManager.update(
                  collection: "medicine_details",
                  id: element.medId.toString(),
                  data: medicine);
              var updatedData = AddMedicine(
                id: id,
                medId: element.medId,
                takeItInDay: addMedicine.takeItInDay,
                dose: addMedicine.thirdDose,
                doseTime: addMedicine.thirdDoseTime,
                doseType: addMedicine.thirdDoseType,
                frequency: addMedicine.frequency,
                startDate: addMedicine.startDate,
                endDate: addMedicine.endDate,
                specificWeekDay: week.isNotEmpty ? week : [],
                whichDose: value[1].toString(),
              );
              allMedicineDetails[index] = updatedData;
              medicineDetails[index1] = updatedData;
            }
          });
        }
      });
      print("Data:-${medicineDetails[0].doseType}");
      print("Data1:-${allMedicineDetails[0].doseType}");
      await Hive.box("medicine_reminder")
          .put("all_medicine_details", allMedicineDetails);
      notifyListeners();
      await Hive.box("medicine_reminder")
          .put("medicine_details", medicineDetails);
      notifyListeners();
    } catch (err) {
      rethrow;
    }
    isLoading = false;
    notifyListeners();
  }

  Future sortData(DateTime date) async {
    var allDetails = await Hive.box("medicine_reminder").get(
        "all_medicine_details",
        defaultValue: <AddMedicine>[]).cast<AddMedicine>();
    medicineDetails.clear();
    allDetails.forEach((element) {
      DateTime startDate = DateTime.parse(element.startDate.toString());
      DateTime endDate = DateTime.parse(element.endDate.toString());
      var start = DateTime.utc(startDate.year, startDate.month, startDate.day);
      var end = DateTime.utc(endDate.year, endDate.month, endDate.day);
      if ((start.compareTo(date) < 0 || startDate.isAtSameMomentAs(date)) &&
          end.compareTo(date) > 0) {
        medicineDetails.add(element);
      }
    });
    print("Data:-$medicineDetails");
    await Hive.box("medicine_reminder")
        .put("medicine_details", medicineDetails);
    getTakenData(date);
    notifyListeners();
  }

  Future set() async {
    var data = [
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/tablets-150x150.png",
        "name": "Tablet"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/capsule-150x150.png",
        "name": "Capsule"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/solution-150x150.png",
        "name": "Solution"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/antiseptic-150x150.png",
        "name": "Antiseptic"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/Oral-rinse-150x150.png",
        "name": "Oral rinse"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/lotion-150x150.png",
        "name": "Lotion"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/decongestant-spray-150x150.png",
        "name": "Decongestant Spray"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/blood-150x150.png",
        "name": "Blood"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/softgel-150x150.png",
        "name": "Soft-gel"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/ointment-150x150.png",
        "name": "Ointment"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/toothpaste-150x150.png",
        "name": "Toothpaste"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/eye-drops-150x150.png",
        "name": "Eye Drops"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/lozenges-150x150.png",
        "name": "Lozenges"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/caplet-150x150.png",
        "name": "Caplet"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/aspirin-150x150.png",
        "name": "Aspirins"
      },
      {
        "image":
            "https://7esl.com/wp-content/uploads/2017/12/effervescent-tablet-150x150.png",
        "name": "Effervescent tablet"
      },
      {
        'image':
            'https://7esl.com/wp-content/uploads/2017/12/powder-150x150.png',
        "name": "Powder"
      },
      {
        "image":
            "https://cdn.vectorstock.com/i/preview-1x/70/38/injection-vector-31207038.webp",
        "name": "Injection"
      }
    ];
    await FirebaseFirestore.instance
        .collection("medicine_type")
        .add({"data": data});
  }
}
