import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/widgets/top_bar_dropdown.dart';
import 'package:medicine_reminder/widgets/top_bar_text.dart';

import '../utils/statics.dart';

enum DatePickerVisibility {
  visible,
  invisible,
}

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  String? title;
  DateTime? selectedDate;
  DatePickerVisibility? datePickerVisibility;
  Function? onDateChange;

  TopBar({
    Key? key,
    required this.scaffoldKey,
    this.title = "Medications",
    this.datePickerVisibility = DatePickerVisibility.invisible,
    this.selectedDate,
    this.onDateChange,
  }) : super(key: key) {
    selectedDate ??= DateTime.now();
  }

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () {
          widget.scaffoldKey.currentState!.openDrawer();
        },
        icon: SvgPicture.asset(
          'assets/icons/menu.svg',
          height: 24,
          width: 24,
        ),
      ),
      centerTitle: true,
      title: TopBarText(
        text: '${widget.title}',
        fontSize: 17,
        fontWeight: gilroyBold,
        color: kSecondaryColor,
      ),
      actions: [
        if (widget.datePickerVisibility == DatePickerVisibility.visible)
          SizedBox(
            height: 30,
            width: 80,
            child: InkWell(
              onTap: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: widget.selectedDate as DateTime,
                  firstDate: widget.selectedDate!.subtract(
                    const Duration(
                      days: 60,
                    ),
                  ),
                  lastDate: widget.selectedDate!.add(
                    const Duration(
                      days: 60,
                    ),
                  ),
                );
                widget.onDateChange!(picked);
              },
              child: const Icon(
                Icons.edit_calendar,
                color: kSecondaryColor,
              ),
            ),
          ),
      ],
    );
  }
}
