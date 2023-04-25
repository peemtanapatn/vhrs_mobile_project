import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/alert_activity_model.dart';
import 'package:vhrs_flutter_project/pages/register/localwidgets/ac_Form.dart';
import 'package:vhrs_flutter_project/pages/register/localwidgets/uc_Register.dart';
import 'package:vhrs_flutter_project/pages/register/localwidgets/uj_Register.dart';
import 'package:vhrs_flutter_project/pages/register/skip_page_GG.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';
import 'package:vhrs_flutter_project/widgets/chooseImage.dart';
import 'package:vhrs_flutter_project/widgets/chooseImgJob.dart';
import 'package:vhrs_flutter_project/widgets/container.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';

class RegisterPage extends StatefulWidget {
  String role;
  String emailGoogle;
  var image;
  var imageJob;

  bool validate = false;
  RegisterPage({Key? key, required this.role, required this.emailGoogle})
      : super(key: key);

  @override
  State<RegisterPage> createState() =>
      _RegisterPageState(role: role, emailGoogle: emailGoogle);
}

class _RegisterPageState extends State<RegisterPage> {
  String url = service.url;
  String role;
  String emailGoogle;
  UjRegister? ujForm;
  UcRegister? ucForm;
  ActivityForm? acForm;
  ChooseImgJob? chooseImageJob;
  _RegisterPageState({required this.role, required this.emailGoogle});
  ChooseImage? chooseImage;

