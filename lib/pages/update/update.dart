import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/models/uj_model_provider.dart';
import 'package:vhrs_flutter_project/pages/update/localwidgets/ac_Update.dart';
import 'package:vhrs_flutter_project/pages/update/localwidgets/uc_Update.dart';
import 'package:vhrs_flutter_project/pages/update/localwidgets/uj_Update.dart';
import 'package:vhrs_flutter_project/services/controller.dart';
import 'package:vhrs_flutter_project/widgets/chooseImage.dart';
import 'package:vhrs_flutter_project/widgets/chooseImgJob.dart';
import 'package:vhrs_flutter_project/widgets/container.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class UpdatePage extends StatefulWidget {
  var image;
  var imageJob;
  bool validate = false;
  String role;
  UpdatePage({Key? key, required this.role}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState(role: role);
}

class _UpdatePageState extends State<UpdatePage> {
  SharedPreferences? preferences;
  String typeUser = "";
  String emailUser = "";
  String url = service.url;
  UcUpdate? ucForm;
  UjUpdate? ujForm;
  ActivityUpdate? acUpdate;
  String nameImg = "";
  String nameImgJob = "";
  String? oldEmail = "";
  String? oldImg = "";
  String? oldImgJob = "";
  String role;
  bool isLoading = false;
  ProgressDialog? pd;

  _UpdatePageState({required this.role});

  ChooseImage? chooseImage;
  ChooseImgJob? chooseImageJob;
  @override
  void initState() {
    super.initState();
    checkTypeUser();
  }

