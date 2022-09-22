import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/provider/medicine_provider.dart';
import 'package:medicine_reminder/screens/home/components/schedule_card.dart';
import 'package:medicine_reminder/utils/size_config.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_utils.dart';
import '../../../widgets/text_widget.dart';

class MedicineCard extends StatefulWidget {
  const MedicineCard({Key? key, this.date, this.dose}) : super(key: key);
  final DateTime? date;
  final String? dose;

  @override
  State<MedicineCard> createState() => _MedicineCardState();
}

class _MedicineCardState extends State<MedicineCard> {
  @override
  Widget build(BuildContext context) {
    final getMedicineData = Provider.of<AddMedicineProvider>(context);
    return getMedicineData.isLoading
        ? SizedBox(
            height: SizeConfig.screenHeight! * 0.5,
            child: const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : getMedicineData.medicineDetails.isEmpty
            ? SizedBox(
                height: SizeConfig.screenHeight! * 0.5,
                child: const Center(
                  child: TextWidget(text: "No Data Found!"),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.date!.day == DateTime.now().day &&
                      widget.date!.month == DateTime.now().month)
                    const Padding(
                      padding: EdgeInsets.only(left: 18.0, top: 21),
                      child: TextWidget(
                        text: 'Today’s Schedule',
                        fontSize: 18,
                        fontWeight: gilroyBold,
                        color: kTextColor,
                      ),
                    ),
                  if (!(widget.date!.day == DateTime.now().day &&
                      widget.date!.month == DateTime.now().month))
                    Padding(
                      padding: const EdgeInsets.only(left: 18.0, top: 21),
                      child: TextWidget(
                        text:
                            '${DateFormat.MMMd().format(widget.date!)} Schedule',
                        fontSize: 18,
                        fontWeight: gilroyBold,
                        color: kTextColor,
                      ),
                    ),
                  ...List.generate(
                    getMedicineData.data.length,
                    (index) {
                      var result;
                      List medTime = [];
                      int i = 0;
                      medTime.clear();
                      for (var element in getMedicineData.medicineDetails) {
                        if (getMedicineData.data[index].id == element.id &&
                            element.dose == widget.dose!) {
                          if (element.specificWeekDay!.isNotEmpty) {
                            for (var element1 in element.specificWeekDay!) {
                              var d = DateFormat("EEEE").format(widget.date!);
                              if (d == element1) {
                                medTime.add(element.doseTime);
                                result = ScheduleCard(
                                  date: widget.date!,
                                  dose: element.dose!,
                                  medTime: medTime,
                                  isCompleted: false,
                                  time: medTime[i],
                                  timeType: element.doseType.toString(),
                                  id: getMedicineData.data[index].id.toString(),
                                  addMedicine: getMedicineData.data[index],
                                  details: element,
                                  index: index,
                                );
                                i++;
                              }
                            }
                          }
                          if (element.specificWeekDay!.isEmpty) {
                            medTime.add(element.doseTime);
                            result = ScheduleCard(
                              date: widget.date!,
                              dose: element.dose!,
                              medTime: medTime,
                              isCompleted: false,
                              time: medTime[i].toString(),
                              timeType: element.doseType.toString(),
                              id: getMedicineData.data[index].id.toString(),
                              addMedicine: getMedicineData.data[index],
                              details: element,
                              index: index,
                            );
                            i++;
                          }
                        }
                      }
                      if (result != null) {
                        return result;
                      }
                      return const SizedBox();
                    },
                  ),
                ],
              );
  }
}
