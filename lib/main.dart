import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/models/uj_model_provider.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/services/controller.dart';
import 'package:vhrs_flutter_project/services/controller_bindings.dart';
import 'package:vhrs_flutter_project/services/routesClass.dart';
import 'package:vhrs_flutter_project/splash.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:vhrs_flutter_project/services/service_url.dart' as service;


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  initializeTimeZones();
  AwesomeNotifications().initialize('resource://mipmap/launcher_icon', [
    NotificationChannel(
        channelKey: 'basic_channel',
        channelName: "แจ้งเตือนการจัดกิจกรรมอาสา",
        channelDescription: "แจ้งเตือนการจัดกิจกรรมอาสาในแอพพลิเคชั่น VHRS",
        defaultColor: Color.fromARGB(255, 20, 33, 107),
        ledColor: Colors.white,
        playSound: true,
        enableLights: true,
        enableVibration: true,
        importance: NotificationImportance.High)
  ]);

  initializeDateFormatting();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Set the fit size (fill in the screen size of the device in the design) If the design is based on the size of the iPhone6 ​​(iPhone6 ​​750*1334)
    return MultiProvider(
      //import providers for MaterialApp
      providers: [
        ChangeNotifierProvider<UjModelProvider>(
            create: (context) => UjModelProvider()),
        ChangeNotifierProvider<UcModelProvider>(
            create: (context) => UcModelProvider()),
        ChangeNotifierProvider<ActivityModelProvider>(
            create: (context) => ActivityModelProvider()),
      ],
      child: ScreenUtilInit(
        designSize: Size(480, 720),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (BuildContext context,child) => GetMaterialApp(
          initialBinding: ControllerBindings(),
          debugShowCheckedModeBanner: false,
          title: 'VHRS',
          theme: appTheme().buildTheme(),
          builder: (context, widget) {
            // ScreenUtil.init(context);
            return MediaQuery(
              //Setting font does not change with system font size
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
              child: widget!,
            );
          },
          // home: Splash(),
          defaultTransition: Transition.native,
          // initialRoute: RoutesClass.home,
          getPages: RoutesClass.routes,
        ),
      ),
    );
  }
}
