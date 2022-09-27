import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../utils/statics.dart';
import 'tap.dart';

class StickyDate extends StatelessWidget {
  final double? width;
  final DateTime date;
  final TextStyle? monthTextStyle, dayTextStyle, dateTextStyle;
  final Color selectionColor;
  final DateSelectionCallback? onDateSelected;
  final String? locale;
  final bool isSelected;

  const StickyDate({
    Key? key,
    this.isSelected = false,
    required this.date,
    required this.monthTextStyle,
    required this.dayTextStyle,
    required this.dateTextStyle,
    required this.selectionColor,
    this.width,
    this.onDateSelected,
    this.locale,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isTrue = false;
    // for (var dataEle in provider.data) {
    //   for (var medDet in provider.medicineDetails) {
    //     DateTime startDate = DateTime.parse(medDet.startDate.toString());
    //     DateTime endDate = DateTime.parse(medDet.endDate.toString());
    //     var start =
    //         DateTime.utc(startDate.year, startDate.month, startDate.day);
    //     var end = DateTime.utc(endDate.year, endDate.month, endDate.day);
    //     var d = DateFormat("EEEE").format(date);
    //     if (dataEle.id == medDet.id &&
    //         medDet.specificWeekDay!.isNotEmpty &&
    //         (start.compareTo(date) < 0 || startDate.isAtSameMomentAs(date)) &&
    //         end.compareTo(date) > 0) {
    //       for (var element in medDet.specificWeekDay!) {
    //         if (d == element) {
    //           isTrue = true;
    //         }
    //       }
    //     }
    //   }
    // }
    return InkWell(
      child: Container(
        width: width,
        margin: const EdgeInsets.symmetric(vertical: 7, horizontal: 3.5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          color: isSelected
              ? selectionColor
              : const Color(0xFFFFFFFF).withOpacity(0.1),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Text(new DateFormat("MMM", locale).format(date).toUpperCase(), // Month
              //     style: monthTextStyle),
              if (isTrue)
                SvgPicture.asset("assets/icons/down_arrow.svg",
                    height: 9, color: isSelected ? kPrimaryColor : kCardColor),
              if (!isTrue)
                const SizedBox(
                  height: 9,
                ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(date.day.toString(), style: dateTextStyle),
                    Text(DateFormat("E", locale).format(date).toUpperCase(),
                        style: dayTextStyle),
                  ],
                ),
              ),

              // SizedBox(
              //   height: getProportionateScreenHeight(1),
              // ),
              // Container(
              //   height: 6,
              //   width: 6,
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(3),
              //     color: Colors.green,
              //   ),
              // ),
            ],
          ),
        ),
      ),
      onTap: () {
        // Check if onDateSelected is not null
        if (onDateSelected != null) {
          // Call the onDateSelected Function
          onDateSelected!(date);
        }
      },
    );
  }
}