  Future<void> checkTypeUser() async {
    try {
      preferences = await SharedPreferences.getInstance();
      setState(() {
        typeUser = preferences!.getString("typeUser")!;
        emailUser = preferences!.getString("email")!;
      });
    } catch (e) {
      // log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    pd = ProgressDialog(context: context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          role == "Activity" ? "แก้ไขข้อมูลกิจกรรม" : "แก้ไขข้อมูลส่วนตัว",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          role == "Activity"
              ? IconButton(
                  onPressed: () {
                    delThisActivity();
                  },
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 28.sp,
                  ),
                )
              : Container(),
        ],
      ),
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
        child: SingleChildScrollView(
          child: SafeArea(
              child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w, vertical: 30.h),
            child: appContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _showAvatarChooseImage(),
                  SizedBox(
                    height: 14.h,
                  ),
                  _formShow(),
                  SizedBox(
                    height: 14.h,
                  ),
                  if (role == 'UserCreate')
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
                    height: 14.h,
                  ),
                  RaisedButton(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 60.w),
                      child: Text(
                        "แก้ไข",
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.sp),
                      ),
                    ),
                    onPressed: () async {
                      validateForm();
                    },
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }

  Future<void> validateForm() async {
    if (ucForm != null) {
      widget.validate = ucForm!.formKey.currentState!.validate();
    } else if (ujForm != null) {
      widget.validate = ujForm!.formKey.currentState!.validate();
    } else if (acUpdate != null) {
      widget.validate = acUpdate!.formKey.currentState!.validate();
    }

    if (widget.validate) {
      pd!.show(max: 80, msg: 'โปรดรอสักครู่...');
      if (ucForm != null) {
        chkUser(ucForm!.emailController.text, context);
      } else if (ujForm != null) {
        chkUser(ujForm!.emailController.text, context);
      } else if (acUpdate != null) {
        chkUser(acUpdate!.nameController.text, context);
      }
    }
  }

  void chkUser(String email, BuildContext context) async {
    http.Response res;

    if (acUpdate != null) {
      print("acUpdate");
      res = await http
          .post(Uri.parse(url + "/searchNameActivity"), body: {'name': email});
    } else {
      print("chackForSignUp");
      res = await http
          .post(Uri.parse(url + "/chackForSignUp"), body: {'email': email});
    }

    if (res.body == "Have" && email != oldEmail) {
      pd!.close();
      ScaffoldMessenger.of(context).showSnackBar(snackBarWithText(
          acUpdate != null
              ? 'ชื่อกิจกรรมนี้ถูกใช้ไปแล้ว'
              : "อีเมลนี้ถูกใช้ไปแล้ว"));
    } else {
      if (widget.image != oldImg) {
        nameImg = widget.image!.path.split("/").last;
        // setState(() => isLoading = true);

        await uploadImage(widget.image!);
      } else {
        nameImg = oldImg!;
      }

      if (role == 'Userjoin') {
        print('Userjoin');
        uploadData(context, '/update_uj', {
          'uj_email': ujForm!.emailController.text,
          'uj_idstd': ujForm!.stdIDController.text,
          'uj_name': ujForm!.nameController.text,
          'uj_phone': ujForm!.phoneController.text,
          'uj_faculty': ujForm!.facultyController.text,
          'uj_major': ujForm!.majorController.text,
          'image': nameImg,
          'email_update': oldEmail
        });
      } else if (role == 'UserCreate') {
        print('update_uc');
        if (widget.imageJob != oldImgJob) {
          nameImgJob = widget.imageJob!.path.split("/").last;
          await uploadImage(widget.imageJob!);
        } else {
          nameImgJob = oldImgJob!;
        }
        uploadData(context, '/update_uc', {
          'uc_name': ucForm!.nameController.text,
          'uc_job': ucForm!.jobController.text,
          'uc_email': ucForm!.emailController.text,
          'uc_phone': ucForm!.phoneController.text,
          'image': nameImg,
          'imgconfirmjob': nameImgJob,
          'email_update': oldEmail
        });
      } else if (role == 'Activity') {
        String acId = Provider.of<ActivityModelProvider>(context, listen: false)
            .activity
            .acId!;
        final _controller = Get.find<Controller>();
        final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm', 'th');
        await _controller.createNotify(
            int.parse(acId.split("_")[1].trim() + "1"),
            acId,
            "กิจกรรม : " + acUpdate!.nameController.text,
            "เริ่ม " +
                formatter.format(acUpdate!.startDate) +
                " น.  " +
                "ถึง " +
                formatter.format(acUpdate!.endDate) +
                " น.\n" +
                "สถานที่ : " +
                acUpdate!.locationNameController.text,
            nameImg,
            acUpdate!.startDate);

        await http.post(Uri.parse(url + "/editArTimeAlertActivity"), body: {
          "ar_id": "ar_1_${acId}_$emailUser",
          'ar_time': acUpdate!.startDate.toString()
        });

        uploadData(context, '/update_ac', {
          'id': acId,
          'name': acUpdate!.nameController.text,
          'type': acUpdate!.typeController.text,
          'detail': acUpdate!.detailController.text,
          'location_name': acUpdate!.locationNameController.text,
          'location_link': acUpdate!.locationLinkController.text,
          'dstart': acUpdate!.startDate.toString(),
          'dend': acUpdate!.endDate.toString(),
          'amount': acUpdate!.amountController.text,
          'hour': acUpdate!.hourController.text,
          'image': nameImg,
        });
      }
    }
  }

  void uploadData(BuildContext context, String updateUrl,
      [Map<String, dynamic>? map]) async {
    String statusCode;
    setNewDataProvider();
    await http.post(Uri.parse(url + updateUrl), body: map).then((value) => {
          statusCode = value.statusCode.toString(),
          log(statusCode),
          Future.delayed(const Duration(seconds: 2)),
          if (value.statusCode == 200)
            {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarWithText('แก้ไขข้อมูลสำเร็จ')),
              Navigator.of(context).pop(),
              Navigator.of(context).pop(),
              // Navigator.of(context).pushAndRemoveUntil(
              //     MaterialPageRoute(
              //         builder: (BuildContext context) => BottomBar()),
              //     (route) => false)
            }
          else
            {
              ScaffoldMessenger.of(context)
                  .showSnackBar(snackBarWithText('แก้ไขข้อมูลไม่สำเร็จ')),
              Navigator.of(context).pop(),
            }
        });
  }

  setNewDataProvider() async {
    if (role == "UserCreate") {
      UcProfile profile = UcProfile();
      profile.ucEmail = ucForm!.emailController.text;
      profile.ucName = ucForm!.nameController.text;
      profile.ucPhone = ucForm!.phoneController.text;
      profile.ucStatus = ucForm!.status;
      profile.ucImg = nameImg;
      profile.ucJob = ucForm!.jobController.text;
      profile.ucImgconfirmjob = nameImgJob;
      context.read<UcModelProvider>().ucProfile = profile;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', ucForm!.emailController.text);
    } else if (role == "Userjoin") {
      UjProfile profile = UjProfile();
      profile.ujEmail = ujForm!.emailController.text;
      profile.ujIdstd = ujForm!.stdIDController.text;
      profile.ujName = ujForm!.nameController.text;
      profile.ujPhone = ujForm!.phoneController.text;
      profile.ujImg = nameImg;
      profile.ujFaculty = ujForm!.facultyController.text;
      profile.ujMajor = ujForm!.majorController.text;
      context.read<UjModelProvider>().ujProfile = profile;
      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setString('email', ujForm!.emailController.text);
    } else if (role == "Activity") {
      ActivityModel profile = ActivityModel();
      profile.acName = acUpdate!.nameController.text;
      profile.acType = acUpdate!.typeController.text;
      profile.acDetail = acUpdate!.detailController.text;
      profile.acLocationName = acUpdate!.locationNameController.text;
      profile.acLocationLink = acUpdate!.locationLinkController.text;
      profile.acAmount = int.parse(acUpdate!.amountController.text);
      profile.acHour = int.parse(acUpdate!.hourController.text);
      profile.acDstart = acUpdate!.startDate;
      profile.acDend = acUpdate!.endDate;
      profile.acId = Provider.of<ActivityModelProvider>(context, listen: false)
          .activity
          .acId;
      profile.acUcEmail =
          Provider.of<ActivityModelProvider>(context, listen: false)
              .activity
              .acUcEmail;
      profile.acImg = nameImg;
      context.read<ActivityModelProvider>().activity = profile;
    }
  }

  _formShow() {
    if (role == "Activity") {
      oldEmail = context.watch<ActivityModelProvider>().activity.acName;
      oldImg = context.watch<ActivityModelProvider>().activity.acImg;
      acUpdate = ActivityUpdate();
      return acUpdate;
    } else {
      if (role == 'Userjoin') {
        oldEmail = context.watch<UjModelProvider>().ujProfile.ujEmail;
        oldImg = context.watch<UjModelProvider>().ujProfile.ujImg;
        ujForm = UjUpdate();
        return ujForm;
      } else {
        oldEmail = context.watch<UcModelProvider>().ucProfile.ucEmail;
        oldImg = context.watch<UcModelProvider>().ucProfile.ucImg;
        oldImgJob = context.watch<UcModelProvider>().ucProfile.ucImgconfirmjob;
        ucForm = UcUpdate();
        return ucForm;
      }
    }
  }

  _showAvatarChooseImage() {
    if (role == 'Activity') {
      widget.image = context.watch<ActivityModelProvider>().activity.acImg;
      chooseImage = ChooseImage(
          r1: 120,
          b: 0,
          r2: 2,
          registerPage: null,
          updatePage: widget,
          addDetailJoinPage: null);
    } else {
      if (role == 'Userjoin') {
        widget.image = context.watch<UjModelProvider>().ujProfile.ujImg;
      } else if (role == 'UserCreate') {
        widget.image = context.watch<UcModelProvider>().ucProfile.ucImg;
      }
      chooseImage = ChooseImage(
          r1: 60,
          b: 0,
          r2: 80,
          registerPage: null,
          updatePage: widget,
          addDetailJoinPage: null);
    }

    return chooseImage;
  }

  _confirmJobChooseImage() {
    widget.imageJob =
        context.watch<UcModelProvider>().ucProfile.ucImgconfirmjob;
    chooseImageJob = ChooseImgJob(
      registerPage: null,
      updatePage: widget,
    );
    return chooseImageJob;
  }

  void delThisActivity() {
    String id = Provider.of<ActivityModelProvider>(context, listen: false)
        .activity
        .acId!;

    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ลบข้อมูลกิจกรรม'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () async {
                String status = await delActivity(id);
                if (status == "SUCCESS") {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(snackBarWithText('ลบข้อมูลกิจกรรมสำเร็จ'));
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                      snackBarWithText('ลบข้อมูลกิจกรรไม่สำเร็จ'));
                }
              },
            ),
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }
}
