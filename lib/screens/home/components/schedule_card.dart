import 'package:another_flushbar/flushbar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:medicine_reminder/provider/home_provider.dart';
import 'package:medicine_reminder/provider/medicine_provider.dart';
import 'package:medicine_reminder/screens/home/components/check_box.dart';
import 'package:medicine_reminder/screens/home/components/medicine_details_screen.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_utils.dart';
import '../../../widgets/text_widget.dart';

class ScheduleCard extends StatefulWidget {
  const ScheduleCard(
      {Key? key,
      required this.time,
      required this.timeType,
      required this.id,
      required this.addMedicine,
      required this.date,
      required this.details,
      required this.dose,
      required this.isCompleted,
      required this.medTime,
      required this.index})
      : super(key: key);
  final String time;
  final List medTime;
  final String timeType;
  final String id;
  final bool isCompleted;
  final AddMedicine addMedicine;
  final AddMedicine details;
  final DateTime date;
  final String dose;
  final int index;

  @override
  State<ScheduleCard> createState() => _ScheduleCardState();
}

class _ScheduleCardState extends State<ScheduleCard> {
  bool isTrue = false;
  bool takeIt = false;
  String? image;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddMedicineProvider>(context);
    final homeProvider = Provider.of<HomeProvider>(context);
    String? d;
    for (var element in provider.medicineType) {
      if (element['name'] == widget.addMedicine.medicineType) {
        image = element['image'];
      }
    }
    if (homeProvider.date != null) {
      DateTime date = DateTime.parse(homeProvider.date.toString());
      d = TimeOfDay(hour: date.hour, minute: date.minute).format(context);
    }
    for (var element in widget.medTime) {
      if (element == d) {
        setState(() {
          takeIt = !takeIt;
        });
      }
    }
    return Consumer<AddMedicineProvider>(
      builder: (context, value, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: takeIt ? kCardColor : Colors.white,
            border: Border.all(width: 1, color: Colors.transparent),
          ),
          padding: const EdgeInsets.only(left: 5),
          margin: const EdgeInsets.all(10),
          child: Container(
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
            padding: const EdgeInsets.only(top: 13, left: 10, right: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MedicineDetailScreen(
                                  addMedicine: widget.addMedicine,
                                  details: widget.details,
                                  image: image,
                                )));
                  },
                  child: Container(
                    height: 70,
                    width: 70,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(width: 2, color: kCardColor2)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Hero(
                        tag: widget.addMedicine.id.toString(),
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
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            children: [
                              TextWidget(
                                text:
                                    widget.addMedicine.medicineName.toString(),
                                fontSize: 14,
                                fontWeight: gilroySemiBold,
                                color: kTextColor,
                              ),
                              TextWidget(
                                text: widget.addMedicine.doseQuantity!
                                        .contains("number")
                                    ? ' (${widget.addMedicine.doseQuantity!.split("").first} 0f 10 Pill)'
                                    : widget.addMedicine.doseQuantity!
                                            .contains("ml")
                                        ? ' (${widget.addMedicine.doseQuantity!})'
                                        : ' (${widget.addMedicine.doseQuantity!})',
                                fontSize: 9,
                                fontWeight: gilroyRegular,
                                color: kTextColor,
                              ),
                            ],
                          ),
                          widget.addMedicine.description != ""
                              ? SizedBox(
                                  width: 180,
                                  child: TextWidget(
                                    text: widget.addMedicine.description
                                        .toString(),
                                    fontSize: 9,
                                    fontWeight: gilroyRegular,
                                    color: kTextColor,
                                  ),
                                )
                              : const SizedBox(
                                  height: 10,
                                ),
                          if (widget.addMedicine.description != "")
                            const SizedBox(
                              height: 5,
                            ),
                          Row(
                            children: List.generate(
                              widget.medTime.length,
                              (index) {
                                isTrue = false;
                                for (var element in value.medicineSchedule) {
                                  if (element.dose == widget.dose) {
                                    if (element.id == widget.details.id &&
                                        element.dose == widget.dose &&
                                        widget.date.isAtSameMomentAs(
                                            DateTime.parse(
                                                element.date.toString())) &&
                                        widget.medTime[index].toString() ==
                                            element.doseTime.toString()) {
                                      isTrue = element.isCompleted!;
                                    }
                                  }
                                }
                                return CustomCheckBox(
                                  addMedicine: widget.details,
                                  date: widget.date,
                                  time: widget.medTime[index],
                                  isTrue: isTrue,
                                );
                              },
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: 18,
                            width: 70,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6),
                                color: kCardColor2),
                            child: Center(
                              child: TextWidget(
                                text: widget.details.doseType.toString(),
                                fontSize: 9,
                                fontWeight: gilroyMedium,
                                color: kTextColor,
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              IconButton(
                                splashRadius: 10,
                                iconSize: 30,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(left: 50),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        actions: [
                                          TextButton(
                                            onPressed: () async {
                                              try {
                                                await value
                                                    .deleteMedicine(widget
                                                        .addMedicine.id
                                                        .toString())
                                                    .then((val) async {});
                                                //  Navigator.of(context).pop(true);
                                              } catch (error) {
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
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
                                                duration:
                                                    const Duration(seconds: 3),
                                                messageText: const TextWidget(
                                                  text:
                                                      "Medicine Data removed successfully.",
                                                  fontSize: 15,
                                                  fontWeight: gilroyMedium,
                                                  color: kTextColor,
                                                ),
                                                flushbarPosition:
                                                    FlushbarPosition.BOTTOM,
                                                borderRadius:
                                                    const BorderRadius.only(
                                                        topRight:
                                                            Radius.circular(8),
                                                        topLeft:
                                                            Radius.circular(8)),
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
                                          "Do you want to remove this ${widget.addMedicine.medicineName} form the medicine list?",
                                        ),
                                      );
                                    },
                                  );
                                },
                                icon: SvgPicture.asset(
                                  'assets/icons/ic_delete.svg',
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