  ProgressDialog? pd;

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: appContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (role != "Activity" && emailGoogle != "")
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 22.sp),
                        ),
                        onPressed: () {
                          _onPressedSkip();
                        },
                        child: const Text('ข้าม'),
                      ),
                    ),
                  _title(context, role),
                  SizedBox(
                    height: 25.h,
                  ),
                  _showAvatarChooseImage(),
                  SizedBox(
                    height: 14.h,
                  ),
                  _formShow(),
                  SizedBox(
                    height: 10.h,
                  ),
                  if (role == 'ผู้จัดกิจกรรม')
                    Column(
                      children: [
                        Text(
                          "รูปภาพหลักฐานการประกอบอาชีพ",
                          style: TextStyle(
                              fontSize: 18.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        _confirmJobChooseImage(),
                      ],
                    ),
                  SizedBox(
                    height: 20.h,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.w),
                      child: Text(
                        role != "Activity" ? "บันทึกข้อมูล" : "เพิ่มกิจกรรม",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ),
                    onPressed: () async {
                      if (ucForm != null) {
                        widget.validate =
                            ucForm!.formKey.currentState!.validate();
                      } else if (ujForm != null) {
                        widget.validate =
                            ujForm!.formKey.currentState!.validate();
                      } else {
                        widget.validate =
                            acForm!.formKey.currentState!.validate();
                      }

                      //await Future.delayed(const Duration(seconds: 1));
                      if (widget.validate) {
                        pd!.show(max: 80, msg: 'โปรดรอสักครู่...');
                        if (ucForm != null) {
                          chkUser(ucForm!.emailController.text, context);
                        } else if (ujForm != null) {
                          chkUser(ujForm!.emailController.text, context);
                        } else {
                          chkAcName(acForm!.nameController.text, context);
                        }
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

  _confirmJobChooseImage() {
    chooseImageJob = ChooseImgJob(
      registerPage: widget,
      updatePage: null,
    );
    return chooseImageJob;
  }

  _showAvatarChooseImage() {
    if (role == "Activity") {
      chooseImage = ChooseImage(
          r1: 120,
          b: 0,
          r2: 2,
          registerPage: widget,
          updatePage: null,
          addDetailJoinPage: null);
    } else {
      chooseImage = ChooseImage(
          r1: 60,
          b: 0,
          r2: 80,
          registerPage: widget,
          updatePage: null,
          addDetailJoinPage: null);
    }
    return chooseImage;
  }

  _formShow() {
    if (role == 'ผู้เข้าร่วมกิจกรรม') {
      ujForm = UjRegister(registerPage: widget);
      return ujForm;
    } else if ((role == 'ผู้จัดกิจกรรม')) {
      ucForm = UcRegister(registerPage: widget);
      return ucForm;
    } else {
      acForm = ActivityForm(registerPage: widget);
      return acForm;
    }
  }

  void chkUser(String email, BuildContext context) async {
    var res = await http
        .post(Uri.parse(url + "/chackForSignUp"), body: {'email': email});

    if (res.body == "Have") {
      pd!.close();
      ScaffoldMessenger.of(context)
          .showSnackBar(snackBarWithText('อีเมลนี้ถูกใช้ไปแล้ว'));
    } else {
      String _nameImg = "";
      String nameImgJob = "";
      if (widget.image != null) {
        await uploadImage(widget.image!);
        _nameImg = widget.image!.path.split("/").last;
      }

      if (role == 'ผู้เข้าร่วมกิจกรรม') {
        uploadData(context, '/signup_uj', {
          'uj_email': ujForm!.emailController.text,
          'uj_password': ujForm!.passwordController.text,
          'uj_name': ujForm!.nameController.text,
          'uj_phone': ujForm!.phoneController.text,
          'uj_idstd': ujForm!.stdIDController.text,
          'uj_major': ujForm!.majorController.text,
          'uj_faculty': ujForm!.facultyController.text,
          'image': _nameImg
        });
      } else {
        if (widget.imageJob != null) {
          await uploadImage(widget.imageJob!);
          nameImgJob = widget.imageJob!.path.split("/").last;
        }
        uploadData(context, '/signup_uc', {
          'uc_email': ucForm!.emailController.text,
          'uc_password': ucForm!.passwordController.text,
          'uc_job': ucForm!.jobController.text,
          'uc_name': ucForm!.nameController.text,
          'uc_phone': ucForm!.phoneController.text,
          'image': _nameImg,
          'imgconfirmjob': nameImgJob,
        });
      }
    }
  }

  _title(BuildContext context, String role) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).canvasColor,
          ),
          children: role != "Activity"
              ? <TextSpan>[
                  TextSpan(
                      text: 'บันทึกข้อมูล\n',
                      style: TextStyle(fontSize: 26.sp)),
                  TextSpan(
                    text: role,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                ]
              : [
                  TextSpan(
                      text: 'ข้อมูลกิจกรรม\n',
                      style: TextStyle(fontSize: 26.sp)),
                ]),
    );
  }

  void uploadData(BuildContext context, String regisUrl,
      [Map<String, dynamic>? map]) async {
    String statusCode;

    await http
        .post(Uri.parse(url + regisUrl), body: map)
        .then((value) async => {
              statusCode = value.statusCode.toString(),
              print(statusCode),
              Future.delayed(const Duration(seconds: 1)),
              if (value.statusCode == 200)
                {
                  print(value.body),
                  if (role == "Activity")
                    {
                      //alert defult
                      addAlertActivity(
                          "ar_1_${map!['id']}_${map['uc_email']}",
                          map['uc_email'],
                          map['id'],
                          DateTime.parse(map['dstart']!).toString()),
                      createPhoneAlert(
                          int.parse(map['id'].split("_")[1].trim() + "1"),
                          map['id']!,
                          map['name']!,
                          map['location_name'],
                          map['image']!,
                          DateTime.parse(map['dstart']!),
                          DateTime.parse(map['dend']!),
                          null)
                    },
                  Navigator.of(context).pop(),
                  ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(
                      role == "Activity"
                          ? "เพิ่มกิจกรรมสำเร็จ"
                          : "ลงทะเบียนสำเร็จ")),
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (BuildContext context) => const BottomBar()),
                      (route) => false),
                }
              else
                {
                  Navigator.of(context).pop(),
                  ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(
                      role == "Activity"
                          ? "เพิ่มกิจกรรมไม่สำเร็จ"
                          : "ลงทะเบียนไม่สำเร็จ"))
                }
            });
  }

  Future<void> chkAcName(String nameAc, BuildContext context) async {
    var res = await http.get(Uri.parse(url + "/allActivity"));
    List<ActivityModel> activityList = activityModelFromJson(res.body);
    var results = activityList.where((user) => user.acName == nameAc).toList();
    if (results.isEmpty) {
      String _nameImg = "";
      if (widget.image != null) {
        await uploadImage(widget.image!);
        _nameImg = widget.image!.path.split("/").last;
      }
      SharedPreferences preferences = await SharedPreferences.getInstance();
      int most = 0;
      for (int i = 0; i < activityList.length; i++) {
        int c = int.parse(activityList[i].acId!.split("_")[1].trim());
        if (most < c) {
          most = c;
        }
      }
      // String? countAc = activityList.last.acId;
      // final splitted = countAc!.split('_');
      // int i = int.parse(splitted[1].trim());
      String id = "ac_" + ((most + 1).toString());
      uploadData(context, '/addActivity', {
        'id': id,
        'name': acForm!.nameController.text,
        'type': acForm!.typeController.text,
        'detail': acForm!.detailController.text,
        'location_name': acForm!.locationNameController.text,
        'location_link': acForm!.locationLinkController.text,
        'dstart': acForm!.startDate.toString(),
        'dend': acForm!.endDate.toString(),
        'amount': acForm!.amountController.text,
        'hour': acForm!.hourController.text,
        'uc_email': preferences.getString("email"),
        'image': _nameImg,
      });
      log(id);
    } else {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
          snackBarWithText('ชื่อกิจกรรมซ้ำ กรุณากรอกชื่อกิจกรรมใหม่'));
    }
  }

  void _onPressedSkip() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SkipPageGG(emailGoogle: emailGoogle, role: role)));
  }
}
