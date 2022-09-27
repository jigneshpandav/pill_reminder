import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import '../../utils/statics.dart';
import 'color.dart';
import 'sticky_date.dart';
import 'style.dart';
import 'tap.dart';

class StickyDatePicker extends StatefulWidget {
  /// Start Date in case user wants to show past dates
  /// If not provided calendar will start from the initialSelectedDate
  DateTime? startDate;

  /// Width of the selector
  final double width;

  /// Height of the selector
  final double height;

  /// DatePicker Controller
  final DatePickerController? controller;

  /// Text color for the selected Date
  final Color selectedTextColor;

  /// Background color for the selector
  final Color selectionColor;

  /// Text Color for the deactivated dates
  final Color deactivatedColor;

  /// TextStyle for Month Value
  final TextStyle monthTextStyle;

  /// TextStyle for day Value
  final TextStyle dayTextStyle;

  /// TextStyle for the date Value
  final TextStyle dateTextStyle;

  /// Current Selected Date
  final DateTime selectedDate;

  final String? selectedMonth;

  /// Contains the list of inactive dates.
  /// All the dates defined in this List will be deactivated
  final List<DateTime>? inactiveDates;

  /// Contains the list of active dates.
  /// Only the dates in this list will be activated.
  final List<DateTime>? activeDates;

  /// Callback function for when a different date is selected
  final DateChangeListener? onDateChange;

  /// Locale for the calendar default: en_us
  final String locale;

  StickyDatePicker({
    Key? key,
    required this.selectedDate,
    this.selectedMonth,
    this.width = 60,
    this.height = 80,
    this.controller,
    this.monthTextStyle = defaultMonthTextStyle,
    this.dayTextStyle = defaultDayTextStyle,
    this.dateTextStyle = defaultDateTextStyle,
    this.selectedTextColor = Colors.white,
    this.selectionColor = AppColors.defaultSelectionColor,
    this.deactivatedColor = AppColors.defaultDeactivatedColor,
    this.activeDates,
    this.inactiveDates,
    this.onDateChange,
    this.locale = "en_US",
  })  : assert(
            activeDates == null || inactiveDates == null,
            "Can't "
            "provide both activated and deactivated dates List at the same time."),
        super(key: key);

  @override
  State<StatefulWidget> createState() => _StickyDatePickerState();
}

class _StickyDatePickerState extends State<StickyDatePicker> {
  // DateTime? _currentDate;

  final ScrollController _controller = ScrollController();

  late final TextStyle selectedDateStyle;
  late final TextStyle selectedMonthStyle;
  late final TextStyle selectedDayStyle;

  late final TextStyle deactivatedDateStyle;
  late final TextStyle deactivatedMonthStyle;
  late final TextStyle deactivatedDayStyle;

