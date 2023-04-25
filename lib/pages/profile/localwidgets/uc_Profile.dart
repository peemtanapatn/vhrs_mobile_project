// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/pages/chkActivityHour/chkActivityHour.dart';
import 'package:vhrs_flutter_project/pages/home/home.dart';
import 'package:vhrs_flutter_project/pages/update/changePassword.dart';
import 'package:vhrs_flutter_project/pages/update/update.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

class ProfileFormUC extends StatefulWidget {
  const ProfileFormUC({Key? key}) : super(key: key);

  @override
  State<ProfileFormUC> createState() => _ProfileFormUCState();
}

class _ProfileFormUCState extends State<ProfileFormUC> {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          profileContainer(),
          SizedBox(height: 20.h),
          createButton(
              const Icon(
                Icons.content_paste,
                color: Color.fromARGB(255, 114, 113, 113),
              ),
              "รายงานการจัดกิจกรรม",
              ChkActivityHourPage()),
          SizedBox(height: 20.h),
          createButton(
              const Icon(
                Icons.create_outlined,
                color: Color.fromARGB(255, 114, 113, 113),
              ),
              "แก้ไขข้อมูลส่วนตัว",
              UpdatePage(role: "UserCreate")),
          createButton(
              const Icon(
                Icons.lock_outline,
                color: Color.fromARGB(255, 114, 113, 113),
              ),
              "เปลี่ยนรหัสผ่าน",
              const ChangePasswordPage()),
        ],
      ),
    );
  }

  Container createButton(Icon icon1, String text, Widget page) {
    return Container(
      width: 400.w,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: RaisedButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => page));
        },
        color: const Color.fromARGB(255, 245, 245, 245),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
          0,
        )),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child: Row(
            children: <Widget>[
              icon1,
              SizedBox(width: 5.5.w),
              Text(
                text,
                style: TextStyle(
                  fontSize: 15.w,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),
              const Spacer(),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color.fromARGB(255, 8, 28, 138),
              )
            ],
          ),
        ),
      ),
    );
  }

  Container profileContainer() {
    return Container(
      width: 400.w,
      padding: EdgeInsets.all(20.0.h),
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
        Row(children: [
          Container(
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 40.r,
              child: ClipRRect(
                child: context.watch<UcModelProvider>().ucProfile.ucImg != "" &&
                        context.watch<UcModelProvider>().ucProfile.ucImg !=
                            "null"
                    ? Image.network(
                        '${service.serverPath}/VHRSservice/uploads/' +
                            context.watch<UcModelProvider>().ucProfile.ucImg,
                        loadingBuilder: ((context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                        fit: BoxFit.cover,
                        height: 200.h,
                        width: 300.w,
                      )
                    : Image.asset(
                        "assets/images/user.jpg",
                        fit: BoxFit.cover,
                      ),
                borderRadius: BorderRadius.circular(80.r),
              ),
            ),
          ),
          SizedBox(width: 15.w),
          if (context.watch<UcModelProvider>().ucProfile.ucName != "")
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    context.watch<UcModelProvider>().ucProfile.ucName,
                    style: TextStyle(
                        color: const Color.fromARGB(255, 19, 18, 18),
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5.h),
                  detailUser("อาชีพ",
                      context.watch<UcModelProvider>().ucProfile.ucJob),
                  detailUser("สถานะการจัดกิจกรรม",
                      context.watch<UcModelProvider>().ucProfile.ucStatus),
                  // detailUser("คณะ",
                  //     context.watch<UjModelProvider>().ujProfile.ujFaculty),
                ],
              ),
            ),
          if (context.watch<UcModelProvider>().ucProfile.ucName == "")
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "กรุณาเพิ่มข้อมูลส่วนตัว",
                    style: TextStyle(
                        color: Colors.red,
                        fontSize: 18.w,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
        ]),
        SizedBox(height: 15.h),
        Container(
          width: 350.w,
          height: 50.w,
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 8, 28, 138),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(
                  "ประเภทบัญชี : ",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 246, 245, 245),
                      fontSize: 14.w,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "ผู้จัดกิจกรรม",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 1, 253, 5),
                      fontSize: 14.w,
                      fontWeight: FontWeight.bold),
                ),
              ])
            ],
          ),
        )
      ]),
    );
  }

  Row detailUser(String text1, String text2) {
    return Row(children: [
      const SizedBox(
        height: 5,
      ),
      Text(
        text1,
        style: TextStyle(
            color: const Color.fromARGB(255, 109, 106, 106),
            fontSize: 14.w,
            fontWeight: FontWeight.bold),
      ),
      SizedBox(
        width: 10.w,
      ),
      Expanded(
        child: Text(
          text2,
          style: TextStyle(
              color: const Color.fromARGB(255, 12, 12, 12),
              fontSize: 14.w,
              fontWeight: FontWeight.bold),
        ),
      ),
    ]);
  }
}
