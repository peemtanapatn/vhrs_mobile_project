// ignore_for_file: file_names
import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/pages/home/home.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/container.dart';

class SelectRegisterPage extends StatefulWidget {
  const SelectRegisterPage({Key? key}) : super(key: key);

  @override
  State<SelectRegisterPage> createState() => _SelectRegisterPageState();
}

class _SelectRegisterPageState extends State<SelectRegisterPage> {
  String emailGoogle = "";
  Validators? validators;

  @override
  void initState() {
    super.initState();
    _getEmailInit();
  }

  _getEmailInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    emailGoogle = preferences.getString("emailRegister")!;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "เลือกประเภทบัญชี",
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 40.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 25.h,
                ),
                Container(
                    child: Column(
                  children: [
                    btnRole("ผู้เข้าร่วมกิจกรรม", emailGoogle, context),
                    SizedBox(
                      height: 20.h,
                    ),
                    btnRole("ผู้จัดกิจกรรม", emailGoogle, context),
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

btnRole(String role, String emailGoogle, BuildContext context) {
  return RaisedButton(
    color: Colors.white,
    textColor: Theme.of(context).canvasColor,
    child: Padding(
      padding: EdgeInsets.symmetric(horizontal: 50.w),
      child: Text(
        role,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22.sp),
      ),
    ),
    onPressed: () {
      if (emailGoogle != "" && role == "ผู้เข้าร่วมกิจกรรม") {
        bool emailValid = RegExp(r"^[0-9]+@msu.ac.th").hasMatch(emailGoogle);
        if (emailValid) {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      RegisterPage(role: role, emailGoogle: emailGoogle)));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
                'รูปแบบอีเมลไม่อยู่ในรูปแบบของผู้เข้าร่วมกิจกรรม \n(ตัวอย่าง 62000000000@msu.ac.th)'),
            backgroundColor: Colors.red,
          ));
        }
      } else {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    RegisterPage(role: role, emailGoogle: emailGoogle)));
      }
    },
  );
}
