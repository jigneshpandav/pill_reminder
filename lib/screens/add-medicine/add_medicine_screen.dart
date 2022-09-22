import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:medicine_reminder/screens/home/home_screen.dart';
import 'package:medicine_reminder/widgets/custom_drop_down_button.dart';
import 'package:provider/provider.dart';

import '../../provider/medicine_provider.dart';
import '../../utils/text_utils.dart';
import '../../widgets/custom_drop_down/custom_dropdown.dart';
import '../../widgets/custom_text_form_field.dart';
import '../../widgets/qr_scanner.dart';
import '../../widgets/text_widget.dart';
import 'add_medicine2_screen.dart';

class AddMedicineScreen extends StatefulWidget {
  static const routeName = 'add-medicine';

  const AddMedicineScreen({Key? key}) : super(key: key);

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  TextEditingController medicineNameController = TextEditingController();
  TextEditingController medicineTypeController = TextEditingController();
  TextEditingController takeItController = TextEditingController();
  TextEditingController doseController = TextEditingController();
  TextEditingController discController = TextEditingController();
  final _key = GlobalKey<FormState>();
  bool _isInit = true;
  List medicineName = ["Capsule", "Tablet", "Injection", "Syrup", "Spray"];
  List medicineImage = [
    "assets/icons/Medicine.svg",
    "assets/icons/Medicine2.svg",
    "assets/icons/Syringe.svg",
    "assets/icons/Medicine-1.svg",
    "assets/icons/Sanitizer.svg"
  ];
  String m = "";
  List<String> doseQuantityType = ["number", "ml", "grm"];
  String doseQunType = "number";

  _submitForm() {
    if (!_key.currentState!.validate()) {
      return;
    }
    _key.currentState!.save();
    if (medicineTypeController.text.isNotEmpty) {
      var data = "${doseController.text.trim()} $doseQunType";
      final medDetail = ModalRoute.of(context)!.settings.arguments;
      var detail;
      if (medDetail != null) {
        medDetail as List;
        detail = medDetail[0];
      }
      Navigator.pushReplacementNamed(context, AddMedicine2.routeName,
          arguments: [
            medicineNameController.text.trim(),
            takeItController.text.trim(),
            data,
            medicineTypeController.text,
            discController.text.trim(),
            detail,
          ]);
    } else {
      const snackBar = SnackBar(
        content: Text("Please select medicine type"),
        backgroundColor: kPrimaryColor,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddMedicineProvider>(context);
    if (provider.barcode != null) {
      medicineNameController.text = provider.barcode.toString();
    }
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            final data = ModalRoute.of(context)!.settings.arguments;
            if (data != null) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, HomeScreen.routeName);
            }
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
      body: Container(
        padding: const EdgeInsets.all(18.0),
        child: Form(
          key: _key,
          child: CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const TextWidget(
                          text: "Medicine Name",
                          fontSize: 10,
                          fontWeight: gilroyRegular,
                          color: kTextColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          textController: medicineNameController,
                          showSuffixIcon: true,
                          suffixIcon: 'assets/icons/scan.svg',
                          suffixOnTap: () {
                            setState(() {
                              Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const QRViewExample(),
                              ));
                            });
                          },
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Please Enter Medicine name';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const TextWidget(
                          text: "What are you talking it for?",
                          fontSize: 10,
                          fontWeight: gilroyRegular,
                          color: kTextColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          textController: takeItController,
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Please Enter disease';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const TextWidget(
                          text: "Choose form of your medicine",
                          fontSize: 10,
                          fontWeight: gilroyRegular,
                          color: kTextColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomDropdown.search(
                          items: provider.medName,
                          selectedStyle: const TextStyle(
                              color: kTextColor, fontWeight: gilroySemiBold),
                          controller: medicineTypeController,
                          errorBorderSide:
                              const BorderSide(width: 1, color: Colors.red),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const TextWidget(
                          text: "Dose Quantity",
                          fontSize: 10,
                          fontWeight: gilroyRegular,
                          color: kTextColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: doseController,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                              color: kTextColor, fontWeight: gilroySemiBold),
                          validator: (value) {
                            if (value.toString().isEmpty) {
                              return 'Please Enter Dose Quantity';
                            } else if (double.parse(value.toString())
                                .isNegative) {
                              return 'Please Enter valid Dose Quantity';
                            } else if (value.toString().length >= 10) {
                              return 'Please Enter valid Dose Quantity';
                            }
                            return null;
                          },
                          decoration: InputDecoration(
                            suffixIcon: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 5.0),
                                child: SizedBox(
                                  height: 25,
                                  width: 100,
                                  child: CustomDropDownButton(
                                    initValue: doseQunType,
                                    contentPadding: 10,
                                    onChanged: (value) {
                                      setState(() {
                                        doseQunType = value;
                                      });
                                    },
                                    itemList: doseQuantityType,
                                  ),
                                ),
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide:
                                  const BorderSide(color: kPrimaryColor),
                              gapPadding: 10,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        const TextWidget(
                          text: "Description",
                          fontSize: 10,
                          fontWeight: gilroyRegular,
                          color: kTextColor,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        CustomTextFormField(
                          textController: discController,
                          maxLine: 3,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 18,
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
                          text: 'NEXT',
                          fontSize: 18,
                          fontWeight: gilroySemiBold,
                          color: kTextColor,
                        ),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if (_isInit) {
      final data = ModalRoute.of(context)!.settings.arguments;
      if (data != null) {
        data as List;
        var medDetail = data[0] as AddMedicine;
        var dosQty = medDetail.doseQuantity.toString().split(' ');
        medicineNameController.text = medDetail.medicineName.toString();
        takeItController.text = medDetail.diseaseName.toString();
        medicineTypeController.text = medDetail.medicineType.toString();
        doseController.text = dosQty[0];
        doseQunType = dosQty[1];
        discController.text = medDetail.description.toString();
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
