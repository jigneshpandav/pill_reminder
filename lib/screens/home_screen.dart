import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:medicine_reminder/screens/doctors_screen.dart';
import 'package:medicine_reminder/screens/medication_step_1_screen.dart';
import 'package:medicine_reminder/screens/users_screen.dart';
import 'package:medicine_reminder/utils/statics.dart';
import 'package:medicine_reminder/widgets/radio_option.dart';
import 'package:medicine_reminder/widgets/sticky_date_picker/sticky_date_picker.dart';
import 'package:medicine_reminder/widgets/top_bar.dart';
import 'package:provider/provider.dart';

import '../widgets/action_button.dart';
import '../widgets/expandable_fab.dart';

class HomeScreen extends StatefulWidget {
  static String routeName = '/';
  DateTime? currentDate;
  DateTime? selectedDate;
  String? selectedMonth;

  HomeScreen({
    Key? key,
    this.currentDate,
    this.selectedDate,
    this.selectedMonth,
  }) : super(key: key) {
    currentDate ??= DateTime.now();
    selectedDate ??= currentDate;
    selectedMonth ??= months[selectedDate!.month - 1];
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late Animation<double> _animation;
  late AnimationController _animationController;

  DatePickerController controller = DatePickerController();

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 260,
      ),
    );

    final curvedAnimation = CurvedAnimation(
      curve: Curves.easeInOut,
      parent: _animationController,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        scaffoldKey: scaffoldKey,
        datePickerVisibility: DatePickerVisibility.visible,
        selectedDate: widget.selectedDate,
        onDateChange: (date) {
          if (date != null) {
            setState(() {
              // widget.currentDate = date;
              widget.selectedDate = date;
              widget.selectedMonth = months[(date as DateTime).month - 1];
            });
          }
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          topDatePicker(),
        ],
      ),
      floatingActionButton: FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Add Medication",
            iconColor: kSecondaryColor,
            bubbleColor: kPrimaryColor,
            icon: Icons.settings,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: kSecondaryColor,
            ),
            onPress: () {
              Navigator.of(context).pushNamed(MedicationStep1Screen.routeName);
              _animationController.reverse();
            },
          ),
          // Floating action menu item
          Bubble(
            title: "Users",
            iconColor: kSecondaryColor,
            bubbleColor: kPrimaryColor,
            icon: Icons.people_alt,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: kSecondaryColor,
            ),
            onPress: () {
              Navigator.of(context).pushNamed(UsersScreen.routeName);
              _animationController.reverse();
            },
          ),
          //Floating action menu item
          Bubble(
            title: "Doctors",
            iconColor: kSecondaryColor,
            bubbleColor: kPrimaryColor,
            icon: Icons.local_hospital,
            titleStyle: const TextStyle(
              fontSize: 16,
              color: kSecondaryColor,
            ),
            onPress: () {
              Navigator.of(context).pushNamed(DoctorsScreen.routeName);
              _animationController.reverse();
            },
          ),
        ],

        // animation controller
        animation: _animation,

        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),

        // Floating Action button Icon color
        iconColor: kSecondaryColor,

        // Flaoting Action button Icon
        iconData: Icons.add,
        backGroundColor: kPrimaryColor,
      ),
    );
  }

  Widget topDatePicker() {
    final dataKeyMonth = new GlobalKey();
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
        ),
        color: kPrimaryColor,
      ),
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        children: [
          SizedBox(
            height: 42,
            child: ListView.builder(
              itemCount: months.length,
              controller: ScrollController(
                initialScrollOffset: 42.0 * widget.currentDate!.month,
              ),
              scrollDirection: Axis.horizontal,
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 10, left: 5),
              itemBuilder: (context, index) {
                return RadioOption(
                  key: months[index] == widget.selectedMonth
                      ? dataKeyMonth
                      : null,
                  value: months[index],
                  text: months[index],
                  cardColor: const Color(
                    0xFFFFFFFF,
                  ).withOpacity(
                    0.1,
                  ),
                  deactivateTextColor: const Color(
                    0xFFFFFFFF,
                  ).withOpacity(
                    0.2,
                  ),
                  fontSize: 12,
                  selectedTextColor: Colors.white,
                  selected: months[index] == widget.selectedMonth,
                  onChanged: (Object? value) {
                    setState(() {
                      widget.selectedMonth = value as String;
                    });
                  },
                );
              },
            ),
          ),
          Divider(
            color: const Color(0xFFFFFFFF).withOpacity(0.1),
            thickness: 1,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            child: Provider.value(
              value: widget.selectedMonth,
              builder: (context, child) => StickyDatePicker(
                // key: months.indexOf('${widget.selectedMonth}') + 1 ==
                //             widget.selectedDate!.month &&
                //         widget.selectedDate!.month == widget.currentDate!.month
                //     ? dataKeyDate
                //     : null,
                selectedDate: widget.selectedDate as DateTime,
                selectedMonth: widget.selectedMonth,
                width: 55,
                height: 85,
                controller: controller,
                selectionColor: kCardColor,
                selectedTextColor: kPrimaryColor,
                dateTextStyle: const TextStyle(
                  color: kDateTextColor,
                  fontWeight: gilroyMedium,
                  fontSize: 17,
                ),
                //monthTextStyle: const TextStyle(color: Colors.white),
                dayTextStyle: const TextStyle(
                  color: kDateTextColor,
                  fontWeight: gilroyMedium,
                  fontSize: 10,
                ),
                onDateChange: (date) async {
                  setState(() {
                    widget.currentDate = date;
                    widget.selectedDate = date;
                  });
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
