import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vhrs_flutter_project/models/ujAndJoinActivity_model.dart';
import 'package:vhrs_flutter_project/pages/manageUserJoin/manageUj.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;

class DialogDetailJoin extends StatefulWidget {
  UjAndJoinActivityModel model;
  DialogDetailJoin({Key? key, required this.model}) : super(key: key);

  @override
  State<DialogDetailJoin> createState() => _DialogDetailJoinState(this.model);
}

class _DialogDetailJoinState extends State<DialogDetailJoin> {
  UjAndJoinActivityModel? data;

  _DialogDetailJoinState(UjAndJoinActivityModel model) {
    data = model;
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
      padding:
          EdgeInsets.only(top: 16.h, bottom: 16.h, left: 16.w, right: 16.w),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Row(children: [
          profileCircleAvatar(),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data!.ujName.toString(),
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold)),
                Text("คณะ " + data!.ujFaculty.toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 108, 108, 108),
                      fontSize: 16.w,
                    )),
                Text("สาขา " + data!.ujMajor.toString(),
                    style: TextStyle(
                      color: Color.fromARGB(255, 108, 108, 108),
                      fontSize: 16.w,
                    ))
              ],
            ),
          )
        ]),
        SizedBox(height: 10.h),
        Text("รูปภาพยืนยันของผู้เข้าร่วม",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.w,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 5.h),
        CircleAvatar(
            backgroundColor: Colors.white,
            radius: 100.r,
            child: ClipRRect(
              child: data!.jaImg.toString() != null &&
                      data!.jaImg.toString() != "" &&
                      data!.jaImg.toString() != "null"
                  ? Image.network(
                      service.uploads + data!.jaImg.toString(),
                      fit: BoxFit.cover,
                      // height: 120.h,
                      // width: 400.w,
                    )
                  : Text("ไม่มีรูปภาพที่เพิ่ม",
                      style: TextStyle(
                        color: Color.fromARGB(255, 108, 108, 108),
                        fontSize: 18.w,
                      )),
              borderRadius: BorderRadius.circular(2.r),
            )),
        SizedBox(height: 10.h),
        Text("รายละเอียดกิจกรรมที่ผู้เข้าร่วมเพิ่ม",
            style: TextStyle(
                color: Colors.black,
                fontSize: 18.w,
                fontWeight: FontWeight.bold)),
        SizedBox(height: 5.h),
        Container(
            width: 300.w,
            height: 200.h,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 240, 240, 240),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: EdgeInsets.all(10.h),
                  child: data!.jaDetail.toString() != ""
                      ? Text(data!.jaDetail.toString(),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.w,
                          ))
                      : Text("ไม่มีรายละเอียดที่เพิ่ม",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16.w,
                          )),
                )
              ],
            )),
        ButtonBar(
          children: [
            if (data!.jaStatus.toString() != "ยืนยันการเข้าร่วม")
              FlatButton(
                onPressed: () async {
                  var res = await http.post(
                      Uri.parse(service.url + "/update_statusJoinPass"),
                      body: {
                        "status": "ยืนยันการเข้าร่วม",
                        "id": data!.jaId,
                      });

                  if (res.statusCode == 200) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ManageUjPage(
                                  acId: data!.jaAcId.toString(),
                                )));
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: const Text('ยืนยันการเข้าร่วมสำเร็จ!'),
                    ));
                  }
                },
                child: Text("ยืนยันการเข้าร่วม",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18.w,
                    )),
              ),
            if (data!.jaStatus.toString() == "ยืนยันการเข้าร่วม")
              FlatButton(
                onPressed: () async {
                  var res = await http.post(
                      Uri.parse(service.url + "/update_statusJoinPass"),
                      body: {
                        "status": "",
                        "id": data!.jaId,
                      });

                  if (res.statusCode == 200) {
                    Navigator.of(context).pop();
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ManageUjPage(
                                  acId: data!.jaAcId.toString(),
                                )));
                    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                      content: const Text('ยกเลิกยืนยันการเข้าร่วมสำเร็จ!'),
                    ));
                  }
                },
                child: Text("ยกเลิกยืนยันการเข้าร่วม",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 18.w,
                    )),
              ),
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("ปิด",
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 18.w,
                  )),
            )
          ],
        )
      ]),
    );
  }

  profileCircleAvatar() {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40.r,
        child: ClipRRect(
          child: data!.ujImg.toString() != null && data!.ujImg.toString() != ""
              ? Image.network(
                  service.uploads + data!.ujImg.toString(),
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 300.w,
                )
              : Image.asset(
                  "assets/images/user.jpg",
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 300.w,
                ),
          borderRadius: BorderRadius.circular(80.r),
        ));
  }
}
