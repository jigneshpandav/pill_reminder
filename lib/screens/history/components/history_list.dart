import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../provider/medicine_provider.dart';
import '../../../utils/text_utils.dart';
import '../../../widgets/text_widget.dart';
import 'history_card.dart';

class HistoryList extends StatelessWidget {
  const HistoryList({Key? key, required this.title, required this.date})
      : super(key: key);
  final String title;
  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final getMedicineData = Provider.of<AddMedicineProvider>(context);

    return Padding(
      padding: const EdgeInsets.only(left: 18.0, bottom: 21.0, right: 18.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text:
                "${title[0].toUpperCase()}${title.substring(1).toLowerCase()}",
            fontSize: 18,
            fontWeight: gilroyBold,
            color: kTextColor,
          ),
          ...List.generate(
            getMedicineData.data.length,
            (index) {
              var result;

              for (var element in getMedicineData.medicineDetails) {
                if (getMedicineData.data[index].id == element.id &&
                    element.dose == title.toLowerCase()) {
                  for (var element1 in getMedicineData.medicineSchedule) {
                    if (element.id == element1.id &&
                        element1.dose == title.toLowerCase() &&
                        date.isAtSameMomentAs(
                            DateTime.parse(element1.date.toString()))) {
                  result = HistoryCard(
                    medicineName:
                        getMedicineData.data[index].medicineName.toString(),
                    description:
                        getMedicineData.data[index].description.toString(),
                    addMedicine: getMedicineData.data[index],
                    // isDone: element1.isCompleted!,
                    image: 'assets/icons/Medicine.svg',
                    date: date,
                    title: title,
                    // medTime: element1.doseTime.toString(),
                    timeType: element.doseType.toString(),
                  );
                    }
                  }

                  // ScheduleCard(
                  //   image: 'assets/icons/Medicine.svg',
                  //   date: date,
                  //   dose: element.dose!,
                  //   isCompleted: false,
                  //   time: element.doseTime.toString(),
                  //   timeType: element.doseType.toString(),
                  //   id: getMedicineData.data[index].id.toString(),
                  //   addMedicine: getMedicineData.data[index],
                  //   details: element,
                  // );
                }
              }
              if (result != null) {
                return result;
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
