import 'dart:async';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:base32/base32.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:otp/otp.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';

class Auth2FAPage extends StatefulWidget {
  const Auth2FAPage({Key? key}) : super(key: key);

  @override
  State<Auth2FAPage> createState() => _Auth2FAPageState();
}

class _Auth2FAPageState extends State<Auth2FAPage> {
  String email = "";
  String type = "";
  String status = "";
  String secret = "";
  SharedPreferences? preferences;
  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  @override
  void initState() {
    super.initState();
    setdata();
  }

  void setdata() async {
    preferences = await SharedPreferences.getInstance();
    email = preferences!.getString("email") ?? "";
    type = preferences!.getString("typeUser") ?? "";
    status = preferences!.getString("status") ?? "";
    secret = base32.encodeString(email);
    preferences!.clear();
    setState(() {});
    print("$email : $type");
    // for (int i = 0; i < 6; i++) {
    //   _listcontroller.add(TextEditingController());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomInset: t,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text("ยืนยันตัวตน"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 40.h,
            ),
            _text("แสกนด้วย Google Authenticator"),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: BarcodeWidget(
                height: 260.h,
                width: 300.w,
                data: "otpauth://totp/$email?secret=$secret&issuer=VHRS",
                barcode: Barcode.qrCode(),
              ),
            ),
            _text("กรอกรหัส OTP"),
            _field(),
          ],
        ),
      ),
    );
  }

  _field() {
    return Padding(
      padding: EdgeInsets.all(20.sp),
      child: PinCodeTextField(
          appContext: context,
          keyboardType: TextInputType.number,
          controller: textEditingController,
          length: 6,
          onChanged: (pin) {},
          onCompleted: (code) {
            textEditingController.clear();
            String otp = genarate().toString();
            if (otp == code) {
              preferences!.setString("email", email);
              preferences!.setString("typeUser", type);
              preferences!.setString("status", status);
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const BottomBar()),
                  (Route<dynamic> route) => false);
            } else {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarWithText('รหัส OTP ไม่ถูกต้อง'));
            }
            setState(() {});
          }),
    );
  }

  _text(String txt) {
    return Text(
      txt,
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  int genarate() {
    int code = OTP.generateTOTPCode(
        secret, DateTime.now().millisecondsSinceEpoch,
        isGoogle: true, length: 6, algorithm: Algorithm.SHA1);
    return code;
  }

  clear(List<TextEditingController> listcontroller) {
    for (TextEditingController data in listcontroller) {
      data.text = "";
    }
    setState(() {});
  }
}
