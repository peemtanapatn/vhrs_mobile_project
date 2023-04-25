import 'dart:convert';
import 'dart:developer';

import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/models/uc_model.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/models/uj_model.dart';
import 'package:vhrs_flutter_project/models/uj_model_provider.dart';
import 'package:vhrs_flutter_project/pages/calendar/calendar.dart';
import 'package:vhrs_flutter_project/pages/home/home.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/pages/notifyActivity/notifyActivity.dart';
import 'package:vhrs_flutter_project/pages/profile/profile.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:vhrs_flutter_project/utils/alertCountNow.dart';

class BottomBar extends StatefulWidget {
  const BottomBar({Key? key}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  String typeUser = "";
  String emailUser = "";
  int selectedPageIndex = 0;

  @override
  void initState() {
    super.initState();
    checkPreference();
  }

  checkPreference() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        typeUser = preferences.getString("typeUser")!;
        emailUser = preferences.getString("email")!;
        log(typeUser + " : " + emailUser);
        // checkpage();
      });
    } catch (e) {
      log(e.toString());
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false);
    }
    checkpage();

    alert = await chckAlertCount();
    setState(() {});
  }

  void checkpage() {
    if (typeUser == "") {
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomePage()),
          (Route<dynamic> route) => false);
    } else {
      setDataProfile();
    }
  }

  Future<void> setDataProfile() async {
    if (typeUser == "UserJoin") {
      final responseUserjoin =
          await http.post(Uri.parse(service.url + "/get_ujProfile"), body: {
        "email": emailUser,
      });
      var result = json.decode(responseUserjoin.body);
      for (var map in result) {
        UjModel ujModel = UjModel.fromJson(map);
        UjProfile profile = UjProfile();
        profile.ujEmail = ujModel.ujEmail.toString();
        profile.ujName = ujModel.ujName.toString();
        profile.ujPhone = ujModel.ujPhone.toString();
        profile.ujIdstd = ujModel.ujIdstd.toString();
        profile.ujImg = ujModel.ujImg.toString();
        profile.ujFaculty = ujModel.ujFaculty.toString();
        profile.ujMajor = ujModel.ujMajor.toString();
        context.read<UjModelProvider>().ujProfile = profile;
      }
    } else {
      final responseUserCreate =
          await http.post(Uri.parse(service.url + "/get_ucProfile"), body: {
        "email": emailUser,
      });
      var result = json.decode(responseUserCreate.body);
      for (var map in result) {
        UcModel ucModel = UcModel.fromJson(map);
        UcProfile profile = UcProfile();
        profile.ucEmail = ucModel.ucEmail.toString();
        profile.ucName = ucModel.ucName.toString();
        profile.ucPhone = ucModel.ucPhone.toString();
        profile.ucImg = ucModel.ucImg.toString();
        profile.ucStatus = ucModel.ucStatus.toString();
        profile.ucJob = ucModel.ucJob.toString();
        profile.ucImgconfirmjob = ucModel.ucImgconfirmjob.toString();
        context.read<UcModelProvider>().ucProfile = profile;
      }
    }
  }

  var widgets = <Widget>[
    const HomePage(),
    CalendarPage(),
    NotifyActivityPage(),
    ProfilePage()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[selectedPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 24.sp,
        backgroundColor: Colors.white,
        selectedFontSize: 18.sp,
        unselectedFontSize: 16.sp,
        selectedItemColor: Theme.of(context).canvasColor,
        type: BottomNavigationBarType.fixed,
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'หน้าหลัก',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'ตารางกิจกรรม',
          ),
          BottomNavigationBarItem(
            icon: alert == 0
                ? const Icon(Icons.notifications_rounded)
                : Badge(
                    badgeContent: Text(alert.toString()),
                    child: const Icon(Icons.notifications_rounded),
                  ),
            label: 'แจ้งเตือน',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'ข้อมูลผู้ใช้',
          ),
        ],
        currentIndex: selectedPageIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Future<void> _onItemTapped(int index) async {
    alert = await chckAlertCount();
    setState(() {
      selectedPageIndex = index;
    });
  }
}
