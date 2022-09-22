import 'dart:convert';

import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:medicine_reminder/provider/flutter_storage.dart';
import 'package:medicine_reminder/utils/text_utils.dart';
import 'package:medicine_reminder/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import '../../../provider/medicine_provider.dart';
import '../../add-medicine/add_medicine_screen.dart';
import '../home_screen.dart';

class MedicineDetailScreen extends StatelessWidget {
  static const routeName = 'med-detail';

  const MedicineDetailScreen(
      {Key? key, this.addMedicine, this.details, this.image})
      : super(key: key);
  final AddMedicine? addMedicine;
  final AddMedicine? details;
  final String? image;

  @override
  Widget build(BuildContext context) {
    final medicineProvider = Provider.of<AddMedicineProvider>(context);
    FlutterStorage flutterStorage = FlutterStorage();
    List<AddMedicine> morning = [];
    List<AddMedicine> afternoon = [];
    List<AddMedicine> night = [];
    morning.clear();
    afternoon.clear();
    night.clear();
    for (var element in medicineProvider.medicineDetails) {
      if (element.id == addMedicine!.id) {
        if (element.dose == "morning") {
          morning.add(element);
          // morning = element;
        } else if (element.dose == "afternoon") {
          // afternoon = element;
          afternoon.add(element);
        } else if (element.dose == "night") {
          //night = element;
          night.add(element);
        }
      }
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          },
          splashRadius: 20,
          icon: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 25,
            width: 25,
          ),
        ),
        title: const TextWidget(
          text: "Medicine Detail",
          color: Colors.white,
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, AddMedicineScreen.routeName,
                    arguments: [addMedicine, details]);
              },
              icon: const Icon(Icons.edit)),
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      actions: [
                        TextButton(
                          onPressed: () async {
                            try {
                              await medicineProvider
                                  .deleteMedicine(addMedicine!.id.toString())
                                  .then((value) {
                                medicineProvider
                                    .getData(
                                        date: DateTime(
                                            DateTime.now().year,
                                            DateTime.now().month,
                                            DateTime.now().day))
                                    .then((value) async {
                                  // final prefs =
                                  //     await SharedPreferences.getInstance();
                                  final d =
                                      jsonEncode(medicineProvider.doseTime);
                                  await flutterStorage.addNewItem(
                                      key: "time", value: d);
                                  // prefs.setString("time", d);
                                  // prefs.getString("time");
                                });
                              });
                              Navigator.of(context).pop(true);
                            } catch (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    "There is some error occurred while removing person!",
                                  ),
                                ),
                              );
                            }
                            Navigator.of(context).pop(false);
                            Flushbar(
                              backgroundColor: Colors.white,
                              duration: const Duration(seconds: 3),
                              messageText: const TextWidget(
                                text: "Medicine Data removed successfully.",
                                fontSize: 15,
                                fontWeight: gilroyMedium,
                                color: kTextColor,
                              ),
                              flushbarPosition: FlushbarPosition.BOTTOM,
                              borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(8),
                                  topLeft: Radius.circular(8)),
                            ).show(context);
                          },
                          child: const Text("Yes"),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("No"),
                        ),
                      ],
                      title: const Text(
                        "Are you sure?",
                      ),
                      content: Text(
                        "Do you want to remove this ${addMedicine!.medicineName}?",
                      ),
                    );
                  },
                );
              },
              icon: const Icon(Icons.delete_outline)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 35,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const TextWidget(
                      text: "Start Date:",
                      fontSize: 10,
                      fontWeight: gilroyMedium,
                      color: kTextColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: details!.startDate.toString(),
                      fontWeight: gilroyMedium,
                      color: kTextColor,
                    )
                  ],
                ),
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      border: Border.all(
                        color: kCardColor2,
                        width: 2.5,
                      )),
                  padding: const EdgeInsets.all(3),
                  child: Hero(
                    tag: addMedicine!.id.toString(),
                    child: CachedNetworkImage(
                      imageUrl: image.toString(),
                      fit: BoxFit.fill,
                      placeholder: (context, url) => const Padding(
                        padding: EdgeInsets.all(2.0),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    const TextWidget(
                      text: "End Date:",
                      fontSize: 10,
                      fontWeight: gilroyMedium,
                      color: kTextColor,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextWidget(
                      text: details!.endDate.toString(),
                      fontWeight: gilroyMedium,
                      color: kTextColor,
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextWidget(
                text:
                    "${addMedicine!.medicineName.toString()[0].toUpperCase()}${addMedicine!.medicineName.toString().substring(1).toLowerCase()} ${addMedicine!.medicineType}",
                color: kTextColor,
                fontSize: 20,
                fontWeight: gilroySemiBold,
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Center(
              child: TextWidget(
                text:
                    "${addMedicine!.diseaseName.toString()[0].toUpperCase()}${addMedicine!.diseaseName.toString().substring(1).toLowerCase()}",
                color: kTextColor,
                fontSize: 15,
                fontWeight: gilroyRegular,
              ),
            ),
            const SizedBox(
              height: 45,
            ),
            if (morning.isNotEmpty) buildPadding(morning),
            if (afternoon.isNotEmpty) buildPadding(afternoon),
            if (night.isNotEmpty) buildPadding(night),
            if (details!.specificWeekDay!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: kCardColor2),
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextWidget(
                        text: "SpecificWeekDay:",
                        color: kTextColor,
                        fontSize: 15,
                        textAlign: TextAlign.center,
                        fontWeight: gilroyMedium,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: List.generate(
                            details!.specificWeekDay!.length, (index) {
                          return Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: kScaffoldColor,
                              ),
                              padding: const EdgeInsets.all(5),
                              child: Center(
                                child: TextWidget(
                                  text: details!.specificWeekDay![index],
                                  fontSize: 10,
                                  fontWeight: gilroyMedium,
                                  color: kTextColor,
                                ),
                              ),
                            ),
                          );
                        }),
                      )
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Padding buildPadding(List<AddMedicine> details) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        children: List.generate(
          details.length,
          (index) => Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12), color: kCardColor2),
              padding: const EdgeInsets.all(15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 70,
                    child: TextWidget(
                      text:
                          "${details[index].dose.toString()[0].toUpperCase()}${details[index].dose.toString().substring(1)..toLowerCase()}",
                      color: kTextColor,
                      textAlign: TextAlign.center,
                      fontWeight: gilroyMedium,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: details[index].doseType.toString(),
                    textAlign: TextAlign.center,
                    color: kTextColor,
                    fontWeight: gilroyMedium,
                  ),
                  TextWidget(
                    text: addMedicine!.doseQuantity!.contains("number")
                        ? ' (${addMedicine!.doseQuantity!.split("").first} 0f 10 Pill)'
                        : addMedicine!.doseQuantity!.contains("ml")
                            ? ' (${addMedicine!.doseQuantity!})'
                            : ' (${addMedicine!.doseQuantity!})',
                    // fontSize: 10,
                    fontWeight: gilroyRegular,
                    color: kTextColor,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: details[index].doseTime.toString(),
                    textAlign: TextAlign.center,
                    color: kTextColor,
                    fontWeight: gilroyMedium,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
