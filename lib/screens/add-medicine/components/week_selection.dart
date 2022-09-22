import 'package:flutter/material.dart';
import 'package:medicine_reminder/provider/medicine_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_utils.dart';
import '../../../widgets/text_widget.dart';

class WeekSelection extends StatefulWidget {
  const WeekSelection({Key? key, required this.title, this.data})
      : super(key: key);
  final String title;
  final List? data;

  @override
  State<WeekSelection> createState() => _WeekSelectionState();
}

class _WeekSelectionState extends State<WeekSelection> {
  bool isSelected = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final provider = Provider.of<AddMedicineProvider>(context, listen: false);
    provider.week.clear();
     provider.weekList.forEach((element) {
       provider.week.add(element);
     });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddMedicineProvider>(context);
    if (widget.data != null) {
      widget.data!.forEach((element) {
        if (widget.title == element) {
          isSelected = true;
        }
      });
    }
    print(provider.week);
    return GestureDetector(
      onTap: () {
        setState(() {
          isSelected = !isSelected;
          if (isSelected) {
            provider.week.add(widget.title);
          } else {
            provider.week.remove(widget.title);
            provider.weekList.remove(widget.title);
          }
        });
      },
      child: Container(
        height: 18,
        width: 50,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: isSelected ? kCardColor2 : Colors.transparent,
            border: Border.all(color: kTextColor2)),
        child: Center(
          child: TextWidget(
            text: widget.title,
            fontSize: 7,
            fontWeight: gilroyMedium,
            color: isSelected ? kTextColor : kTextColor2,
          ),
        ),
      ),
    );
  }
}
