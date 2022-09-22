import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../utils/text_utils.dart';

class CustomDropDownButton extends StatelessWidget {
  final String? labelText;
  final String initValue;
  final ValueChanged onChanged;
  final Color? color;
  final List<String> itemList;
  final double? contentPadding;
  final bool? filled;

  const CustomDropDownButton({
    this.labelText,
    this.contentPadding = 17,
    required this.initValue,
    required this.onChanged,
    required this.itemList,
    Key? key,
    this.color,
    this.filled,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormField(
      builder: (FormFieldState<dynamic> state) {
        return InputDecorator(
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(
                  left: contentPadding!, right: contentPadding!),
              labelText: labelText,
              fillColor: color,
              filled: filled,
              labelStyle: const TextStyle(
                fontWeight: gilroySemiBold,
                color: kTextColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kTextColor),
                gapPadding: 5,
              )),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              focusColor: kPrimaryColor,
              value: initValue,
              isDense: true,
              borderRadius: BorderRadius.circular(15),
              dropdownColor: kCardColor,
              isExpanded: true,
              style: TextStyle(
                color: color != null ? Colors.white : kTextColor,
                fontWeight: gilroySemiBold,
              ),
              icon: SvgPicture.asset(
                'assets/icons/arrow-bottom.svg',
                height: 20,
                color: color != null ? Colors.white : null,
              ),
              onChanged: onChanged,
              items: itemList.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}
