// ignore_for_file: file_names
import 'dart:developer';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/alert_activity_model.dart';
import 'package:vhrs_flutter_project/models/joinActivity_model.dart';
import 'package:vhrs_flutter_project/models/uc_model.dart';
import 'package:vhrs_flutter_project/models/uj_model.dart';
import 'package:vhrs_flutter_project/pages/addDetailJoin/addDetailJoin.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/localwidget/setting_alert_page.dart';
import 'package:vhrs_flutter_project/pages/manageUserJoin/manageUj.dart';
import 'package:vhrs_flutter_project/pages/update/update.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:vhrs_flutter_project/services/service_url.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/controller.dart';

class DetailActivityPage extends StatefulWidget {
  ActivityModel? data;

  DetailActivityPage({
    Key? key,
    required this.data,
  }) : super(key: key);

  @override
  State<DetailActivityPage> createState() => _DetailActivityPageState();
}

class _DetailActivityPageState extends State<DetailActivityPage> {
  final _controller = Get.find<Controller>();
  final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm น.', 'th');
  String typeUser = "";
  String nameUser = "";
  String emailUser = "";
  String chkJoin = "";
  String nameUj = "";
  late List<JoinActivityModel> listDataJoin;
  bool isLoading = false;
  UcModel? ucModel;
  int countJoin = 0;
  AlertActivityModel? dataAlert;
  TextEditingController alertController = TextEditingController();
  DateTime arTime = DateTime.now();
  // List<NotificationModel>? listNotifications;

  @override
  void initState() {
    super.initState();
    setData();
  }

  setData() async {
    if (Get.parameters['id'] != null) {
      try {
        var res = await http.post(Uri.parse(url + "/searchIDActivity"),
            body: {'id': Get.parameters['id']});
        ActivityModel lists = activityModelFromJson(res.body)[0];
        widget.data = lists;
        if (mounted) {
          setState(() {});
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarWithText('ผิดพลาด'));
        print(e);
        Get.offAllNamed("/Home");
      }
    }

    var model = getUcName(widget.data!.acUcEmail!);
    ucModel = await model;

    countJoin = await getCountJoin(widget.data!.acId!);
    int c = int.parse(widget.data!.acId!.split("_")[1].trim());

    if (mounted) {
      setState(() {});
    }

    checkPreference();
    setDataAlert();
  }

  Future<void> checkPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    try {
      setState(() {
        typeUser = preferences.getString("typeUser")!;
        emailUser = preferences.getString("email")!;
      });
    } catch (e) {
      print(e);
    }

    var res = await http.post(
        Uri.parse(url + "/getJointActivityWithEmailAndAcID"),
        body: {'email': emailUser, 'ac_id': widget.data!.acId!});

