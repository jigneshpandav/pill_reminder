import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:medicine_reminder/provider/home_provider.dart';
import 'package:medicine_reminder/screens/home/home_screen.dart';
import 'package:provider/provider.dart';

import '../../model/medicine.dart';
import '../../provider/medicine_provider.dart';
import '../../utils/text_utils.dart';
import '../../widgets/calendar.dart';
import '../../widgets/custom_drop_down_button.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/radio_option_widget.dart';
import '../../widgets/text_widget.dart';
import 'components/week_selection.dart';

class AddMedicine2 extends StatefulWidget {
  static const routeName = 'add-medicine2';

  const AddMedicine2({Key? key}) : super(key: key);

  @override
  State<AddMedicine2> createState() => _AddMedicine2State();
}

class _AddMedicine2State extends State<AddMedicine2> {
  TextEditingController firstDoseTimeController = TextEditingController();
  TextEditingController secDoseTimeController = TextEditingController();
  TextEditingController thirdDoseTimeController = TextEditingController();
  TextEditingController frequencyController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  final _key = GlobalKey<FormState>();
  List<String> takeMedicineTime = ["One Time", "Twice", "Thrice"];
  String takeMedicineValue = "One Time";
  List<String> frequencyList = ["Week", "Month", "Specific days of the week"];
  String frequencyValue = "Week";
  List doseTime = ["Before Meal", "After Meal"];
  bool isDone = true;
  bool _isInit = true;
  bool isTrue = false;
  List weekList = [];
  bool isEdited = false;
  bool isLoading = false;
  Map listId = {};
  List frequency = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturday",
    "Sunday"
  ];
  bool isSelected = false;
  String selectedFirstDose = "";
  String selectedSecDose = "";
  String selectedThirdDose = "";

  TextEditingController firstDose = TextEditingController();
  TextEditingController secDose = TextEditingController();
  TextEditingController thirdDose = TextEditingController();

  ValueChanged<String?> _valueChangedHandler() {
    return (value) {
      setState(() {
        selectedFirstDose = value!;
        setState(() {
          isDone = true;
        });
      });
    };
  }

  ValueChanged<String?> _valueChangedHandler1() {
    return (value) {
      setState(() {
        selectedSecDose = value!;
        setState(() {
          isDone = true;
        });
      });
    };
  }

  ValueChanged<String?> _valueChangedHandler3() {
    return (value) {
      setState(() {
        selectedThirdDose = value!;
        setState(() {
          isDone = true;
        });
      });
    };
  }

  _submitForm() {
    final provider = Provider.of<AddMedicineProvider>(context, listen: false);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    final data = ModalRoute.of(context)!.settings.arguments as List;
    String text = "Medicine Data added successfully.";
    if (takeMedicineValue == "One Time") {
      if (selectedFirstDose.isEmpty) {
        const snackBar = SnackBar(
          content: Text("Please select dose taken type"),
          backgroundColor: kPrimaryColor,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isDone = false;
      }
    } else if (takeMedicineValue == "Twice") {
      if (selectedFirstDose.isEmpty || selectedSecDose.isEmpty) {
        const snackBar = SnackBar(
          content: Text("Please select dose taken type"),
          backgroundColor: kPrimaryColor,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isDone = false;
      }
    } else if (takeMedicineValue == "Thrice") {
      if (selectedFirstDose.isEmpty ||
          selectedSecDose.isEmpty ||
          selectedThirdDose.isEmpty) {
        const snackBar = SnackBar(
          content: Text("Please select dose taken type"),
          backgroundColor: kPrimaryColor,
        );
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        isDone = false;
      }
    }
    if (isDone) {
      if (!_key.currentState!.validate()) {
        return;
      }
      _key.currentState!.save();
      setState(() {
        provider.isLoading = true;
      });
      try {
        if (data[5] == null) {
          provider
              .submitMedicineForm(
            AddMedicine(
              medicineName: data[0],
              diseaseName: data[1],
              medicineType: data[3],
              doseQuantity: data[2],
              description: data[4],
              endDate: endDateController.text,
            ),
          )
              .then((value) {
            provider
                .submitMedicineDetailsForm(AddMedicine(
              takeItInDay: takeMedicineValue,
              firstDose: firstDose.text,
              firstDoseType: selectedFirstDose,
              doseTime: firstDoseTimeController.text,
              secondDose: secDose.text,
              secondDoseType: selectedSecDose,
              secondDoseTime: secDoseTimeController.text,
              thirdDose: thirdDose.text,
              thirdDoseType: selectedThirdDose,
              thirdDoseTime: thirdDoseTimeController.text,
              frequency: frequencyValue,
              startDate: startDateController.text,
              endDate: endDateController.text,
            ))
                .then((value) {
              provider.isLoading = false;
            });
          });
        } else {
          provider
              .updateMedicineData(
            AddMedicine(
              medicineName: data[0],
              diseaseName: data[1],
              medicineType: data[3],
              doseQuantity: data[2],
              description: data[4],
              takeItInDay: takeMedicineValue,
              firstDose: firstDose.text,
              firstDoseType: selectedFirstDose,
              doseTime: firstDoseTimeController.text,
              secondDose: secDose.text,
              secondDoseType: selectedSecDose,
              secondDoseTime: secDoseTimeController.text,
              thirdDose: thirdDose.text,
              thirdDoseType: selectedThirdDose,
              thirdDoseTime: thirdDoseTimeController.text,
              frequency: frequencyValue,
              startDate: startDateController.text,
              endDate: endDateController.text,
            ),
            data[5].id,
            listId,
          )
              .then((value) {
            provider.isLoading = false;
            text = "Medicine Data updated successfully.";
          });
          setState(() {
            isEdited = true;
          });
        }
        if (takeMedicineValue == "One Time") {
          if (firstDose.text == "morning") {
            homeProvider.index = 0;
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else if (firstDose.text == "afternoon") {
            homeProvider.index = 1;
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else if (firstDose.text == "night") {
            homeProvider.index = 2;
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          }
        } else if (takeMedicineValue == "Twice") {
          if (firstDose.text == "morning") {
            homeProvider.index = 0;
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else if (firstDose.text == "afternoon") {
            homeProvider.index = 1;
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          } else if (firstDose.text == "night") {
            homeProvider.index = 2;
            Navigator.pushReplacementNamed(context, HomeScreen.routeName);
          }
        } else if (takeMedicineValue == "Thrice") {
          homeProvider.index = 0;
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        }
        Flushbar(
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 3),
          messageText: TextWidget(
            text: isEdited
                ? "Medicine Data updated successfully."
                : "Medicine Data added successfully.",
            fontSize: 15,
            fontWeight: gilroyMedium,
            color: kTextColor,
          ),
          flushbarPosition: FlushbarPosition.BOTTOM,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        ).show(context);
      } catch (err) {
        print(err);
        Flushbar(
          backgroundColor: Colors.white,
          duration: const Duration(seconds: 3),
          messageText: TextWidget(
            text: err.toString(),
            fontSize: 15,
            fontWeight: gilroyMedium,
            color: kTextColor,
          ),
          flushbarPosition: FlushbarPosition.BOTTOM,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8), topLeft: Radius.circular(8)),
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddMedicineProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          splashRadius: 20,
          icon: SvgPicture.asset(
            'assets/icons/Arrow - Left 2.svg',
            height: 25,
            width: 25,
          ),
        ),
        automaticallyImplyLeading: false,
        title: const TextWidget(
          text: 'New Medicine',
          fontSize: 17,
          fontWeight: gilroyBold,
          color: Colors.white,
        ),
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: const EdgeInsets.all(18.0),
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Form(
                      key: _key,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const TextWidget(
                                text: "How often do you take it in a day?",
                                fontSize: 10,
                                fontWeight: gilroyRegular,
                                color: kTextColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomDropDownButton(
                                  initValue: takeMedicineValue,
                                  onChanged: (value) {
                                    setState(() {
                                      takeMedicineValue = value;
                                    });
                                  },
                                  itemList: takeMedicineTime),
                              const SizedBox(
                                height: 18,
                              ),
                              const TextWidget(
                                text: "Set time for first dose",
                                fontSize: 10,
                                fontWeight: gilroyRegular,
                                color: kTextColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomTextFormField(
                                textController: firstDoseTimeController,
                                showSuffixIcon: true,
                                onTap: () {
                                  setState(() {
                                    selectTime(
                                        context: context,
                                        selectedTime: selectedTime,
                                        timeController: firstDoseTimeController,
                                        doseType: firstDose);
                                  });
                                },
                                suffixIcon: 'assets/icons/clock.svg',
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'Please Select Your Dose Time';
                                  }
                                  return null;
                                },
                              ),
                              Row(
                                children: List.generate(
                                    2,
                                    (index) => Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: SizedBox(
                                            height: 18,
                                            child: MyRadioOption<String>(
                                                value: doseTime[index],
                                                text: doseTime[index],
                                                selectedTextColor: kTextColor,
                                                deactivateTextColor:
                                                    kTextColor2,
                                                fontSize: 10,
                                                borderColor: kTextColor2,
                                                cardColor: kCardColor2,
                                                isAddForm: false,
                                                groupValue: selectedFirstDose,
                                                onChanged:
                                                    _valueChangedHandler()),
                                          ),
                                        )),
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              if (takeMedicineValue == "Twice" ||
                                  takeMedicineValue == 'Thrice')
                                const TextWidget(
                                  text: "Set time for second dose",
                                  fontSize: 10,
                                  fontWeight: gilroyRegular,
                                  color: kTextColor,
                                ),
                              if (takeMedicineValue == "Twice" ||
                                  takeMedicineValue == 'Thrice')
                                const SizedBox(
                                  height: 5,
                                ),
                              if (takeMedicineValue == "Twice" ||
                                  takeMedicineValue == 'Thrice')
                                CustomTextFormField(
                                  textController: secDoseTimeController,
                                  showSuffixIcon: true,
                                  suffixIcon: 'assets/icons/clock.svg',
                                  onTap: () {
                                    setState(() {
                                      selectTime(
                                          context: context,
                                          selectedTime: selectedTime,
                                          timeController: secDoseTimeController,
                                          doseType: secDose);
                                    });
                                  },
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Please Select Your Dose Time';
                                    }
                                    return null;
                                  },
                                ),
                              if (takeMedicineValue == "Twice" ||
                                  takeMedicineValue == 'Thrice')
                                Row(
                                  children: List.generate(
                                      2,
                                      (index) => Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              height: 18,
                                              child: MyRadioOption<String>(
                                                  value: doseTime[index],
                                                  text: doseTime[index],
                                                  selectedTextColor: kTextColor,
                                                  deactivateTextColor:
                                                      kTextColor2,
                                                  fontSize: 10,
                                                  borderColor: kTextColor2,
                                                  cardColor: kCardColor2,
                                                  isAddForm: false,
                                                  groupValue: selectedSecDose,
                                                  onChanged:
                                                      _valueChangedHandler1()),
                                            ),
                                          )),
                                ),
                              if (takeMedicineValue == "Twice" ||
                                  takeMedicineValue == 'Thrice')
                                const SizedBox(
                                  height: 18,
                                ),
                              if (takeMedicineValue == "Thrice")
                                const TextWidget(
                                  text: "Set time for third dose",
                                  fontSize: 10,
                                  fontWeight: gilroyRegular,
                                  color: kTextColor,
                                ),
                              if (takeMedicineValue == "Thrice")
                                const SizedBox(
                                  height: 5,
                                ),
                              if (takeMedicineValue == "Thrice")
                                CustomTextFormField(
                                  textController: thirdDoseTimeController,
                                  showSuffixIcon: true,
                                  suffixIcon: 'assets/icons/clock.svg',
                                  onTap: () {
                                    setState(() {
                                      selectTime(
                                          context: context,
                                          selectedTime: selectedTime,
                                          timeController:
                                              thirdDoseTimeController,
                                          doseType: thirdDose);
                                    });
                                  },
                                  validator: (value) {
                                    if (value.toString().isEmpty) {
                                      return 'Please Select Your Dose Time';
                                    }
                                    return null;
                                  },
                                ),
                              if (takeMedicineValue == "Thrice")
                                Row(
                                  children: List.generate(
                                      2,
                                      (index) => Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: SizedBox(
                                              height: 18,
                                              child: MyRadioOption<String>(
                                                  value: doseTime[index],
                                                  text: doseTime[index],
                                                  selectedTextColor: kTextColor,
                                                  deactivateTextColor:
                                                      kTextColor2,
                                                  fontSize: 10,
                                                  borderColor: kTextColor2,
                                                  cardColor: kCardColor2,
                                                  isAddForm: false,
                                                  groupValue: selectedThirdDose,
                                                  onChanged:
                                                      _valueChangedHandler3()),
                                            ),
                                          )),
                                ),
                              if (takeMedicineValue == "Thrice")
                                const SizedBox(
                                  height: 18,
                                ),
                              const TextWidget(
                                text: "Frequency",
                                fontSize: 10,
                                fontWeight: gilroyRegular,
                                color: kTextColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              CustomDropDownButton(
                                  initValue: frequencyValue,
                                  onChanged: (value) {
                                    setState(() {
                                      frequencyValue = value;
                                    });
                                  },
                                  itemList: frequencyList),
                              if (frequencyValue == "Specific days of the week")
                                SizedBox(
                                  height: 40,
                                  child: ListView.builder(
                                      itemCount: 7,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder: (context, index) {
                                        if (provider.weekList.isEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 10.0,
                                                bottom: 10.0),
                                            child: SizedBox(
                                                height: 18,
                                                child: WeekSelection(
                                                  title: frequency[index],
                                                )
                                                // MyRadioOption<String>(
                                                //     value: frequency[index],
                                                //     text: frequency[index],
                                                //     selectedTextColor: kTextColor,
                                                //     deactivateTextColor: kTextColor2,
                                                //     fontSize: 10,
                                                //     borderColor: kTextColor2,
                                                //     cardColor: kCardColor2,
                                                //     isAddForm: false,
                                                //     groupValue: selectedFrequency,
                                                //     onChanged: _valueChangedHandler2()),
                                                ),
                                          );
                                        } else if (provider
                                            .weekList.isNotEmpty) {
                                          return Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0,
                                                top: 10.0,
                                                bottom: 10.0),
                                            child: SizedBox(
                                                height: 18,
                                                child: WeekSelection(
                                                  title: frequency[index],
                                                  data: provider.weekList,
                                                )
                                                // MyRadioOption<String>(
                                                //     value: frequency[index],
                                                //     text: frequency[index],
                                                //     selectedTextColor: kTextColor,
                                                //     deactivateTextColor: kTextColor2,
                                                //     fontSize: 10,
                                                //     borderColor: kTextColor2,
                                                //     cardColor: kCardColor2,
                                                //     isAddForm: false,
                                                //     groupValue: selectedFrequency,
                                                //     onChanged: _valueChangedHandler2()),
                                                ),
                                          );
                                        }

                                        return const SizedBox();
                                      }),
                                ),
                              const SizedBox(
                                height: 18,
                              ),
                              const TextWidget(
                                text: "Start Date",
                                fontSize: 10,
                                fontWeight: gilroyRegular,
                                color: kTextColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Calendar(
                                dateController: startDateController,
                                showIcon: true,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'Please Select Start Date';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                              const TextWidget(
                                text: "End Date",
                                fontSize: 10,
                                fontWeight: gilroyRegular,
                                color: kTextColor,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Calendar(
                                dateController: endDateController,
                                showIcon: true,
                                validator: (value) {
                                  if (value.toString().isEmpty) {
                                    return 'Please Select End Date';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(
                                height: 18,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 52,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _submitForm,
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all(kCardColor),
                              ),
                              child: const TextWidget(
                                text: 'SAVE',
                                fontSize: 18,
                                fontWeight: gilroySemiBold,
                                color: kTextColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> selectTime(
      {required BuildContext context,
      required TimeOfDay selectedTime,
      required TextEditingController timeController,
      required TextEditingController doseType}) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
      context: context,
      initialTime: selectedTime,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
          child: child ?? Container(),
        );
      },
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
        DateTime temp = DateFormat.Hm()
            .parse("${selectedTime.hour}:${selectedTime.minute}");
        timeController.text =
            TimeOfDay(hour: selectedTime.hour, minute: selectedTime.minute)
                .format(context);
        if (temp.hour < 12) {
          doseType.text = 'morning';
        } else if (temp.hour < 17 && temp.hour >= 12) {
          doseType.text = 'afternoon';
        } else if (temp.hour >= 17 && temp.hour < 24) {
          doseType.text = 'night';
        }
      });
    }
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies

    if (_isInit) {
      final medDetail = ModalRoute.of(context)!.settings.arguments as List;
      final provider = Provider.of<AddMedicineProvider>(context, listen: false);
      if (medDetail[5] != null) {
        var data = medDetail[5];
        List<AddMedicine> details = [];
        details.clear();
        AddMedicine? all;
        List<AddMedicine> morning = [];
        List<AddMedicine> afternoon = [];
        List<AddMedicine> night = [];
        // AddMedicine? afternoon;
        // AddMedicine? night;
        int i = 0;
        morning.clear();
        afternoon.clear();
        night.clear();

        listId.clear();
        provider.medicineDetails.forEach((element) {
          if (element.id == data.id) {
            all = element;
          }
          if (element.id == data.id && element.dose == "morning") {
            morning.add(element);
            listId[i] = [element.medId, element.whichDose];
            i++;
          } else if (element.id == data.id && element.dose == "afternoon") {
            // details.add(element);
            afternoon.add(element);
            listId[i] = [element.medId, element.whichDose];
            i++;
          } else if (element.id == data.id && element.dose == "night") {
            // details.add(element);
            night.add(element);
            listId[i] = [element.medId, element.whichDose];
            i++;
          }
        });
        takeMedicineValue = all!.takeItInDay.toString();
        frequencyValue = all!.frequency.toString();
        startDateController.text = all!.startDate.toString();
        endDateController.text = all!.endDate.toString();

        if (morning.length == 1) {
          firstDoseTimeController.text = morning[0].doseTime.toString();
          firstDose.text = morning[0].dose.toString();
          selectedFirstDose = morning[0].doseType.toString();
        } else if (morning.length == 2) {
          firstDoseTimeController.text = morning[0].doseTime.toString();
          firstDose.text = morning[0].dose.toString();
          selectedFirstDose = morning[0].doseType.toString();
          secDose.text = morning[1].dose.toString();
          secDoseTimeController.text = morning[1].doseTime.toString();
          selectedSecDose = morning[1].doseType.toString();
        } else if (morning.length == 3) {
          firstDoseTimeController.text = morning[0].doseTime.toString();
          firstDose.text = morning[0].dose.toString();
          selectedFirstDose = morning[0].doseType.toString();
          secDose.text = morning[1].dose.toString();
          secDoseTimeController.text = morning[1].doseTime.toString();
          selectedSecDose = morning[1].doseType.toString();
          thirdDoseTimeController.text = morning[2].doseTime.toString();
          selectedThirdDose = morning[2].doseType.toString();
          thirdDose.text = morning[2].dose.toString();
        }

        if (morning.length == 1 && afternoon.length == 1) {
          firstDoseTimeController.text = morning[0].doseTime.toString();
          firstDose.text = morning[0].dose.toString();
          selectedFirstDose = morning[0].doseType.toString();
          secDose.text = afternoon[0].dose.toString();
          secDoseTimeController.text = afternoon[0].doseTime.toString();
          selectedSecDose = afternoon[0].doseType.toString();
        } else if (afternoon.length == 1) {
          firstDoseTimeController.text = afternoon[0].doseTime.toString();
          firstDose.text = afternoon[0].dose.toString();
          selectedFirstDose = afternoon[0].doseType.toString();
        } else if (afternoon.length == 2) {
          firstDoseTimeController.text = afternoon[0].doseTime.toString();
          firstDose.text = afternoon[0].dose.toString();
          selectedFirstDose = afternoon[0].doseType.toString();
          secDose.text = afternoon[1].dose.toString();
          secDoseTimeController.text = afternoon[1].doseTime.toString();
          selectedSecDose = afternoon[1].doseType.toString();
        } else if (afternoon.length == 3) {
          firstDoseTimeController.text = afternoon[0].doseTime.toString();
          firstDose.text = afternoon[0].dose.toString();
          selectedFirstDose = afternoon[0].doseType.toString();
          secDose.text = afternoon[1].dose.toString();
          secDoseTimeController.text = afternoon[1].doseTime.toString();
          selectedSecDose = afternoon[1].doseType.toString();
          thirdDoseTimeController.text = afternoon[2].doseTime.toString();
          selectedThirdDose = afternoon[2].doseType.toString();
          thirdDose.text = afternoon[2].dose.toString();
        }

        if (morning.length == 1 && afternoon.length == 1 && night.length == 1) {
          firstDoseTimeController.text = morning[0].doseTime.toString();
          firstDose.text = morning[0].dose.toString();
          selectedFirstDose = morning[0].doseType.toString();
          secDose.text = afternoon[0].dose.toString();
          secDoseTimeController.text = afternoon[0].doseTime.toString();
          selectedSecDose = afternoon[0].doseType.toString();
          thirdDoseTimeController.text = night[0].doseTime.toString();
          selectedThirdDose = night[0].doseType.toString();
          thirdDose.text = night[0].dose.toString();
        } else if (night.length == 1) {
          firstDoseTimeController.text = night[0].doseTime.toString();
          firstDose.text = night[0].dose.toString();
          selectedFirstDose = night[0].doseType.toString();
        } else if (night.length == 2) {
          firstDoseTimeController.text = night[0].doseTime.toString();
          firstDose.text = night[0].dose.toString();
          selectedFirstDose = night[0].doseType.toString();
          secDose.text = night[1].dose.toString();
          secDoseTimeController.text = night[1].doseTime.toString();
          selectedSecDose = night[1].doseType.toString();
        } else if (night.length == 3) {
          firstDoseTimeController.text = night[0].doseTime.toString();
          firstDose.text = night[0].dose.toString();
          selectedFirstDose = night[0].doseType.toString();
          secDose.text = night[1].dose.toString();
          secDoseTimeController.text = night[1].doseTime.toString();
          selectedSecDose = night[1].doseType.toString();
          thirdDoseTimeController.text = night[2].doseTime.toString();
          selectedThirdDose = night[2].doseType.toString();
          thirdDose.text = night[2].dose.toString();
        }

        // takeMedicineValue = details[0].takeItInDay.toString();
        // frequencyValue = details[0].frequency.toString();
        // startDateController.text = details[0].startDate.toString();
        // endDateController.text = details[0].endDate.toString();
        // if (details.length == 1) {
        //   firstDoseTimeController.text = details[0].doseTime.toString();
        //   firstDose.text = details[0].dose.toString();
        //   selectedFirstDose = details[0].doseType.toString();
        // } else if (details.length == 2) {
        //   firstDoseTimeController.text = details[0].doseTime.toString();
        //   selectedFirstDose = details[0].doseType.toString();
        //   firstDose.text = details[0].dose.toString();
        //   secDose.text = details[1].dose.toString();
        //   secDoseTimeController.text = details[1].doseTime.toString();
        //   selectedSecDose = details[1].doseType.toString();
        // } else if (details.length == 3) {
        //   firstDoseTimeController.text = details[0].doseTime.toString();
        //   selectedFirstDose = details[0].doseType.toString();
        //   secDoseTimeController.text = details[1].doseTime.toString();
        //   selectedSecDose = details[1].doseType.toString();
        //   thirdDoseTimeController.text = details[2].doseTime.toString();
        //   selectedThirdDose = details[2].doseType.toString();
        //   firstDose.text = details[0].dose.toString();
        //   secDose.text = details[1].dose.toString();
        //   thirdDose.text = details[2].dose.toString();
        // }

        if (frequencyValue == "Specific days of the week") {
          provider.weekList.clear();
          all!.specificWeekDay!.forEach((element) {
            // var d=frequency.indexWhere((element1) => element1 == element);
            provider.weekList.add(element);
          });
        }
        //   takeMedicineValue = data.takeItInDay.toString();
        //   if (takeMedicineValue == "One Time") {
        //     firstDoseTimeController.text = data.doseTime.toString();
        //     selectedFirstDose = data.doseType.toString();
        //   } else if (takeMedicineValue == "Twice") {
        //     firstDoseTimeController.text = data.doseTime.toString();
        //     selectedFirstDose = data.doseType.toString();
        //     secDoseTimeController.text = data.doseTime.toString();
        //     selectedSecDose = data.doseType.toString();
        //   }
        //   frequencyValue = data.frequency.toString();
        //   startDateController.text = data.startDate.toString();
        //   endDateController.text = data.endDate.toString();
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    didChangeDependencies();
  }
}
