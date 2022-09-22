import 'package:flutter/material.dart';
import 'package:medicine_reminder/provider/medicine_provider.dart';
import 'package:medicine_reminder/provider/home_provider.dart';
import 'package:medicine_reminder/screens/home/home_screen.dart';
import 'package:medicine_reminder/utils/size_config.dart';
import 'package:medicine_reminder/widgets/text_widget.dart';
import 'package:provider/provider.dart';

import 'components/history_list.dart';

class HistoryScreen extends StatefulWidget {
  static const routeName = '/history';

  const HistoryScreen({Key? key, required this.date}) : super(key: key);
  final DateTime date;

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AddMedicineProvider>(context);
    return WillPopScope(
      onWillPop: () async {
        setState(() {
          Provider.of<HomeProvider>(context, listen: false).bottomIndex = 0;
          Navigator.pushReplacementNamed(context, HomeScreen.routeName);
        });
        return false;
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 21.0),
        child: provider.isLoading
            ? SizedBox(
                height: SizeConfig.screenHeight! * 0.5,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : provider.doseType.isEmpty
                ? SizedBox(
                    height: SizeConfig.screenHeight! * 0.5,
                    child: const Center(
                      child: TextWidget(
                        text: "No Data Found",
                      ),
                    ),
                  )
                : Column(
                    children: [
                      ...List.generate(
                          provider.doseType.length,
                          (index) => HistoryList(
                                title: provider.doseType[index],
                                date: widget.date,
                              )),
                    ],
                  ),
      ),
    );
  }
}
