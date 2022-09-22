import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';
import 'dart:ui';

import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:is_lock_screen/is_lock_screen.dart';
import 'package:medicine_reminder/model/medicine.dart';
import 'package:medicine_reminder/provider/flutter_storage.dart';
import 'package:medicine_reminder/provider/home_provider.dart';
import 'package:provider/provider.dart';

import '../../provider/medicine_provider.dart';
import '../../utils/size_config.dart';
import '../../utils/text_utils.dart';
import '../../widgets/custom_drop_down_button.dart';
import '../../widgets/custom_switch_adaptive.dart';
import '../../widgets/date_picker/date_picker_widget.dart';
import '../../widgets/local_notifications.dart' as notify;
import '../../widgets/radio_option_widget.dart';
import '../../widgets/text_widget.dart';
import '../add-medicine/add_medicine_screen.dart';
import '../history/history_screen.dart';
import 'components/medicine_card.dart';

const String isolateName = 'isolate';

final ReceivePort port = ReceivePort();
final service = FlutterBackgroundService();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: false,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  debugPrint('FLUTTER BACKGROUND FETCH');
  return true;
}

void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  String p;
  DateTime n;
  String q;
  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });
    service.on('setAsBackground').listen((event) {
      service.setAsBackgroundService();
    });
  }

  service.on('stopService').listen((event) {
    service.stopSelf();
  });
  final storage = FlutterSecureStorage();

  if (await storage.read(key: "time") != null) {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      final data = await storage.read(key: "time");
      List time = jsonDecode(data!);
      print(time);
      for (var element in time) {
        p = DateFormat('yyyy-MM-dd').format(DateTime.now());
        n = DateFormat("hh:mm a").parse(element);
        q = DateFormat.Hms().format(n);
        DateTime now = DateTime.parse("$p $q");
        TimeOfDay current =
            TimeOfDay(hour: DateTime.now().hour, minute: DateTime.now().minute);
        TimeOfDay medTime = TimeOfDay(hour: now.hour, minute: now.minute);
        var rand = Random();
        var hash = rand.nextInt(100);
        var d = DateTime.now().difference(now);
        if ((d.inMinutes == -30 && (d.inSeconds % 60) == 0) ||
            (DateTime.now().hour == now.hour &&
                DateTime.now().minute == now.minute &&
                DateTime.now().second == 0)) {
          await notify.singleNotification(
            DateTime.now(),
            "Medicine Time",
            "Please take your medicine on time.",
            hash,
            now,
          );
        }
      }
    });
  }
}

class HomeScreen extends StatefulWidget {
  static const routeName = 'home-screen';

  const HomeScreen({Key? key, this.data, this.payload}) : super(key: key);
  final String? data;
  final String? payload;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  DateTime _selectedValue =
      DateTime(DateTime.now().year, DateTime.now().month, 1);
  DateTime selectedValue = DateTime.now();
  String month = DateFormat.MMMM().format(DateTime.now());
  DatePickerController controller = DatePickerController();
  DateTime now = DateTime.now();
  bool isEnable = false;
  int initialMonth = DateTime.now().month - 1;
  AddMedicineProvider addMedicineProvider = AddMedicineProvider();
  List<String> year = ["2022", "2021", "2020"];
  String initialYear = DateTime.now().year.toString();
  List monthList = [
    "January",
    "February",
    "March",
    "April",
    "May",
    "Jun",
    "July",
    "August",
    "September",
    "October",
    "November",
    "December",
  ];
  FlutterStorage flutterStorage = FlutterStorage();

  ValueChanged<String?> _valueChangedHandler() {
    return (value) {
      setState(() {
        month = value!;
        var index = monthList.indexWhere((element) {
          return element == month;
        });
        setState(() {
          initialMonth = index + 1;
        });
        DateTime lastDayOfMonth =
            DateTime(int.parse(initialYear), index + 1, 1);
        now = lastDayOfMonth;
        _selectedValue = now;
        selectedValue = now;
      });
    };
  }

