import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/services/service_url.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';
import 'package:vhrs_flutter_project/widgets/password_input.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

class SkipPageGG extends StatefulWidget {
  String emailGoogle;
  String role;
  SkipPageGG({Key? key, required this.emailGoogle, required this.role})
      : super(key: key);

  @override
  State<SkipPageGG> createState() =>
      _SkipPageGGState(emailGoogle: this.emailGoogle, role: this.role);
}

class _SkipPageGGState extends State<SkipPageGG> {
  String emailGoogle;
  String role;
  _SkipPageGGState({required this.emailGoogle, required this.role});

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;
  bool _confirmPwd = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Container(
            width: double.infinity,
            height: 400.h,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("กรอกรหัสผ่านของคุณ",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).canvasColor,
                          fontSize: 26.sp)),
                  SizedBox(
                    height: 25.h,
                  ),
                  formInput(),
                  SizedBox(
                    height: 20.h,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.w),
                      child: Text(
                        "บันทึก",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ),
                    onPressed: () async {
                      setState(() {
                        _confirmPwd = passwordController.text ==
                            confirmPasswordController.text;
                      });
                      await Future.delayed(const Duration(seconds: 1));
                      if (formKey.currentState!.validate()) {
                        _onPressedSave();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  formInput() {
    return Form(
        key: formKey,
        child: Wrap(spacing: 20, runSpacing: 20, children: [
          PasswordInput(
              controller: passwordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.minLength(8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
              ]),
              icon: Icons.lock_outline,
              hint: 'กรอกรหัสผ่าน',
              isObscurePassword: _isObscurePassword),
          PasswordInput(
              controller: confirmPasswordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.confirmPassword(_confirmPwd, "รหัสผ่านไม่ตรงกัน")
              ]),
              icon: Icons.lock_outline,
              hint: 'ยืนยันรหัสผ่าน',
              isObscurePassword: _isObscureConfirmPassword)
        ]));
  }

  Future _onPressedSave() async {
    String regisUrl = "";
    Map<String, dynamic> map = {};
    if (role == 'ผู้เข้าร่วมกิจกรรม') {
      regisUrl = "/signup_uj";
      map = {
        'uj_email': emailGoogle,
        'uj_password': passwordController.text,
        'uj_name': "",
        'uj_phone': "",
        'uj_idstd': "",
        'uj_major': "",
        'uj_faculty': "",
        'image': ""
      };
    } else {
      regisUrl = "/signup_uc";
      map = {
        'uc_email': emailGoogle,
        'uc_password': passwordController.text,
        'uc_job': "",
        'uc_name': "",
        'uc_phone': "",
        'image': "",
        'imgconfirmjob': "",
      };
    }
    final response =
        await http.post(Uri.parse(service.url + regisUrl), body: map);
    if (response.statusCode.toString() == "200") {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarWithText("ลงทะเบียนสำเร็จ"));
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (BuildContext context) => BottomBar()),
          (route) => false);
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('emailRegister', "");
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarWithText("ลงทะเบียนไม่สำเร็จ"));
    }

    //   await http
    //       .post(Uri.parse(url + regisUrl), body: map)
    //       .then((value) async => {
    //             statusCode = value.statusCode.toString(),
    //             print(statusCode),
    //             Future.delayed(const Duration(seconds: 1)),
    //             if (value.statusCode == 200)
    //               {
    //                 print(value.body),
    //                 ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(

    //                        "ลงทะเบียนสำเร็จ")),
    //                 Navigator.of(context).pushAndRemoveUntil(
    //                     MaterialPageRoute(
    //                         builder: (BuildContext context) => BottomBar()),
    //                     (route) => false),

    //               }
    //             else
    //               {
    //                 ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(
    //                      "ลงทะเบียนไม่สำเร็จ"))
    //               }
    //           });
    //   if (role == 'ผู้เข้าร่วมกิจกรรม') {
    //       uploadData(context, '/signup_uj', {
    //         'uj_email': "",
    //         'uj_password': "",
    //         'uj_name':"",
    //         'uj_phone':"",
    //         'uj_idstd': "",
    //         'uj_major': "",
    //         'uj_faculty': "",
    //         'image': ""
    //       });
    //     } else {

    //       uploadData(context, '/signup_uc', {
    //         'uc_email': ucForm!.emailController.text,
    //         'uc_password': ucForm!.passwordController.text,
    //         'uc_job': ucForm!.jobController.text,
    //         'uc_name': ucForm!.nameController.text,
    //         'uc_phone': ucForm!.phoneController.text,
    //         'image': _nameImg,
    //         'imgconfirmjob': nameImgJob,
    //       });
    // }
  }
}
