import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/widgets/top_bar_text.dart';

import '../utils/statics.dart';

class RadioOption<T> extends StatelessWidget {
  final T value;
  final String? label;
  final String? text;
  final ValueChanged<T?> onChanged;
  final bool? isAddForm;
  final String? image;
  final Color? cardColor;
  final Color? deactivateTextColor;
  final bool? selected;
  final Color? selectedTextColor;
  final Color? borderColor;
  final double? fontSize;

  const RadioOption({
    required this.value,
    this.label,
    this.text,
    required this.onChanged,
    Key? key,
    this.isAddForm = false,
    this.image,
    this.cardColor,
    this.deactivateTextColor,
    this.fontSize,
    this.selected = false,
    this.selectedTextColor,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(value),
      child: isAddForm!
          ? Container(
              height: 52,
              width: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: kTextColor2),
                color: selected as bool ? kPrimaryColor : null,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    image!,
                    color: selected as bool ? Colors.white : kTextColor2,
                    height: 24,
                  ),
                  TopBarText(
                    text: text.toString(),
                    fontSize: 7,
                    color: selected as bool ? Colors.white : kTextColor2,
                    fontWeight: gilroyRegular,
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: selected as bool ? cardColor : null,
                border: Border.all(color: borderColor ?? Colors.transparent),
              ),
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: Center(
                child: TopBarText(
                  text: text.toString(),
                  color: selected as bool
                      ? selectedTextColor
                      : deactivateTextColor,
                  fontWeight: gilroyMedium,
                  fontSize: fontSize,
                ),
              ),
            ),
    );
  }
}
