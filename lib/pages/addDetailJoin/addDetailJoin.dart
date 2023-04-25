// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/joinActivity_model.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/chooseImage.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:date_count_down/date_count_down.dart';

class AddDetailJoinPage extends StatefulWidget {
  ActivityModel data;
  JoinActivityModel joinActivityModel;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var image;
  AddDetailJoinPage(
      {Key? key, required this.data, required this.joinActivityModel})
      : super(key: key);

  @override
  State<AddDetailJoinPage> createState() => _AddDetailJoinPageState();
}

class _AddDetailJoinPageState extends State<AddDetailJoinPage> {
  ChooseImage? chooseImage;
  String email = "";
  String oldImg = "";

  TextEditingController detailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    widget.image = widget.joinActivityModel.jaImg.toString();
    oldImg = widget.image;
    detailController.text = widget.joinActivityModel.jaDetail.toString();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // widget.image = joinActivityModel.jaImg.toString();
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.white,
          foregroundColor: Theme.of(context).secondaryHeaderColor,
          title: Text(
            "เพิ่มรายละเอียดการเข้าร่วม",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          )),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 252, 250, 250),
        ),
        child: SingleChildScrollView(
          child: SafeArea(
            child: Column(children: [
              SizedBox(height: 15.h),
              Row(
                children: [
                  SizedBox(width: 15.w),
                  Text("เวลาในการเพิ่มรายละเอียด : ",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      )),
                  Expanded(
                    child: CountDownText(
                      due: DateTime(
                          widget.data.acDend!.year,
                          widget.data.acDend!.month,
                          widget.data.acDend!.day + 3,
                          23,
                          59,
                          59),
                      finishedText: "หมดเวลาเพิ่มรายละเอียด",
                      showLabel: true,
                      longDateName: true,
                      daysTextLong: " วัน ",
                      hoursTextLong: " ชั่วโมง ",
                      minutesTextLong: " นาที ",
                      secondsTextLong: " วินาที ",
                      style: TextStyle(
                        fontSize: 16.sp,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 30.h),
              Text(
                  "จำนวนชั่วโมงที่ได้ " +
                      widget.data.acHour.toString() +
                      " ชั่วโมง",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 30.h),
              chooseImgJoin(),
              SizedBox(height: 30.h),
              Container(
                width: 440.w,
                height: 125.h,
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Form(
                  key: widget.formKey,
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: TextStyle(fontSize: 20.sp),
                          minLines: 5,
                          maxLines: 1000,
                          controller: detailController,
                          decoration: const InputDecoration(
                            prefixIcon: Icon(
                              Icons.arrow_right,
                            ),
                            hintText: "เพิ่มรายละเอียดกิจกรรม",
                          ),
                          validator: Validators.compose([
                            Validators.required("กรุณากรอกรายละเอียดกิจกรรม"),
                          ]),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30.h),
              buttonSave(),
            ]),
          ),
        ),
      ),
    );
  }

  chooseImgJoin() {
    return Container(
      width: 400.w,
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      decoration: BoxDecoration(
        color: Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(10.0.h),
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 94, 94, 94).withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(children: [
        SizedBox(height: 10.h),
        Text("เพิ่มรูปภาพกิจกรรม",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            )),
        SizedBox(height: 5.h),
        chooseImage = ChooseImage(
            r1: 90,
            b: 0,
            r2: 2,
            registerPage: null,
            updatePage: null,
            addDetailJoinPage: widget),
        SizedBox(height: 10.h),
      ]),
    );
  }

  buttonSave() {
    ProgressDialog pd = ProgressDialog(context: context);
    return RaisedButton(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 150.w),
        child: Text(
          "บันทึก",
          style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20.sp),
        ),
      ),
      onPressed: () async {
        // if (_formKey.currentState!.validate()) {
        final now = DateTime.now();
        final deadline = DateTime(widget.data.acDend!.year,
            widget.data.acDend!.month, widget.data.acDend!.day + 3, 23, 59, 59);
        if (deadline.isAfter(now)) {
          if (widget.image != null && widget.image != "") {
            if (widget.formKey.currentState!.validate()) {
              pd.show(max: 80, msg: 'โปรดรอสักครู่...');
              String nameImg = "";
              if (widget.image != oldImg) {
                nameImg = widget.image!.path.split("/").last;
                await uploadImage(widget.image!);
              } else {
                nameImg = oldImg;
              }
              var res = await http
                  .post(Uri.parse(service.url + "/update_detailjoin"), body: {
                "ja_img": nameImg,
                "ja_detail": detailController.text,
                "id": widget.data.acId,
                "email": widget.joinActivityModel.jaUjEmail,
              });

              if (res.statusCode == 200) {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                  content: const Text('บันทึกข้อมูลสำเร็จ!'),
                ));
                setState(() {});
              }
            }
          } else {
            ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
              content: const Text('โปรดเพิ่มรูปภาพกิจกรรม!'),
              backgroundColor: Color.fromARGB(255, 185, 0, 0),
            ));
          }
        } else {
          showDialog<void>(
            context: context,
            barrierDismissible: false, // user must tap button!
            builder: (BuildContext context) {
              return AlertDialog(
                // title: const Text('หมดเวลาเพิ่มรายละเอียดกิจกรรม'),
                content: SingleChildScrollView(
                  child: ListBody(
                    children: const <Widget>[
                      Text('หมดเวลาเพิ่มรายละเอียดกิจกรรม'),
                    ],
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('ตกลง'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }
}
