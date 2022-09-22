import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../utils/text_utils.dart';

class Calendar extends StatefulWidget {
  const Calendar(
      {Key? key,
        required this.validator,
        this.labelText,
        this.dateController,
        this.initDate,
        this.onSaved,
        this.contentPadding = 20,
        this.showIcon = true})
      : super(key: key);
  final String? Function(String?)? validator;
  final double? contentPadding;
  final bool showIcon;
  final FormFieldSetter? onSaved;
  final String? labelText;
  final String? initDate;
  final TextEditingController? dateController;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  bool focusedCalendar = false;

  @override
  Widget build(BuildContext context) {
    return FocusScope(
      onFocusChange: (focus) {
        setState(() {
          focusedCalendar = focus;
        });
      },
      child: Focus(
        child: SizedBox(
          child: TextFormField(
            readOnly: true,
            controller: widget.dateController,
            validator: widget.validator,
            initialValue: widget.initDate,
            onSaved: widget.onSaved,
            style: const TextStyle(
              color: kTextColor,
              fontSize: 14,
              fontWeight: gilroySemiBold,
            ),
            onTap: () async {
              Platform.isIOS
                  ? showCupertinoModalPopup(
                  context: context,
                  builder: (BuildContext builder) {
                    return Container(
                      height:
                      MediaQuery.of(context).copyWith().size.height *
                          0.3,
                      color: Colors.white,
                      child: CupertinoDatePicker(
                        mode: CupertinoDatePickerMode.date,
                        onDateTimeChanged: (date) {
                          // ignore: unnecessary_null_comparison
                          if (date == null) {
                            return;
                          }
                          setState(() {
                            var date1 = DateFormat('dd/MM/yyyy').format(
                                DateTime.parse(
                                    date.toString().substring(0, 10)));
                            // var date1 = date.toString().substring(0, 10);
                            widget.dateController!.text = date1.toString();
                          });
                        },
                        initialDateTime: DateTime.now(),
                        minimumYear: 1950,
                        maximumYear: 2050,
                        minimumDate: DateTime.now(),
                      ),
                    );
                  })
                  : showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(),

                  lastDate: DateTime(2100))
                  .then(
                    (date) {
                  if (date == null) {
                    return;
                  }
                  setState(() {
                    widget.dateController!.text =
                        date.toString().substring(0, 10);
                  });
                },
              );
            },
            decoration: InputDecoration(
              contentPadding: EdgeInsets.all(widget.contentPadding!),
              labelText: widget.labelText,
              labelStyle: const TextStyle(
                fontFamily: "Gilroy",
                fontWeight: gilroyRegular,
                color: kTextColor,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SvgPicture.asset(
                  'assets/icons/note.svg',
                ),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: kPrimaryColor),
                gapPadding: 10,
              ),
            ),
            // decoration: InputDecoration(
            //   errorBorder: OutlineInputBorder(
            //     borderSide: const BorderSide(
            //       color: Colors.red,
            //       width: 1,
            //     ),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   focusedErrorBorder: OutlineInputBorder(
            //     borderSide: const BorderSide(color: Colors.red, width: 1),
            //     borderRadius: BorderRadius.circular(10),
            //   ),
            //   focusedBorder: OutlineInputBorder(
            //       borderSide: const BorderSide(
            //         width: 1,
            //         color: Colors.blueAccent,
            //       ),
            //       borderRadius: BorderRadius.circular(10)),
            //   filled: true,
            //   hintText: 'Birthday',
            //   hintStyle: GoogleFonts.workSans(
            //       fontSize: 15, color: Colors.grey, letterSpacing: 0.2),
            //   suffixIcon: InkWell(
            //     child: Padding(
            //       padding: const EdgeInsets.all(15),
            //       child: SizedBox(
            //         height: 20,
            //         child: Image.asset(
            //           'assets/icons/calendar.png',
            //           color: focusedCalendar
            //               ? Theme.of(context).primaryColor
            //               : Colors.grey,
            //         ),
            //       ),
            //     ),
            //   ),
            //     enabledBorder: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(15),
            //       borderSide: const BorderSide(color: Color(0xFF343A4A)),
            //       gapPadding: 10,
            //     )
            // ),
          ),
        ),
      ),
    );
  }
}