  @override
  void initState() {
    // Init the calendar locale
    initializeDateFormatting(widget.locale, null);
    // Set initial Values
    // _currentDate = widget.selectedDate;

    if (widget.controller != null) {
      widget.controller!.setDatePickerState(this);
    }

    selectedDateStyle = widget.dateTextStyle.copyWith(
      color: widget.selectedTextColor,
      fontWeight: gilroyBold,
    );
    selectedMonthStyle = widget.monthTextStyle.copyWith(
      color: widget.selectedTextColor,
    );
    selectedDayStyle = widget.dayTextStyle.copyWith(
      color: widget.selectedTextColor,
      fontWeight: gilroyMedium,
    );

    deactivatedDateStyle = widget.dateTextStyle.copyWith(
      color: widget.deactivatedColor,
    );
    deactivatedMonthStyle = widget.monthTextStyle.copyWith(
      color: widget.deactivatedColor,
    );
    deactivatedDayStyle = widget.dayTextStyle.copyWith(
      color: widget.deactivatedColor,
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      child: ListView.builder(
        itemCount: daysInMonth(
          months.indexOf('${widget.selectedMonth}') + 1,
          widget.selectedDate.year,
        ),
        scrollDirection: Axis.horizontal,
        controller: ScrollController(
          initialScrollOffset: (widget.height - 32) * widget.selectedDate!.day,
        ),
        itemBuilder: (context, index) {
          // get the date object based on the index position
          // if widget.startDate is null then use the initialDateValue
          DateTime date;
          DateTime date1 = DateTime(
            widget.selectedDate.year,
            months.indexOf('${widget.selectedMonth}') + 1,
            index + 1,
          );
          date = DateTime(date1.year, date1.month, date1.day);

          bool isDeactivated = false;

          // check if this date needs to be deactivated for only DeactivatedDates
          if (widget.inactiveDates != null) {
//            print("Inside Inactive dates.");
            for (DateTime inactiveDate in widget.inactiveDates!) {
              if (_compareDate(date, inactiveDate)) {
                isDeactivated = true;
                break;
              }
            }
          }

          // check if this date needs to be deactivated for only ActivatedDates
          if (widget.activeDates != null) {
            isDeactivated = true;
            for (DateTime activateDate in widget.activeDates!) {
              // Compare the date if it is in the
              if (_compareDate(date, activateDate)) {
                isDeactivated = false;
                break;
              }
            }
          }

          // Check if this date is the one that is currently selected
          bool isSelected = false;
          print("selected ${widget.selectedDate}");
          if (months.indexOf('${widget.selectedMonth}') + 1 ==
              widget.selectedDate.month) {
            isSelected = widget.selectedDate != null
                ? _compareDate(date, widget.selectedDate!)
                : false;
          }

          // Return the Date Widget
          return StickyDate(
            isSelected: isSelected,
            date: date,
            monthTextStyle: isDeactivated
                ? deactivatedMonthStyle
                : isSelected
                    ? selectedMonthStyle
                    : widget.monthTextStyle,
            dateTextStyle: isDeactivated
                ? deactivatedDateStyle
                : isSelected
                    ? selectedDateStyle
                    : widget.dateTextStyle,
            dayTextStyle: isDeactivated
                ? deactivatedDayStyle
                : isSelected
                    ? selectedDayStyle
                    : widget.dayTextStyle,
            width: widget.width,
            locale: widget.locale,
            selectionColor:
                isSelected ? widget.selectionColor : Colors.transparent,
            onDateSelected: (selectedDate) {
              // Don't notify listener if date is deactivated
              if (isDeactivated) return;

              // A date is selected
              if (widget.onDateChange != null) {
                widget.onDateChange!(selectedDate);
              }
              // setState(() {
              //   widget.selectedDate = selectedDate;
              // });
            },
          );
        },
      ),
    );
  }

  /// Helper function to compare two dates
  /// Returns True if both dates are the same
  bool _compareDate(DateTime date1, DateTime date2) {
    return date1.day == date2.day &&
        date1.month == date2.month &&
        date1.year == date2.year;
  }
}

class DatePickerController {
  _StickyDatePickerState? _datePickerState;

  void setDatePickerState(_StickyDatePickerState state) {
    _datePickerState = state;
  }

  void jumpToSelection() {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    // jump to the current Date
    _datePickerState!._controller
        .jumpTo(_calculateDateOffset(_datePickerState!.widget.selectedDate!));
  }

  /// This function will animate the Timeline to the currently selected Date
  void animateToSelection(
      {duration = const Duration(milliseconds: 500), curve = Curves.linear}) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    // animate to the current date
    _datePickerState!._controller.animateTo(
      _calculateDateOffset(_datePickerState!.widget.selectedDate!),
      duration: duration,
      curve: curve,
    );
  }

  /// This function will animate to any date that is passed as a parameter
  /// In case a date is out of range nothing will happen
  void animateToDate(DateTime date,
      {duration = const Duration(milliseconds: 500), curve = Curves.linear}) {
    assert(_datePickerState != null,
        'DatePickerController is not attached to any DatePicker View.');

    _datePickerState!._controller.animateTo(_calculateDateOffset(date),
        duration: duration, curve: curve);
  }

  /// Calculate the number of pixels that needs to be scrolled to go to the
  /// date provided in the argument
  double _calculateDateOffset(DateTime date) {
    final startDate = DateTime(
      _datePickerState!.widget.selectedDate.year,
      _datePickerState!.widget.selectedDate.month,
      _datePickerState!.widget.selectedDate.day,
    );

    int offset = date.difference(startDate).inDays;
    return (offset * _datePickerState!.widget.width) + (offset * 6);
  }
}
