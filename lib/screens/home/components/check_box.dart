import 'package:flutter/material.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:medicine_reminder/provider/medicine_provider.dart';
import 'package:provider/provider.dart';

import '../../../utils/text_utils.dart';
import '../../../widgets/text_widget.dart';

class CustomCheckBox extends StatefulWidget {
  const CustomCheckBox({
    Key? key,
    this.isTrue = false,
    this.addMedicine,
    this.date,
    this.time,
  }) : super(key: key);
  final bool? isTrue;
  final AddMedicine? addMedicine;
  final DateTime? date;
  final String? time;

  @override
  State<CustomCheckBox> createState() => _CustomCheckBoxState();
}

class _CustomCheckBoxState extends State<CustomCheckBox> {
  @override
  Widget build(BuildContext context) {
    bool isCheck = widget.isTrue!;
    return Consumer<AddMedicineProvider>(
      builder: (context, value, child) => GestureDetector(
        onTap: () {
          if (isCheck) {
          } else {
            setState(() {
              isCheck = !isCheck;
              value.isCheckLoading = true;
              value
                  .taken(widget.addMedicine!, widget.date!, widget.time!)
                  .then((val) {
                 value.getTakenData(widget.date!).then((v) {});
                 value.isCheckLoading = false;
              });
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: Container(
            height: 25,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border:
                  Border.all(color: isCheck ? kCheckBackGround : kTextColor2),
              color: isCheck ? kCheckBackGround : null,
            ),
            child: Padding(
              padding: const EdgeInsets.only(left: 7.0, right: 7.0),
              child: Center(
                child: value.isCheckLoading
                    ? const SizedBox(
                        height: 10,
                        width: 10,
                        child: CircularProgressIndicator(
                          strokeWidth: 1.5,
                        ))
                    : TextWidget(
                        text: widget.time!,
                        fontSize: 9,
                        fontWeight: gilroySemiBold,
                        color: isCheck ? kCheckColor : kTextColor2,
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