  late TabController tabController;
  late TabController tabController1;

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    tabController1 = TabController(length: 3, vsync: this);
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    getData();
    isShow();
    WidgetsBinding.instance.addObserver(this);
    notify.initNotifications(context: context);
    if (widget.payload != null) {
      homeProvider.showNotification1(widget.payload.toString());
    }
    tabController1.index = homeProvider.index;
    super.initState();
  }

  getData() async {
    final provider = Provider.of<AddMedicineProvider>(context, listen: false);
    var medicineType = await Hive.box("medicine_reminder").get("medicine_type");
    var medicineTypeName =
        await Hive.box("medicine_reminder").get("medicine_type_name");
    var medicine = await Hive.box("medicine_reminder")
        .get("medicine", defaultValue: <AddMedicine>[]).cast<AddMedicine>();
    var medicineDetails = await Hive.box("medicine_reminder").get(
        "medicine_details",
        defaultValue: <AddMedicine>[]).cast<AddMedicine>();
    var allMedicineDetails = await Hive.box("medicine_reminder").get(
        "all_medicine_details",
        defaultValue: <AddMedicine>[]).cast<AddMedicine>();
    var medicineSchedule = await Hive.box("medicine_reminder").get(
        "medicine_schedule",
        defaultValue: <AddMedicine>[]).cast<AddMedicine>();
    try {
      provider.getUserId().then((value) {
        if (medicineType == null ||
            medicine == null ||
            medicineSchedule == null ||
            medicineDetails == null ||
            medicineTypeName == null ||
            allMedicineDetails == null) {
          provider.getMedicineTypeData();
          provider
              .getData(
                  date: DateTime(DateTime.now().year, DateTime.now().month,
                      DateTime.now().day))
              .then((value) async {
            if (await flutterStorage.storage.read(key: "isShow") != null) {
              service.invoke("stopService");
            }
            final d = jsonEncode(provider.doseTime);
            await flutterStorage.addNewItem(key: "time", value: d);
          });
        } else {
          setState(() {
            provider.data = medicine;
            provider.allMedicineDetails = allMedicineDetails;
            provider.medicineDetails = medicineDetails;
            provider.medicineSchedule = medicineSchedule;
            provider.medicineType = medicineType;
            provider.medName = medicineTypeName;
            provider.medicineName = provider.medicineType[0]['name'];
          });
        }
      });
    } catch (err) {
      // ignore: use_build_context_synchronously
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
    setState(() {
      provider.isLoading = false;
      provider.isCheckLoading = false;
    });
  }

  isShow() async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    if (await flutterStorage.storage.read(key: "isShow") != null) {
      var isShow = await flutterStorage.storage.read(key: "isShow");
      var p = jsonDecode(isShow!);
      homeProvider.isEnable = p;
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future _refreshData() async {
    final provider = Provider.of<AddMedicineProvider>(context, listen: false);
    setState(() {
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    });
    provider.sortData(DateTime(
        DateTime.now().year, DateTime.now().month, DateTime.now().day));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    super.didChangeAppLifecycleState(state);
    if (homeProvider.isEnable) {
      if (state == AppLifecycleState.inactive) {
        service.startService();
        print('app inactive, is lock screen: ${await isLockScreen()}');
      } else if (state == AppLifecycleState.resumed) {
        print('app resumed');
        setState(() {
          service.invoke("stopService");
        });
      } else if (state == AppLifecycleState.detached) {
        setState(() {
          service.startService();
        });
        print('app terminated');
      }
    } else {
      setState(() {
        service.invoke("stopService");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final provider = Provider.of<AddMedicineProvider>(context);
     // provider.set();

    final homeProvider = Provider.of<HomeProvider>(context);
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
            icon: SvgPicture.asset(
              'assets/icons/menu.svg',
              height: 24,
              width: 24,
            )),
        centerTitle: true,
        title: TextWidget(
          text: homeProvider.bottomIndex == 0 ? "My Reminders" : "History",
          fontSize: 17,
          fontWeight: gilroyBold,
          color: Colors.white,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 30,
              width: 80,
              child: CustomDropDownButton(
                  color: const Color(0xFFFFFFFF).withOpacity(0.2),
                  filled: true,
                  contentPadding: 10,
                  initValue: initialYear,
                  onChanged: (value) {
                    setState(() {
                      initialYear = value;
                      if (initialYear == DateTime.now().year.toString()) {
                        _selectedValue =   DateTime(DateTime.now().year, DateTime.now().month, 1);
                        selectedValue = DateTime.now();
                        month = DateFormat.MMMM().format(DateTime.now());
                        now = DateTime.now();
                        provider.sortData(
                            DateTime(DateTime.now().year,
                                DateTime.now().month, DateTime.now().day));
                      } else {
                        _selectedValue = DateTime(int.parse(initialYear), 1, 1);
                        monthList[0];
                        selectedValue = DateTime(int.parse(initialYear), 1, 1);
                        month = "January";
                        provider.sortData(DateTime(selectedValue.year,
                                selectedValue.month, selectedValue.day));
                      }
                    });
                  },
                  itemList: year),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        width: double.infinity,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: SvgPicture.asset('assets/icons/Arrow - Left 2.svg')),
          ),
          body: ListView(
            physics: const ClampingScrollPhysics(),
            children: [
              Container(
                height: 123,
                width: double.infinity,
                color: kPrimaryColor,
                child: Center(
                  child: Image.asset(
                    'assets/clock 1.png',
                    height: 94,
                    width: 94,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    buildContainer(
                        title: 'Notification',
                        icon: Icons.notifications_none_rounded,
                        showSwitch: true),
                    const SizedBox(
                      height: 18,
                    ),
                    buildContainer(
                      title: 'About Us',
                      icon: Icons.info_outline_rounded,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    buildContainer(
                      title: 'Share',
                      icon: Icons.share_outlined,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    buildContainer(
                      title: 'Privacy Policy',
                      icon: Icons.privacy_tip_outlined,
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    buildContainer(
                      title: 'Version',
                      icon: Icons.add,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30), topRight: Radius.circular(30)),
            color: Colors.white),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildIconButton(
                  'assets/icons/home.svg',
                  homeProvider.bottomIndex == 0,
                  () {
                    setState(() {
                      homeProvider.bottomIndex = 0;
                    });
                  },
                  context,
                ),
                Container(
                  height: 54,
                  width: 54,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(27),
                      border: Border.all(color: kCardColor)),
                  padding: const EdgeInsets.all(2),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(27),
                        color: kCardColor),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, AddMedicineScreen.routeName);
                      },
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                    ),
                  ),
                ),
                buildIconButton(
                  'assets/icons/note.svg',
                  homeProvider.bottomIndex == 1,
                  () {
                    setState(() {
                      homeProvider.bottomIndex = 1;
                    });
                  },
                  context,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(20),
                          bottomLeft: Radius.circular(20)),
                      color: kPrimaryColor,
                    ),
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          height: 42,
                          child: ListView.builder(
                              itemCount: monthList.length,
                              controller: ScrollController(
                                  initialScrollOffset: 42.0 * initialMonth),
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              padding: const EdgeInsets.only(top: 10, left: 5),
                              itemBuilder: (context, index) {
                                return MyRadioOption<String>(
                                    value: monthList[index],
                                    text: monthList[index],
                                    cardColor: const Color(0xFFFFFFFF)
                                        .withOpacity(0.1),
                                    deactivateTextColor: const Color(0xFFFFFFFF)
                                        .withOpacity(0.2),
                                    fontSize: 12,
                                    selectedTextColor: Colors.white,
                                    groupValue: month,
                                    onChanged: _valueChangedHandler());
                              }),
                        ),
                        Divider(
                          color: const Color(0xFFFFFFFF).withOpacity(0.1),
                          thickness: 1,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                          child: DatePicker(
                            _selectedValue,
                            width: 55,
                            height: 85,
                            controller: controller,
                            initialSelectedDate: selectedValue,
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
                              // final prefs =
                              //     await SharedPreferences.getInstance();
                              setState(() {
                                selectedValue = date;
                                provider.sortData(date).then((value) {});
                                // provider
                                //     .getData(date: selectedValue)
                                //     .then((value1) {
                                //   final d = jsonEncode(provider.doseTime);
                                //   flutterStorage.addNewItem(
                                //       key: "time", value: d);
                                //   // prefs.setString("time", d);
                                //   // prefs.getString("time");
                                // });
                                homeProvider.index = 0;
                                tabController1.index = 0;
                                //provider.isLoading = true;
                                month = DateFormat.MMMM().format(date);
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  homeProvider.bottomIndex == 0
                      ? Column(
                          children: [
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SvgPicture.asset(
                                  'assets/shape_rect.svg',
                                  height: 42,
                                ),
                                SizedBox(
                                  width: 280,
                                  height: 40,
                                  child: TabBar(
                                    controller: tabController1,
                                    onTap: (value) {
                                      setState(() {
                                        homeProvider.index = value;
                                      });
                                    },
                                    labelStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: gilroyBold,
                                    ),
                                    unselectedLabelStyle: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: gilroyRegular,
                                    ),
                                    unselectedLabelColor: Colors.white,
                                    labelColor: kPrimaryColor,
                                    indicatorColor: kPrimaryColor,
                                    indicatorPadding: const EdgeInsets.only(
                                        left: 30, right: 30),
                                    tabs: const [
                                      Tab(
                                        text: "Morning",
                                      ),
                                      Tab(
                                        text: "Afternoon",
                                      ),
                                      Tab(
                                        text: "Night",
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      : HistoryScreen(
                          date: DateTime(selectedValue.year,
                              selectedValue.month, selectedValue.day),
                        ),
                  if (homeProvider.bottomIndex == 0)
                    Builder(builder: (_) {
                      if (homeProvider.index == 0) {
                        return MedicineCard(
                          dose: "morning",
                          date: DateTime(selectedValue.year,
                              selectedValue.month, selectedValue.day),
                        ); //1st custom tabBarView
                      } else if (homeProvider.index == 1) {
                        return MedicineCard(
                          dose: "afternoon",
                          date: DateTime(selectedValue.year,
                              selectedValue.month, selectedValue.day),
                        ); //2nd tabView
                      } else {
                        return MedicineCard(
                          dose: "night",
                          date: DateTime(selectedValue.year,
                              selectedValue.month, selectedValue.day),
                        ); //3rd tabView
                      }
                    }),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container buildContainer(
      {bool? showSwitch = false, String? title, IconData? icon}) {
    final homeProvider = Provider.of<HomeProvider>(context, listen: false);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: Colors.white),
      child: ListTile(
        leading: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6), color: kCardColor),
          child: Icon(
            icon,
            color: kTextColor,
          ),
        ),
        title: TextWidget(
          text: title!,
          fontSize: 14,
          fontWeight: gilroySemiBold,
          color: kTextColor,
        ),
        trailing: showSwitch!
            ? CustomSwitch(
                onChanged: (vale) async {
                  // final pref = await SharedPreferences.getInstance();
                  setState(() {
                    homeProvider.isEnable = !homeProvider.isEnable;
                    if (homeProvider.isEnable) {
                      flutterStorage.addNewItem(
                          key: "isShow",
                          value: jsonEncode(homeProvider.isEnable));
                      // pref.setString(
                      //     "isShow", jsonEncode(homeProvider.isEnable));
                    } else if (!homeProvider.isEnable) {
                      flutterStorage.addNewItem(
                          key: "isShow",
                          value: jsonEncode(homeProvider.isEnable));
                    }
                  });
                },
                value: homeProvider.isEnable)
            : const Icon(Icons.chevron_right_rounded),
      ),
    );
  }
}

GestureDetector buildIconButton(
    String image, bool isSelected, Function() press, BuildContext context) {
  return GestureDetector(
    onTap: press,
    child: Column(
      children: [
        IconButton(
          onPressed: press,
          splashRadius: 10,
          icon: SvgPicture.asset(
            image,
            height: 25,
            width: 25,
            color: isSelected
                ? Theme.of(context).primaryColor
                : const Color(0xFF919096),
          ),
        ),
        isSelected
            ? const CircleAvatar(
                radius: 3,
                backgroundColor: kPrimaryColor,
              )
            : const SizedBox(),
      ],
    ),
  );
}
