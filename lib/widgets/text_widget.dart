import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final TextDecoration? textDecoration;
  final Color? decorationColor;
  final double? height;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const TextWidget(
      {required this.text,
        this.decorationColor,
        this.textOverflow,
        this.color,
        this.fontSize,
        this.fontWeight,
        this.textAlign,
        this.textDecoration,
        this.height,
        this.maxLines,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        decoration: textDecoration,
        height: height,
        decorationColor: decorationColor,
      ),
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: textOverflow,
    );
  }
}
