// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';
import 'package:vhrs_flutter_project/widgets/password_input.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmNewPasswordController = TextEditingController();
  final bool _isObscurePassword = true;
  final bool _isObscureConfirmPassword = true;
  bool _confirmPwd = false;
  String email = "";
  String url = service.url;

  ProgressDialog? pd;

  @override
  void initState() {
    super.initState();
    _getPreferences();
  }

  _getPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    email = preferences.getString("email")!;
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(
            "เปลี่ยนรหัสผ่านใหม่",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 231, 228, 228),
        ),
        child: Center(
            child: SingleChildScrollView(
                child: SafeArea(
          child: Container(
            width: 400.w,
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 245, 245, 245),
              borderRadius: BorderRadius.circular(10.0.h),
              boxShadow: [
                BoxShadow(
                  color: const Color.fromARGB(255, 94, 94, 94).withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(children: [
              SizedBox(
                height: 20.h,
              ),
              formInput(),
              SizedBox(
                height: 20.h,
              ),
              RaisedButton(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 60.w),
                    child: Text(
                      "เปลี่ยนรหัสผ่านใหม่",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ),
                  onPressed: () async {
                    setState(() {
                      _confirmPwd = newPasswordController.text ==
                          confirmNewPasswordController.text;
                    });
                    await Future.delayed(const Duration(seconds: 1));
                    if (formKey.currentState!.validate()) {
                      pd!.show(max: 80, msg: 'โปรดรอสักครู่...');
                      setNewPassword();
                    }
                  }),
              SizedBox(
                height: 20.h,
              ),
            ]),
          ),
        ))),
      ),
    );
  }

  void setNewPassword() async {
    final response =
        await http.post(Uri.parse(service.url + "/changePassword"), body: {
      "email": email,
      "password": oldPasswordController.text,
      "new_password": newPasswordController.text
    });
    if (response.body.toString() == "Success") {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarWithText('แก้ไขรหัสผ่านสำเร็จ'));
      Navigator.of(context).pop();
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(
      //         builder: (BuildContext context) => const BottomBar()),
      //     (route) => false);
    } else {
      pd!.close();
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarWithText('รหัสผ่านปัจจุบันไม่ถูกต้อง'));
    }
  }

  formInput() {
    return Form(
        key: formKey,
        child: Wrap(spacing: 20, runSpacing: 20, children: [
          PasswordInput(
              controller: oldPasswordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.minLength(8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
              ]),
              icon: Icons.lock_outline,
              hint: 'รหัสผ่านปัจจุบัน',
              isObscurePassword: _isObscurePassword),
          PasswordInput(
              controller: newPasswordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.minLength(8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
              ]),
              icon: Icons.lock_outline,
              hint: 'รหัสผ่านใหม่',
              isObscurePassword: _isObscurePassword),
          PasswordInput(
              controller: confirmNewPasswordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.confirmPassword(_confirmPwd, "รหัสผ่านไม่ตรงกัน")
              ]),
              icon: Icons.lock_outline,
              hint: 'ยืนยันรหัสผ่านใหม่',
              isObscurePassword: _isObscureConfirmPassword)
        ]));
  }
}
