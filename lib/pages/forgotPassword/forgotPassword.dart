import 'dart:math';

import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/password_input.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:vhrs_flutter_project/widgets/text_input.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  int numOtp = 0;
  bool sending = false;
  bool confirmOtp = false;
  bool isLoading = false;
  final bool _isObscurePassword = true;

  Future<void> _onTapConfirmEmail() async {
    if (_formKey.currentState!.validate()) {
      try {
        final response = await http.post(
            Uri.parse(
                "${service.serverPath}/VHRSservice/index.php/check_emailInSystem"),
            body: {"email": _emailController.text});
        if (response.body == "No data") {
          ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(
            'ไม่พบ Email นี้ในระบบ กรุณาตรวจสอบ Email อีกครั้ง',
          ));
        } else {
          if (isLoading) return;
          setState(() => isLoading = true);
          sendMail();
        }
      } catch (e) {
        print(e);
        snackBarWithText(
          'กรุณาตรวจสอบ Email  อีกครั้ง',
        );
        // snackBarWithText('กรุณาตรวจสอบ Email และ Password อีกครั้ง', context);
      }
    }
  }

  Future<void> sendMail() async {
    String username = '62011212017@msu.ac.th';
    String password = 'peem33220';
    var value = Random();
    var codeNumber = value.nextInt(9999) + 1000;
    numOtp = codeNumber;
    String subject = 'รหัสยืนยันจากระบบเก็บชั่วโมงจิตอาสา';
    String html = '<p>สวัสดี ' +
        _emailController.text +
        ' รหัสยืนยันเพื่อเปลี่ยนรหัสผ่านของคุณคือ</p>\n<h1>"' +
        numOtp.toString() +
        '"</h1>';

    // ignore: deprecated_member_use
    final smtpServer = gmail(username, password);

    final message = Message()
      ..from = Address(username, 'ระบบเก็บชั่วโมงจิตอาสา')
      ..recipients.add(_emailController.text)
      ..subject = subject
      ..text = 'This is the plain text.\nThis is line 2 of the text part.'
      ..html = html;

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ' + sendReport.toString());
      isLoading = false;
      sending = true;
      setState(() {});
    } on MailerException catch (e) {
      print('Message not sent.');
      print(e);
      for (var p in e.problems) {
        print('Problem: ${p.code}: ${p.msg}');
      }
    }
  }

  Future<void> _onTapChagePassword() async {
    if (_formKey.currentState!.validate()) {
      final response = await http
          .post(Uri.parse(service.url + "/forgotChangeNewPassword"), body: {
        "email": _emailController.text,
        "new_password": _passwordController.text
      });
      if (response.body.toString() == "Success") {
        sending = false;
        confirmOtp = false;
        numOtp = 0;
        _emailController.text = '';
        _otpController.text = '';
        _passwordController.text = '';

        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWithText('แก้ไขรหัสผ่านสำเร็จ'));
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(snackBarWithText('แก้ไขรหัสผ่านล้มเหลว'));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          title: const Text("ลืมรหัสผ่าน")),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 231, 228, 228),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
              child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: Colors.white.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            constraints: const BoxConstraints(maxWidth: 400),
            padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 20.w),
            child: SingleChildScrollView(
                child: confirmOtp
                    ? _containerChangeNewPassword()
                    : _containerForgot()),
          )),
        ),
      ),
    );
  }

  _containerChangeNewPassword() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                "กรอกผ่านใหม่ของคุณ",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Form(
              key: _formKey,
              child: Column(children: [
                PasswordInput(
                    controller: _passwordController,
                    compose: Validators.compose([
                      Validators.required("กรุณากรอกรหัสผ่าน"),
                      Validators.minLength(
                          8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
                    ]),
                    icon: Icons.lock_outline,
                    hint: 'รหัสผ่าน',
                    isObscurePassword: _isObscurePassword),
              ])),
          const SizedBox(
            height: 10,
          ),
          InkWell(
            onTap: () {
              _onTapChagePassword();
            },
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).secondaryHeaderColor),
              alignment: Alignment.center,
              width: 150,
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                "ตกลง",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ]);
  }

  _containerForgot() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            children: [
              Text(
                sending ? "กรอกรหัสยืนยัน" : "กรอกอีเมลในระบบของคุณ",
                style: TextStyle(fontSize: 28.sp, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                    sending
                        ? "กรุณากรอกรหัสยืนยันภายในเวลาที่กำหนด"
                        : "   ระบบจะส่งรหัสผ่านยืนยันไปยังอีเมลเพื่อเปลี่ยนรหัสผ่านของคุณ",
                    style: TextStyle(fontSize: 17.sp, color: Colors.grey)),
              )
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          _checkFrom()
        ]);
  }

  _checkFrom() {
    if (sending) {
      return __formOtp();
    } else {
      return _formEmail();
    }
  }

  __formOtp() {
    final now = DateTime.now();
    final deadline = DateTime(
        now.year, now.month, now.day, now.hour, now.minute, now.second + 10);
    int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 10;

    return Column(
      children: [
        TimerCountdown(
          format: CountDownTimerFormat.minutesSeconds,
          endTime: DateTime.now().add(
            const Duration(
              days: 0,
              hours: 0,
              minutes: 3,
              seconds: 0,
            ),
          ),
          onEnd: () {
            sending = false;
            confirmOtp = false;
            numOtp = 0;
            _emailController.text = '';
            _otpController.text = '';
            ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(
              'คุณไม่ได้กรอกรหัสยืนยันในเวลาที่กำหนด',
            ));
            setState(() {});
          },
          timeTextStyle: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 38.sp,
          ),
          descriptionTextStyle: const TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
            fontSize: 1,
          ),
        ),
        SizedBox(height: 10.h),
        Form(
          key: _formKey,
          child: Column(
            children: [
              TextInput(
                controller: _otpController,
                compose: (val) {
                  if (val!.isEmpty) return 'กรุณากรอกรหัสยืนยัน';
                  if (val != numOtp.toString()) return 'รหัสยืนยันไม่ถูกต้อง';
                  return null;
                },
                icon: Icons.lock,
                hint: "กรอกรหัสยืนยัน",
                typeInput: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        InkWell(
          onTap: () {
            if (_formKey.currentState!.validate()) {
              confirmOtp = true;
              setState(() {});
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).secondaryHeaderColor),
            alignment: Alignment.center,
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: const Text(
              "ตกลง",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        SizedBox(height: 10.h),
        TextButton(
          style: TextButton.styleFrom(
            textStyle: TextStyle(fontSize: 18.sp),
          ),
          onPressed: () {
            sending = false;
            confirmOtp = false;
            numOtp = 0;
            _emailController.text = '';
            _otpController.text = '';

            setState(() {});
          },
          child: const Text('เปลี่ยนอีเมล'),
        )
      ],
    );
  }

  _formEmail() {
    return Column(
      children: [
        Form(
            key: _formKey,
            child: Column(children: [
              TextInput(
                controller: _emailController,
                compose: Validators.compose([
                  Validators.required("กรุณากรอกอีเมล"),
                  Validators.email("รูปแบบอีเมลไม่ถูกต้อง"),
                ]),
                icon: Icons.email_outlined,
                hint: "อีเมล",
                typeInput: TextInputType.emailAddress,
              ),
            ])),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () {
            _onTapConfirmEmail();
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Theme.of(context).secondaryHeaderColor),
            alignment: Alignment.center,
            width: 150,
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: isLoading
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        " รอสักครู่...",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                : const Text(
                    "ตกลง",
                    style: TextStyle(color: Colors.white),
                  ),
          ),
        ),
      ],
    );
  }
}
