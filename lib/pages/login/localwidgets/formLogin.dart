import 'dart:convert';
import 'dart:developer';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'package:vhrs_flutter_project/pages/forgotPassword/forgotPassword.dart';
import 'package:vhrs_flutter_project/pages/login/localwidgets/google_auth_2fa_page.dart';

import 'package:vhrs_flutter_project/pages/register/selectRegisterRole.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';
import 'package:vhrs_flutter_project/widgets/container.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:vhrs_flutter_project/widgets/password_input.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';
import 'package:vhrs_flutter_project/widgets/text_input.dart';

import '../../../models/uc_model.dart';
import '../../../models/uj_model.dart';

class LogInForm extends StatefulWidget {
  const LogInForm({Key? key}) : super(key: key);

  @override
  State<LogInForm> createState() => _LogInFormState();
}

class _LogInFormState extends State<LogInForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final bool _isObscurePassword = true;

  ProgressDialog? pd;

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);
    return appContainer(
        child: Column(
      children: [
        SizedBox(
          height: 20.h,
        ),
        loginFeild(),
        SizedBox(
          height: 5.h,
        ),
        _forgotPassword(),
        SizedBox(
          height: 5.h,
        ),
        _buttonLogin(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.h),
          child: Text(
            'หรือ',
            style: TextStyle(color: Colors.grey[600], fontSize: 16.sp),
          ),
        ),
        _googleLogin(),
        SizedBox(
          height: 15.h,
        ),
        const Divider(
          color: Colors.black,
        ),
        newProfileLink(context)
      ],
    ));
  }

  _forgotPassword() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(fontSize: 18.sp),
      ),
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const ForgotPasswordPage()));
      },
      child: const Text('ลืมรหัสผ่าน?'),
    );
  }

  _googleLogin() {
    return RaisedButton(
        color: Colors.white,
        child: SizedBox(
          width: 280.w,
          height: 50.h,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                  child: Image.asset('assets/images/google_PNG.png',
                      fit: BoxFit.cover)),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                'Sign-in with Google',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp),
              )
            ],
          ),
        ),
        onPressed: getGoogleAcc);
  }

  getGoogleAcc() async {
    GoogleSignIn googleSignIn = GoogleSignIn();
    googleSignIn.signOut();
    GoogleSignInAccount? googleAccount = await googleSignIn.signIn();

    if (googleAccount != null) {
      //เช็คข้อมูลอีเมลจาก google login
      final responseUserjoin =
          await http.post(Uri.parse(service.url + "/loginGG_uj"), body: {
        "email": googleAccount.email.toString(),
      });
      final responseUserCreate =
          await http.post(Uri.parse(service.url + "/loginGG_uc"), body: {
        "email": googleAccount.email.toString(),
      });
      //ตรวจสอบเงื่อนไข
      if (responseUserjoin.body.toString() != "not have email") {
        var result = json.decode(responseUserjoin.body);
        await setRoleUserJoin(result);
        goToAuth2FAPage();
      } else if (responseUserCreate.body.toString() != "not have email") {
        var result = json.decode(responseUserCreate.body);
        await setRoleUserCreate(result);
        goToAuth2FAPage();
      } else {
        //ไม่ข้อมูลอีเมลในฐานข้อมูล ไปหน้าสมัคร
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString('emailRegister', googleAccount.email.toString());
        ScaffoldMessenger.of(context).showSnackBar(
            snackBarWithText('ยังไม่มีข้อมูลของบัญชีนี้ กรุณาสร้างบัญชี'));
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => const SelectRegisterPage()));
      }
    } else {
      print('Canceled');
    }
  }

  _buttonLogin() {
    return RaisedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 100.w),
        child: Text(
          "เข้าสู่ระบบ",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp),
        ),
      ),
      onPressed: () async {
        try {
          if (_formKey.currentState!.validate()) {
            pd!.show(max: 80, msg: 'โปรดรอสักครู่...');
            String url = service.url;
            final response = await http.post(Uri.parse(url + "/login_mobile"),
                body: {
                  "email": _emailController.text,
                  "password": _passwordController.text
                });
            if (response.body == "No data") {
              pd!.close();
              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text('กรุณาตรวจสอบ Email อีกครั้ง'),
                backgroundColor: Colors.red,
              ));
            } else if (response.body == "Password invalid") {
              pd!.close();
              Scaffold.of(context).showSnackBar(const SnackBar(
                content: Text('กรุณาตรวจสอบ Password อีกครั้ง'),
                backgroundColor: Colors.red,
              ));
            } else {
              var data = json.decode(response.body);
              if (data[0]['uc_email'] != null) {
                await setRoleUserCreate(data);
                goToHomePage();
              } else if (data[0]['uj_email'] != null) {
                await setRoleUserJoin(data);
                goToHomePage();
              }
            }
            // http.Response responseUserCreate = await http
            //     .post(Uri.parse(url + "/login_uc"), body: {
            //   "email": _emailController.text,
            //   "password": _passwordController.text
            // });

            // if (responseUserjoin.body.toString() != "Password invalid") {
            //   var result = json.decode(responseUserjoin.body);
            //   setRoleUserJoin(result);
            // } else if (responseUserCreate.body.toString() !=
            //     "Password invalid") {
            //   var result = json.decode(responseUserCreate.body);
            //   setRoleUserCreate(result);
            // } else {
            //   Scaffold.of(context).showSnackBar(const SnackBar(
            //     content: Text('อีเมล หรือ รหัสผ่านไม่ถูกต้อง!'),
            //     backgroundColor: Colors.red,
            //   ));
            // }
          }
        } catch (e) {
          log(e.toString());
        }
      },
    );
  }

  void goToHomePage() {
    Navigator.of(context).pop();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const BottomBar()),
        (Route<dynamic> route) => false);
  }

  void goToAuth2FAPage() {
    Navigator.of(context).pop();
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => const Auth2FAPage()));
  }

  newProfileLink(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        FlatButton(
          onPressed: () async {
            SharedPreferences preferences =
                await SharedPreferences.getInstance();
            preferences.setString('emailRegister', "");
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SelectRegisterPage()));
          },
          child: text,
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ],
    );
  }

  var text = RichText(
    text: TextSpan(
      style:
          TextStyle(fontSize: 18.sp, color: Colors.red, fontFamily: 'prompt'),
      children: const <TextSpan>[
        TextSpan(text: 'ไม่มีบัญชี? '),
        TextSpan(
            text: 'สร้างบัญชีผู้ใช้',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );

  loginFeild() {
    return Form(
      key: _formKey,
      child: Wrap(
        runSpacing: 20.w,
        children: [
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
          SizedBox(
            height: 20.h,
          ),
          PasswordInput(
              controller: _passwordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                // Validators.minLength(8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
              ]),
              icon: Icons.lock_outline,
              hint: 'รหัสผ่าน',
              isObscurePassword: _isObscurePassword),
        ],
      ),
    );
  }
}

Future<void> setRoleUserJoin(var result) async {
  for (var map in result) {
    UjModel ujModel = UjModel.fromJson(map);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', ujModel.ujEmail.toString());
    preferences.setString('typeUser', "UserJoin");
  }
}

Future<void> setRoleUserCreate(var result) async {
  for (var map in result) {
    UcModel ucModel = UcModel.fromJson(map);
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('email', ucModel.ucEmail.toString());
    preferences.setString('typeUser', "UserCreate");
    preferences.setString('status', ucModel.ucStatus.toString());
  }
}