    if (mounted) {
      setState(() {
        chkJoin = res.body;
      });
    }
    setDataAlert();
  }

  setDataAlert() async {
    List<AlertActivityModel> allActivityList = [];
    try {
      allActivityList = await getDataAlert(emailUser, widget.data!.acId!);
      dataAlert = allActivityList.first;
      if (mounted) {
        setState(() {
          arTime = dataAlert!.arTime!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // nameUj = context.watch<UjModelProvider>().ujProfile.ujName;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: widget.data != null
            ? Stack(
                children: [
                  _backDetail(),
                  Container(
                    margin: EdgeInsets.only(top: 10.h),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              if (Get.parameters['id'] != null) {
                                Get.offAllNamed("/Home");
                              } else {
                                Navigator.of(context).pop(true);
                              }
                            },
                            icon: Icon(
                              Icons.arrow_back_ios_rounded,
                              color: Colors.red,
                              size: 20.sp,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Clipboard.setData(ClipboardData(
                                  text:
                                      "http://appvhrs.com/DetailActivityPage/" +
                                          widget.data!.acId!));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text("Copy to clipboard"),
                              ));
                            },
                            icon: Icon(
                              Icons.ios_share,
                              color: Colors.red,
                              size: 20.sp,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Align(
                    alignment: const Alignment(1.0, -0.4),
                    child: Container(
                      height: 150.h,
                      margin: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: BoxDecoration(
                        boxShadow: shadowList,
                        borderRadius: BorderRadius.circular(20.r),
                        color: Colors.white,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.data!.acName.toString() + "",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 21.sp,
                                        color: Theme.of(context).canvasColor,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "" + widget.data!.acType!.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 21.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '+' +
                                        widget.data!.acHour!.toString() +
                                        " ชั่วโมงจิตอาสา",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[800],
                                      fontSize: 16.sp,
                                      letterSpacing: 0.7,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.people_alt_outlined,
                                        color: Theme.of(context).canvasColor,
                                        size: 16.sp,
                                      ),
                                      Text(
                                        " " +
                                            countJoin.toString() +
                                            ' / ' +
                                            widget.data!.acAmount!.toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                          letterSpacing: 0.7,
                                          fontSize: 16.sp,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                              SizedBox(height: 2.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Theme.of(context).canvasColor,
                                    size: 18.sp,
                                  ),
                                  SizedBox(
                                    width: 3.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      '' + widget.data!.acLocationName!,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey[800],
                                          letterSpacing: 0.8,
                                          fontSize: 18.sp),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 3,
                                  ),
                                  widget.data!.acLocationLink != null
                                      ? TextButton(
                                          onPressed: _launchURL,
                                          child: Text(
                                            widget.data!.acType == "Online"
                                                ? "Link"
                                                : "แผนที่",
                                            style: TextStyle(
                                                color: Theme.of(context)
                                                    .canvasColor,
                                                fontWeight: FontWeight.bold,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 20.sp),
                                          ),
                                        )
                                      : Container()
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  typeUser != "" ? _showBottom() : Container(),
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ));
  }

  String _Detail() {
    String str = "";
    if (widget.data!.acDetail != null) {
      var arr = widget.data!.acDetail!.split("\n");
      for (String s in arr) {
        str += " " + s;
      }
    }
    return str;
  }

  _launchURL() async {
    String url = widget.data!.acLocationLink! + "";
    try {
      await launch(url,
          forceWebView: false, enableJavaScript: true, forceSafariVC: false);
      // launchUrl(
      //   Uri.parse(url),
      // );
    } catch (e) {
      print(e);
    }

    // else {
    //   log( 'Could not launch $url');
    // }
  }

  _ownActivity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: ListTile(
            leading: Container(
              child: CircleAvatar(
                child: ucModel?.ucImg == null || ucModel?.ucImg == ""
                    ? Image.asset(
                        "assets/images/user.jpg",
                        fit: BoxFit.cover,
                      )
                    : ClipRRect(
                        child: Image.network(
                        '${service.serverPath}/VHRSservice/uploads/' +
                            ucModel!.ucImg!,
                        loadingBuilder: ((context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
                        }),
                        fit: BoxFit.cover,
                        height: 200.h,
                        width: 300.w,
                      )),
                radius: 30.r,
                backgroundColor: Colors.white,
              ),
            ),
            title: Text(
              " โดย ${widget.data?.acUcName ?? ucModel?.ucName ?? ""}",
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor),
            ),
            subtitle: Text(
              'ผู้จัดกิจกรรม',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 16.sp),
            ),
          ),
        ),
      ],
    );
  }

  _dateDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        chkShowAlertIcon()
            ? IconButton(
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingAlertPage(
                        activityModel: widget.data!,
                        emailUser: emailUser,
                      ),
                    ),
                  );
                },
                icon: Icon(
                  Icons.edit_notifications_outlined,
                  color: Colors.red,
                  size: 35.sp,
                ))
            : Container(),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "เริ่ม",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                  fontSize: 16.sp
                  //letterSpacing: 0.7,
                  ),
            ),
            Text(
              formatter.format(widget.data!.acDstart!),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 16.sp
                  //letterSpacing: 0.7,
                  ),
            ),
          ],
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "สิ้นสุด",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  fontSize: 16.sp
                  //letterSpacing: 0.7,
                  ),
            ),
            Text(
              formatter.format(widget.data!.acDend!),
              textAlign: TextAlign.start,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                  fontSize: 16.sp
                  //letterSpacing: 0.7,
                  ),
            ),
          ],
        ),
      ],
    );
  }

  _backDetail() {
    return Positioned.fill(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: widget.data!.acImg == ""
                ? Image.network(
                    service.defult_activity_img,
                    fit: BoxFit.cover,
                    // height: 150.h,
                    // width: 300.w,
                  )
                : Image.network(
                    service.uploads + widget.data!.acImg.toString(),
                    loadingBuilder: ((context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const SizedBox(
                        child: Center(
                            child: CircularProgressIndicator(
                          color: Colors.white,
                        )),
                      );
                    }),
                    fit: BoxFit.cover,
                    filterQuality: FilterQuality.low,
                    // height: 150.h,
                    width: double.infinity,
                  ),
          ),
          Expanded(
            flex: 2,
            child: Container(
              color: Colors.white,
              child: Container(
                margin: EdgeInsets.fromLTRB(10.w, 60.h, 10.w, 70.h),
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        _ownActivity(),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 10.h, horizontal: 10.w),
                          child: _dateDetail(),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 5.h, horizontal: 15.w),
                          child: Text(
                            "รายละเอียด",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).canvasColor,
                              fontSize: 18.sp,
                              letterSpacing: 0.7,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25.w),
                          child: Text(
                            _Detail().trim(),
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                                letterSpacing: 0.7,
                                fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buttonJoin(var child, Color color) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: 60.h,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r), topRight: Radius.circular(20.r)),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25.w),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 50.h,
                  width: 50.w,
                  child: Center(child: child),
                  decoration: BoxDecoration(
                    // color: color,
                    borderRadius: BorderRadius.circular(10.r),
                    // boxShadow: shadowList,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBottom() {
    final now = DateTime.now();
    final deadline = DateTime(widget.data!.acDend!.year,
        widget.data!.acDend!.month, widget.data!.acDend!.day + 3, 23, 59, 59);
    log("deadline : " + now.toString());
    if (typeUser == "UserJoin" &&
        widget.data!.acDstart!.isAfter(now) &&
        chkJoin == "Dont have") {
      return countJoin < widget.data!.acAmount!
          ? _buttonJoin(
              RaisedButton(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100.w),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "เข้าร่วมกิจกรรม",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.sp),
                        ),
                ),
                onPressed: () async {
                  var resUj =
                      await http.post(Uri.parse(url + "/get_ujProfile"), body: {
                    'email': emailUser,
                  });
                  List<UjModel> ujModel = ujModelFromJson(resUj.body);
                  nameUj = ujModel[0].ujName!;
                  setState(() {});

                  if (nameUj == "") {
                    dialogDontJoin(context);
                  } else {
                    setState(() => isLoading = true);
                    bool chk = await popUpSelect(
                        context,
                        "เข้าร่วมกิจกรรมนี้หรือไม่?",
                        "เข้าร่วม",
                        "ยกเลิก",
                        emailUser,
                        widget.data!.acId,
                        widget.data!.acDstart!);
                    if (chk == true) {
                      createPhoneAlert(
                          int.parse(
                              "${widget.data!.acId!.split("_")[1].trim()}1"),
                          widget.data?.acId ?? "",
                          widget.data?.acName ?? "",
                          widget.data?.acLocationName ?? "",
                          widget.data?.acImg ?? "",
                          widget.data!.acDstart!,
                          widget.data!.acDend!,
                          null);
                    }
                    countJoin = await getCountJoin(widget.data!.acId!);
                    setState(() {
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailActivityPage(
                                data: widget.data!,
                              )));
                      isLoading = false;
                    });
                  }
                },
              ),
              Theme.of(context).canvasColor)
          : _buttonJoin(
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.w),
                child: Text(
                  "ผู้เข้าร่วมกิจกรรมครบแล้ว",
                  style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
              Colors.red);
    } else if (typeUser == "UserJoin" &&
        deadline.isAfter(now) &&
        chkJoin == "Have") {
      ///ก่อนหมดเวลาเพิ่มรายละเอียดกิจกรรม
      return _buttonJoin(
          Container(
            child: Row(
              children: [
                RaisedButton(
                  color: Colors.orange,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "ยกเลิกการเข้าร่วม",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ),
                  onPressed: () async {
                    setState(() => isLoading = true);
                    bool chk = await popUpSelect(
                        context,
                        "ยกเลิกการเข้าร่วมกิจกรรมนี้หรือไม่?",
                        "ยกเลิกการเข้าร่วม",
                        "ยกเลิก",
                        emailUser,
                        widget.data!.acId,
                        widget.data!.acDstart!);
                    if (chk == true) {
                      chkJoin = "Dont have";
                      dataAlert = null;
                    }
                    countJoin = await getCountJoin(widget.data!.acId!);
                    setState(() {
                      // checkPreference();
                      isLoading = false;
                      Navigator.of(context).pop();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => DetailActivityPage(
                                data: widget.data!,
                              )));
                    });
                  },
                ),
                SizedBox(
                  width: 10.w,
                ),
                RaisedButton(
                  color: const Color.fromARGB(255, 8, 28, 138),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "เพิ่มรายละเอียด",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ),
                  onPressed: () async {
                    if (widget.data!.acDstart!.isBefore(now)) {
                      var res = await http.post(
                          Uri.parse(service.url + "/getJoinActivity"),
                          body: {
                            "email": emailUser,
                            "ac_id": widget.data!.acId
                          });

                      if (res.statusCode == 200) {
                        listDataJoin = joinActivityModelFromJson(res.body);
                      }
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => AddDetailJoinPage(
                              data: widget.data!,
                              joinActivityModel: listDataJoin[0])));
                    } else {
                      dialogDontAddDetail(context);
                    }
                  },
                ),
              ],
            ),
          ),
          Colors.orange);
    } else if (widget.data!.acDstart!.isBefore(now) && chkJoin == "Dont have") {
      ///หมดเวลาเริ่มต้นกิจกรรม
      if (typeUser == "UserCreate" && widget.data!.acUcEmail == emailUser) {
        return _buttonJoin(
            RaisedButton(
              color: const Color.fromARGB(255, 8, 28, 138),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 100.w),
                child: Text(
                  "ตรวจสอบผู้เข้าร่วม",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.sp),
                ),
              ),
              onPressed: () async {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ManageUjPage(acId: widget.data!.acId.toString())));
              },
            ),
            Colors.orange);
      }
      return _buttonJoin(textOutOfTime(), Colors.red);
    } else if (deadline.isBefore(now) && typeUser == "UserJoin") {
      ///หมดเวลาเพิ่มรายละเอียดกิจกรรม
      return _buttonJoin(textOutOfTime(), Colors.red);
    } else if (typeUser == "UserCreate" &&
        widget.data!.acUcEmail == emailUser &&
        widget.data!.acDstart!.isAfter(now)) {
      ///ก่อนหมดเวลาเริ่มต้นกิจกรรม
      return _buttonJoin(
          Container(
            child: Row(
              children: [
                RaisedButton(
                  color: Colors.orange,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "แก้ไขกิจกรรม",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ),
                  onPressed: () async {
                    context.read<ActivityModelProvider>().activity =
                        widget.data!;
                    Navigator.of(context)
                        .push(MaterialPageRoute(
                            builder: (context) => UpdatePage(role: "Activity")))
                        .then((_) => setState(() {
                              widget.data = Provider.of<ActivityModelProvider>(
                                      context,
                                      listen: false)
                                  .activity;
                            }));
                  },
                ),
                SizedBox(
                  width: 10.w,
                ),
                RaisedButton(
                  color: const Color.fromARGB(255, 8, 28, 138),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5.w),
                    child: Text(
                      "ตรวจสอบผู้เข้าร่วม",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20.sp),
                    ),
                  ),
                  onPressed: () async {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => ManageUjPage(
                              acId: widget.data!.acId.toString(),
                            )));
                  },
                ),
              ],
            ),
          ),
          Colors.orange);
    } else {
      return Container();
    }
  }

  textOutOfTime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 100.w),
      child: Text(
        "หมดเวลาเข้าร่วมกิจกรรม",
        style: TextStyle(
            color: Colors.red, fontWeight: FontWeight.bold, fontSize: 20.sp),
      ),
    );
  }

  // alertClick() async {
  //   showDialog(
  //       barrierDismissible: false,
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           shape: RoundedRectangleBorder(
  //             borderRadius: BorderRadius.all(
  //               Radius.circular(
  //                 20.r,
  //               ),
  //             ),
  //           ),
  //           contentPadding: EdgeInsets.only(top: 10.w, bottom: 10.w),
  //           actionsPadding: EdgeInsets.only(bottom: 10.w),
  //           title: Text(
  //             "การแจ้งเตือน ",
  //             style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
  //           ),
  //           actions: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 Expanded(
  //                   child: TextButton(
  //                     onPressed: () {
  //                       setState(() {
  //                         arTime = dataAlert!.arTime!;
  //                       });
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text(
  //                       'ยกเลิก',
  //                       style: TextStyle(fontSize: 16.sp),
  //                     ),
  //                   ),
  //                 ),
  //                 Expanded(
  //                   child: TextButton(
  //                     onPressed: () async {
  //                       await http.post(
  //                           Uri.parse(url + "/editArTimeAlertActivity"),
  //                           body: {
  //                             "ar_id": dataAlert!.arId!,
  //                             'ar_time': arTime.toString()
  //                           }).then((value) async => {
  //                             if (value.body == 'Success')
  //                               {
  //                                 createPhoneAlert(
  //                                     int.parse(widget.data!.acId!
  //                                         .split("_")[1]
  //                                         .trim()),
  //                                     widget.data?.acName ?? "",
  //                                     widget.data?.acLocationName ?? "",
  //                                     widget.data?.acImg ?? "",
  //                                     widget.data!.acDstart!,
  //                                     widget.data!.acDend!,
  //                                     arTime),
  //                                 dataAlert!.arTime = arTime,
  //                                 setState(() {}),
  //                                 ScaffoldMessenger.of(context).showSnackBar(
  //                                     snackBarWithText(
  //                                         'แก้ไขเวลาแจ้งเตือนสำเร็จ')),
  //                                 Navigator.pop(context)
  //                               }
  //                             else
  //                               {
  //                                 ScaffoldMessenger.of(context).showSnackBar(
  //                                     snackBarWithText('ลองอีกครั้ง')),
  //                               }
  //                             // Future.delayed(const Duration(seconds: 1)),
  //                           });
  //                     },
  //                     child: Text(
  //                       'บันทึก',
  //                       style: TextStyle(fontSize: 16.sp),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ],
  //           content: SizedBox(
  //             height: 155.h,
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               crossAxisAlignment: CrossAxisAlignment.center,
  //               mainAxisSize: MainAxisSize.min,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 30.w),
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         'เวลาเริ่มกิจกรรม : ',
  //                         style: TextStyle(
  //                             fontSize: 15.sp, fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(
  //                         formatter.format(widget.data!.acDstart!),
  //                         style: TextStyle(
  //                             fontSize: 15.sp, fontWeight: FontWeight.normal),
  //                       )
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.only(left: 30.w),
  //                   child: Row(
  //                     children: [
  //                       Text(
  //                         'เวลาแจ้งเตือน :   ',
  //                         style: TextStyle(
  //                             fontSize: 15.sp, fontWeight: FontWeight.bold),
  //                       ),
  //                       Text(
  //                         formatter.format(arTime),
  //                         style: TextStyle(
  //                             fontSize: 15.sp, fontWeight: FontWeight.normal),
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 20.h,
  //                 ),
  //                 SizedBox(
  //                   width: 200.w,
  //                   height: 65.h,
  //                   child: SpinBox(
  //                     min: 1,
  //                     max: 10,
  //                     value: double.parse(widget.data!.acDstart!
  //                         .difference(arTime)
  //                         .inHours
  //                         .toString()),
  //                     onChanged: (value) {
  //                       arTime = widget.data!.acDstart!
  //                           .subtract(Duration(hours: value.toInt()));

  //                       setState(() {});
  //                       Navigator.of(context).pop();
  //                       alertClick();
  //                     },
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   height: 5.h,
  //                 ),
  //                 Text(
  //                   'แจ้งเตือนก่อนการเริ่มกิจกรรม  (ชั่วโมง)',
  //                   style: TextStyle(fontSize: 16.sp, color: Colors.grey),
  //                 )
  //               ],
  //             ),
  //           ),
  //         );
  //       });
  //   setState(() {});
  // }

  bool chkShowAlertIcon() {
    try {
      if (dataAlert != null) {
        if (widget.data!.acDend!.isAfter(DateTime.now())) {
          return true;
        }
      }
    } catch (e) {
      print(e);
    }

    return false;
  }
}
