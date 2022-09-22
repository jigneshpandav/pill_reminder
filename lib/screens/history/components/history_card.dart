import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:provider/provider.dart';

import '../../../provider/medicine_provider.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/text_widget.dart';
import '../../home/components/check_box.dart';

class HistoryCard extends StatefulWidget {
  const HistoryCard({
    Key? key,
    required this.medicineName,
    required this.description,
    required this.image,
    // required this.medTime,
    required this.timeType,
    required this.addMedicine,
    required this.date,
    this.title,
    // required this.isDone,
  }) : super(key: key);
  final String medicineName;
  final String description;
  final String image;

  // final String medTime;
  final String timeType;
  final String? title;
  final AddMedicine addMedicine;
  final DateTime date;

  // final bool isDone;

  @override
  State<HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<HistoryCard> {
  @override
  Widget build(BuildContext context) {
    String time = "";
    bool isDone = false;
    final provider = Provider.of<AddMedicineProvider>(context);
    String? image;
    List medTime = [];
    for (var element in provider.medicineType) {
      if (element['name'] == widget.addMedicine.medicineType) {
        image = element['image'];
      }
    }
    // var medTime;
    // widget.medTime.forEach((element) {
    //   if (element == d) {
    //     setState(() {
    //       takeIt = !takeIt;
    //     });
    //   }
    // });
    for (var element1 in provider.medicineSchedule) {
      if (widget.addMedicine.id == element1.id &&
          element1.dose == widget.title!.toLowerCase() &&
          widget.date
              .isAtSameMomentAs(DateTime.parse(element1.date.toString()))) {
        medTime.add(element1.doseTime);
        isDone = element1.isCompleted!;
        time = element1.doseTime.toString();
      }
    }
    return Container(
      height: 95,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      padding: const EdgeInsets.only(top: 13, left: 10, right: 10),
      margin: const EdgeInsets.only(bottom: 10, top: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(width: 2, color: kCardColor2)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CachedNetworkImage(
                imageUrl: image.toString(),
                fit: BoxFit.fill,
                placeholder: (context, url) => const Padding(
                  padding: EdgeInsets.all(2.0),
                  child: Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        TextWidget(
                          text: widget.medicineName,
                          fontSize: 14,
                          fontWeight: gilroySemiBold,
                          color: kTextColor,
                        ),
                        TextWidget(
                          text: widget.addMedicine.doseQuantity!
                                  .contains("number")
                              ? ' (${widget.addMedicine.doseQuantity!.split("").first} 0f 10 Pill)'
                              : widget.addMedicine.doseQuantity!.contains("ml")
                                  ? ' (${widget.addMedicine.doseQuantity!})'
                                  : ' (${widget.addMedicine.doseQuantity!})',
                          fontSize: 9,
                          fontWeight: gilroyRegular,
                          color: kTextColor,
                        ),
                      ],
                    ),
                    Container(
                      height: 18,
                      width: 70,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(6),
                          color: kCardColor2),
                      child: Center(
                        child: TextWidget(
                          text: widget.timeType,
                          fontSize: 9,
                          fontWeight: gilroyMedium,
                          color: kTextColor,
                        ),
                      ),
                    ),
                    // Container(
                    //   height: 16,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: kCardColor),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    //     child: Center(
                    //       child: TextWidget(
                    //         text: widget.time,
                    //         fontSize: 7,
                    //         fontWeight: gilroySemiBold,
                    //         color: kTextColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 5,
                    ),
                    widget.description != ""
                        ? TextWidget(
                            text: widget.description,
                            fontSize: 9,
                            fontWeight: gilroyRegular,
                            color: kTextColor2,
                          )
                        : const SizedBox(
                            height: 20,
                          ),
                    if (widget.addMedicine.description != "")
                      const SizedBox(
                        height: 10,
                      ),
                    // Container(
                    //   height: 16,
                    //   decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: kCardColor),
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    //     child: Center(
                    //       child: TextWidget(
                    //         text: time,
                    //         fontSize: 7,
                    //         fontWeight: gilroySemiBold,
                    //         color: kTextColor,
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Row(
                      children: List.generate(
                        medTime.length,
                        (index) {
                          return CustomCheckBox(
                            addMedicine: widget.addMedicine,
                            time: medTime.reversed.toList()[index],
                            isTrue: isDone,
                          );
                        },
                      ),
                    ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Container(
                    //       height: 18,
                    //       width: 70,
                    //       decoration: BoxDecoration(
                    //           borderRadius: BorderRadius.circular(6),
                    //           color: kCardColor2),
                    //       child: Center(
                    //         child: TextWidget(
                    //           text: widget.timeType,
                    //           fontSize: 7,
                    //           fontWeight: gilroyMedium,
                    //           color: kTextColor,
                    //         ),
                    //       ),
                    //     ),
                    //     // IconButton(
                    //     //     splashRadius: 10,
                    //     //     alignment: Alignment.centerRight,
                    //     //     onPressed: () {},
                    //     //     icon: widget.isDone
                    //     //         ? SvgPicture.asset(
                    //     //             'assets/icons/tick-square.svg',
                    //     //             height: 18,
                    //     //             width: 18,
                    //     //           )
                    //     //         : SvgPicture.asset(
                    //     //             'assets/icons/tick-square-false.svg',
                    //     //             height: 18,
                    //     //             width: 18,
                    //     //           ))
                    //   ],
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
