// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:medicine_reminder/screens/home/components/medicine_card.dart';
// import 'package:medicine_reminder/screens/home/components/schedule_card.dart';
// import 'package:medicine_reminder/utils/size_config.dart';
// import 'package:provider/provider.dart';
//
// import '../../../provider/medicine_provider.dart';
// import '../../../utils/text_utils.dart';
// import '../../../widgets/text_widget.dart';
//
// class HomeBody extends StatefulWidget {
//   const HomeBody({Key? key, this.date}) : super(key: key);
//   final DateTime? date;
//
//   @override
//   State<HomeBody> createState() => _HomeBodyState();
// }
//
// class _HomeBodyState extends State<HomeBody> with TickerProviderStateMixin {
//   late TabController tabController;
//   int index = 0;
//
//   @override
//   void initState() {
//     tabController = TabController(length: 3, vsync: this);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final getMedicineData = Provider.of<AddMedicineProvider>(context);
//     return Column(
//       children: [
//         Stack(
//           alignment: Alignment.center,
//           children: [
//             SvgPicture.asset(
//               'assets/shape_rect.svg',
//               height: 42,
//             ),
//             SizedBox(
//               width: 280,
//               height: 40,
//               child: TabBar(
//                 controller: tabController,
//                 onTap: (value) {
//                   setState(() {
//                     index = value;
//                   });
//                 },
//                 labelStyle: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: gilroyBold,
//                 ),
//                 unselectedLabelStyle: const TextStyle(
//                   fontSize: 12,
//                   fontWeight: gilroyRegular,
//                 ),
//                 unselectedLabelColor: Colors.white,
//                 labelColor: kPrimaryColor,
//                 indicatorColor: kPrimaryColor,
//                 indicatorPadding: const EdgeInsets.only(left: 30, right: 30),
//                 tabs: const [
//                   Tab(
//                     text: "Morning",
//                   ),
//                   Tab(
//                     text: "Afternoon",
//                   ),
//                   Tab(
//                     text: "Night",
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//         getMedicineData.isLoading
//             ? SizedBox(
//                 height: getProportionateScreenHeight(350),
//                 child: const Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               )
//             : index == 0
//                 ? MedicineCard(
//                     dose: "morning",
//                     date: widget.date,
//                   )
//                 : index == 1
//                     ? MedicineCard(
//                         dose: "afternoon",
//                         date: widget.date,
//                       )
//                     : getMedicineData.data.isNotEmpty
//                         ? Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               const Padding(
//                                 padding: EdgeInsets.only(left: 18.0, top: 21),
//                                 child: TextWidget(
//                                   text: 'Today’s Schedule',
//                                   fontSize: 18,
//                                   fontWeight: gilroyBold,
//                                   color: kTextColor,
//                                 ),
//                               ),
//                               ...List.generate(
//                                 getMedicineData.data.length,
//                                 (index) {
//                                   // if (getMedicineData.data[index].firstDose
//                                   //         .toString()
//                                   //         .isNotEmpty &&
//                                   //     DateFormat("hh:mm")
//                                   //             .parse(getMedicineData
//                                   //                 .data[index].firstDose
//                                   //                 .toString())
//                                   //             .hour >=
//                                   //         7 &&
//                                   //     getMedicineData.data[index].firstDose
//                                   //         .toString()
//                                   //         .contains("PM")) {
//                                   //   return ScheduleCard(
//                                   //     medicineName: getMedicineData
//                                   //         .data[index].medicineName
//                                   //         .toString(),
//                                   //     description:
//                                   //         'Lorem Ipsum is simply dummy text of the printing and\ntypesetting industry.',
//                                   //     image: 'assets/icons/Medicine.svg',
//                                   //     time: getMedicineData.data[index].firstDose
//                                   //         .toString(),
//                                   //     timeType: getMedicineData
//                                   //         .data[index].firstDoseType
//                                   //         .toString(),
//                                   //     id: getMedicineData.data[index].id.toString(),
//                                   //     isCompleted: getMedicineData
//                                   //         .data[index].isCompleted as bool,
//                                   //     addMedicine: getMedicineData.data[index],
//                                   //   );
//                                   // } else if (getMedicineData.data[index].secondDose
//                                   //         .toString()
//                                   //         .isNotEmpty &&
//                                   //     DateFormat("hh:mm")
//                                   //             .parse(getMedicineData
//                                   //                 .data[index].secondDose
//                                   //                 .toString())
//                                   //             .hour >=
//                                   //         7 &&
//                                   //     getMedicineData.data[index].secondDose
//                                   //         .toString()
//                                   //         .contains("PM")) {
//                                   //   return ScheduleCard(
//                                   //     medicineName: getMedicineData
//                                   //         .data[index].medicineName
//                                   //         .toString(),
//                                   //     description:
//                                   //         'Lorem Ipsum is simply dummy text of the printing and\ntypesetting industry.',
//                                   //     image: 'assets/icons/Medicine.svg',
//                                   //     time: getMedicineData.data[index].secondDose
//                                   //         .toString(),
//                                   //     timeType: getMedicineData
//                                   //         .data[index].secondDoseType
//                                   //         .toString(),
//                                   //     id: getMedicineData.data[index].id.toString(),
//                                   //     isCompleted: getMedicineData
//                                   //         .data[index].isCompleted as bool,
//                                   //     addMedicine: getMedicineData.data[index],
//                                   //   );
//                                   // } else if (getMedicineData.data[index].thirdDose
//                                   //     .toString()
//                                   //     .isNotEmpty) {
//                                   //   print("yes3");
//                                   //   if (DateFormat("hh:mm")
//                                   //               .parse(getMedicineData
//                                   //                   .data[index].thirdDose
//                                   //                   .toString())
//                                   //               .hour >=
//                                   //           7 &&
//                                   //       getMedicineData.data[index].thirdDose
//                                   //           .toString()
//                                   //           .contains("PM")) {
//                                   //     return ScheduleCard(
//                                   //       medicineName: getMedicineData
//                                   //           .data[index].medicineName
//                                   //           .toString(),
//                                   //       description:
//                                   //           'Lorem Ipsum is simply dummy text of the printing and\ntypesetting industry.',
//                                   //       image: 'assets/icons/Medicine.svg',
//                                   //       time: getMedicineData.data[index].thirdDose
//                                   //           .toString(),
//                                   //       timeType: getMedicineData
//                                   //           .data[index].thirdDoseType
//                                   //           .toString(),
//                                   //       id: getMedicineData.data[index].id
//                                   //           .toString(),
//                                   //       isCompleted: getMedicineData
//                                   //           .data[index].isCompleted as bool,
//                                   //       addMedicine: getMedicineData.data[index],
//                                   //     );
//                                   //   }
//                                   // }
//                                   // return const SizedBox();
//                                   var result;
//                                   for (var element in getMedicineData.medicineDetails) {
//                                     if (getMedicineData.data[index].id ==
//                                             element.id &&
//                                         element.dose == "night") {
//                                       result = ScheduleCard(
//                                         date: widget.date!,
//                                         medTime: [],
//                                         index: index,
//                                         dose: element.dose!,
//                                         timeType: element.doseType.toString(),
//                                         image: 'assets/icons/Medicine.svg',
//                                         time: element.thirdDoseTime.toString(),
//                                         id: getMedicineData.data[index].id
//                                             .toString(),
//                                         isCompleted: false,
//                                         addMedicine:
//                                             getMedicineData.data[index],
//                                         details: element,
//                                       );
//                                     }
//                                   }
//                                   if (result != null) {
//                                     return result;
//                                   }
//                                   return const SizedBox();
//                                 },
//                               ),
//                             ],
//                           )
//                         : const Center(
//                             child: TextWidget(text: "No Data Available"),
//                           ),
//       ],
//     );
//   }
//
//   Column buildColumn(AddMedicineProvider getMedicineData) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Padding(
//           padding: EdgeInsets.only(left: 18.0, top: 21),
//           child: TextWidget(
//             text: 'Today’s Schedule',
//             fontSize: 18,
//             fontWeight: gilroyBold,
//             color: kTextColor,
//           ),
//         ),
//         ...List.generate(
//           getMedicineData.data.length,
//           (index) {
//             var result;
//             for (var element in getMedicineData.medicineDetails) {
//               if (getMedicineData.data[index].id == element.id &&
//                   element.dose == "morning") {
//                 result = ScheduleCard(
//                   image: 'assets/icons/Medicine.svg',
//                   date: widget.date!,
//                   medTime: [],
//                   dose: element.dose!,
//                   index: index,
//                   time: element.doseTime.toString(),
//                   timeType: element.doseType.toString(),
//                   id: getMedicineData.data[index].id.toString(),
//                   isCompleted: element.isCompleted!,
//                   addMedicine: getMedicineData.data[index],
//                   details: element,
//                 );
//               }
//             }
//             if (result != null) {
//               return result;
//             }
//             return const SizedBox();
//           },
//         ),
//       ],
//     );
//   }
// }
