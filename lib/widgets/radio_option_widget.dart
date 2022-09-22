import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/widgets/text_widget.dart';

import '../utils/text_utils.dart';

class MyRadioOption<T> extends StatelessWidget {
  final T value;
  final T? groupValue;
  final String? label;
  final String? text;
  final ValueChanged<T?> onChanged;
  final bool? isAddForm;
  final String? image;
  final Color? cardColor;
  final Color? deactivateTextColor;
  final Color? selectedTextColor;
  final Color? borderColor;
  final double? fontSize;

  const MyRadioOption({
    required this.value,
    required this.groupValue,
    this.label,
    this.text,
    required this.onChanged,
    Key? key,
    this.isAddForm = false,
    this.image,
    this.cardColor,
    this.deactivateTextColor,
    this.fontSize, this.selectedTextColor, this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;
    return InkWell(
      onTap: () => onChanged(value),
      child: isAddForm!
          ? Container(
        height: 52,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: kTextColor2),
          color: isSelected ? kPrimaryColor : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              image!,
              color: isSelected ? Colors.white : kTextColor2,
              height: 24,
            ),
            TextWidget(
              text: text.toString(),
              fontSize: 7,
              color: isSelected ? Colors.white : kTextColor2,
              fontWeight: gilroyRegular,
            ),
          ],
        ),
      )
          : Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: isSelected ? cardColor : null,
          border: Border.all(color: borderColor ?? Colors.transparent),
        ),
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Center(
          child: TextWidget(
            text: text.toString(),
            color: isSelected ? selectedTextColor : deactivateTextColor,
            fontWeight: gilroyMedium,
            fontSize: fontSize,
          ),
        ),
      ),
    );
  }
}
