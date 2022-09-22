import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';


import '../utils/text_utils.dart';

class CustomTextFormField extends StatelessWidget {
  final String? labelText;
  final FormFieldSetter? onSaved;
  final FormFieldValidator? validator;
  final Function(String)? onChanged;
  final TextEditingController textController;
  final TextInputType? textInputType;
  final bool obscureText;
  final bool showSuffixIcon;
  final bool readOnly;
  final String? suffixIcon;
  final Function()? onTap;
  final Function()? suffixOnTap;
  final String? initValue;
  final int? maxLine;
  final double? contentPadding;

  const CustomTextFormField({
    required this.textController,
    this.contentPadding = 20,
    this.obscureText = false,
    this.suffixOnTap,
    this.maxLine = 1,
    this.textInputType,
    this.labelText,
    this.validator,
    this.initValue,
    this.readOnly = false,
    this.onSaved,
    this.showSuffixIcon = false,
    this.suffixIcon = "",
    this.onTap,
    Key? key,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isPng = suffixIcon!.split(".").last;
    return TextFormField(
      controller: textController,
      obscureText: obscureText,
      validator: validator,
      autocorrect: true,
      showCursor: true,
      readOnly: readOnly,
      keyboardType: textInputType,
      textInputAction: TextInputAction.newline,
      style: const TextStyle(color: kTextColor,fontWeight: gilroySemiBold),
      onTap: onTap,
      initialValue: initValue,
      maxLines: maxLine,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(contentPadding!),
          labelText: labelText,
          suffixIcon: showSuffixIcon && suffixOnTap == null
              ? Container(
            padding: const EdgeInsets.all(10),
            child: isPng == "png"
                ? Image.asset(
              suffixIcon.toString(),
              width: 10,
              height: 10,
            )
                : SvgPicture.asset(suffixIcon.toString(),
                width: 10, height: 10),
          )
              : suffixOnTap != null ? GestureDetector(
            onTap: suffixOnTap,
            child: Container(
                padding: const EdgeInsets.all(10),
                child: SvgPicture.asset(suffixIcon == null || !showSuffixIcon ?
                "assets/icons/add.svg" : suffixIcon.toString(),
                  width: 10,
                  height: 10,
                )),
          ) : null,
          labelStyle: const TextStyle(
            fontFamily: "Gilroy",
            fontWeight: gilroyRegular,
            color: Color(0xFF7D8399),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: kPrimaryColor),
            gapPadding: 10,
          )),
      onSaved: onSaved,
    );
  }
}
