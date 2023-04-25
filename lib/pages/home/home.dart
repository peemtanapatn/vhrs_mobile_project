import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/models/uc_model.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/pages/login/login.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/widgets/listActivity.dart';
import 'package:vhrs_flutter_project/widgets/logo_appbar.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String typeUser = "";
  String emailUser = "";
  String status = "";
  String checkStatus = service.url + "/get_ucProfile";

  @override
  void initState() {
    super.initState();
    checkPreference();
  }

  Future<void> checkPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    // print("checkPreference");

    try {
      typeUser = preferences.getString("typeUser")!;
      if (typeUser == "UserCreate") {
        final responseUserCreate = await http.post(Uri.parse(checkStatus),
            body: {"email": preferences.getString("email")});
        var result = json.decode(responseUserCreate.body);
        for (var map in result) {
          UcModel ucModel = UcModel.fromJson(map);
          preferences.setString('status', ucModel.ucStatus.toString());
        }
      }
      status = preferences.getString("status")!;
      context.read<UcModelProvider>().ucProfile.ucStatus =
          preferences.getString("status")!;
    } catch (e) {
      log(e.toString());
    }
    setState(() {});

    print("typeUser: " + typeUser + " " + status);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 50.h,
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        title: LogoAppbar(context),
        actions: [typeUser != "" ? Container() : _logInButton()],
      ),
      body: Column(
        mainAxisSize: MainAxisSize.min,
        verticalDirection: VerticalDirection.down,
        children: [
          Expanded(
              child: ListActivity(
            allUrl: '/allActivityJoinUcName',
          )),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Visibility(
        visible: floatButton(),
        child: SizedBox(
          height: 50.h,
          width: 50.w,
          child: FittedBox(
            child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => RegisterPage(
                              role: 'Activity',
                              emailGoogle: "",
                            )));
              },
              backgroundColor: Colors.white,
              child: Icon(Icons.add, color: Colors.green, size: 40.sp),
            ),
          ),
        ),
      ),
    );
  }

  bool floatButton() {
    if (typeUser == 'UserCreate' && status == 'อนุมัติ') {
      return true;
    } else {
      return false;
    }
  }

  _logInButton() {
    return FlatButton(
      onPressed: () {
        Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => const LoginPage()));
      },
      child: Text("เข้าสู่ระบบ/สร้างบัญชีผู้ใช้",
          style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14.sp,
              color: Theme.of(context).canvasColor)),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
  }
}
