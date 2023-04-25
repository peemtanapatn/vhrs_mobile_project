// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/joinActivity_model.dart';
import 'package:vhrs_flutter_project/models/join_activity_model.dart';
import 'package:vhrs_flutter_project/pages/addDetailJoin/addDetailJoin.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/widgets/container.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';

class DetailJoinPage extends StatefulWidget {
  JoinAndActivityModel joinAndActivityModel;
  DetailJoinPage({Key? key, required this.joinAndActivityModel})
      : super(key: key);

  @override
  State<DetailJoinPage> createState() => _DetailJoinPageState();
}

class _DetailJoinPageState extends State<DetailJoinPage> {
  ActivityModel? activityModel;
  final DateFormat formatter = DateFormat('HH:mm น. dd MMM yyyy ', 'th');
  final _scrollController = ScrollController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setData();
  }

  Future<void> setData() async {
    var res = await http.post(
        Uri.parse(service.url + "/getJointActivityWithEmailAndAcID"),
        body: {
          "ac_id": widget.joinAndActivityModel.acId,
          "email": widget.joinAndActivityModel.jaUjEmail,
        });
    print(res.body);
    if (res.statusCode == 200) {
      if (res.body == "Have") {
        activityModel = ActivityModel.fromJson({
          "ac_id": widget.joinAndActivityModel.acId,
          "ac_uc_email": widget.joinAndActivityModel.acUcEmail,
          "ac_name": widget.joinAndActivityModel.acName,
          "ac_type": widget.joinAndActivityModel.acType,
          "ac_detail": widget.joinAndActivityModel.acDetail,
          "ac_location_name": widget.joinAndActivityModel.acLocationName,
          "ac_location_link": widget.joinAndActivityModel.acLocationLink,
          "ac_dstart": widget.joinAndActivityModel.acDstart.toString(),
          "ac_dend": widget.joinAndActivityModel.acDend.toString(),
          "ac_amount": widget.joinAndActivityModel.acAmount.toString(),
          "ac_hour": widget.joinAndActivityModel.acHour.toString(),
          "ac_img": widget.joinAndActivityModel.acImg
        });
        setState(() {});
      } else {
        activityModel = null;
      }
    } else {
      activityModel = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop(true);
            }),
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.white,
        title: Text(
          "กิจกรรม " + widget.joinAndActivityModel.acName!,
          style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        color: Theme.of(context).canvasColor,
        child: RefreshIndicator(
          onRefresh: () => setData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: activityModel == null
                  ? [
                      Center(
                          child: Text(
                        "ไม่มีข้อมูลการเข้าร่วมกิจกรรมนี้",
                        style: TextStyle(fontSize: 20.sp, color: Colors.red),
                      ))
                    ]
                  : [
                      headLineText("รายละเอียดกิจกรรม"),
                      _detail("Activity"),
                      headLineText("รายละเอียดเพิ่มเติม"),
                      _detail("Join"),
                    ],
            ),
          ),
        ),
      ),
    );
  }

  headLineText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w),
      child: Container(
        width: double.maxFinite,
        height: 30.h,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.r),
        ),
        child: Center(
            child: Text(text,
                style: TextStyle(
                    fontSize: 22.sp,
                    color: Theme.of(context).canvasColor,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }

  _detail(String role) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 5.h),
      child: appContainer(
        child: Column(children: [
          role == "Join"
              ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _textDetail("ภาพการเข้าร่วม"),
                      _textDetail("รายละเอียดการเข้าร่วม"),
                    ],
                  ),
                )
              : Container(),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: role == "Activity"
                  ? [
                      _showImgActivity(
                          '${service.serverPath}/VHRSservice/uploads/' +
                              activityModel!.acImg!,
                          activityModel!.acImg == "" ||
                              activityModel!.acImg == null,
                          "Activity"),
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.w),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _textDetail(
                                  "กิจกรรม : " + activityModel!.acName!),
                              _textDetail("จำนวน : " +
                                  activityModel!.acHour!.toString() +
                                  " ชั่วโมง"),
                              _textDetail("สถานที่ : " +
                                  activityModel!.acLocationName!.toString()),
                              _textDetail("วันเริ่ม : " +
                                  formatter.format(activityModel!.acDstart!)),
                              _textDetail("วันสิ้นสุด : " +
                                  formatter.format(activityModel!.acDend!)),
                              _button('ดูรายละเอียด'),
                            ],
                          ),
                        ),
                      )
                    ]
                  : [
                      _showImgActivity(
                          '${service.serverPath}/VHRSservice/uploads/' +
                              widget.joinAndActivityModel.jaImg!,
                          widget.joinAndActivityModel.jaImg == "" ||
                              widget.joinAndActivityModel.jaImg == null,
                          "Join"),
                      Flexible(
                          child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 20.h,
                        ),
                        child: SizedBox(
                          height: 180.h,
                          child: widget.joinAndActivityModel.jaDetail == "" ||
                                  widget.joinAndActivityModel.jaDetail == null
                              ? const Center(
                                  child: Text("ไม่มีข้อมูลรายละเอียด",
                                      style: TextStyle(
                                        color: Colors.red,
                                      )),
                                )
                              : Scrollbar(
                                  thumbVisibility: true,
                                  controller: _scrollController,
                                  child: SingleChildScrollView(
                                    controller: _scrollController,
                                    scrollDirection: Axis.vertical,
                                    child: Text(
                                        widget.joinAndActivityModel.jaDetail!,
                                        softWrap: true,
                                        style: TextStyle(fontSize: 14.sp)),
                                  ),
                                ),
                        ),
                      ))
                    ]),
          role == "Join" ? _button("เพิ่มรายละเอียด") : Container(),
        ]),
      ),
    );
  }

  _showImgActivity(String netImg, bool chk, String role) {
    return Expanded(
      flex: 1,
      child: chk
          ? Container(
              alignment: Alignment.centerLeft,
              child: role == "Join"
                  ? Padding(
                      padding: EdgeInsets.only(left: 26.w),
                      child: const Text("ไม่มีข้อมูลภาพ",
                          style: TextStyle(
                            color: Colors.red,
                          )),
                    )
                  : Image.asset(
                      "assets/images/Activity.png",
                      fit: BoxFit.cover,
                      height: 150.h,
                      width: 200.w,
                    ),
            )
          : Image.network(
              netImg,
              loadingBuilder: ((context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(child: CircularProgressIndicator());
              }),
              fit: BoxFit.cover,
              height: 150.h,
              width: 200.w,
            ),
    );
  }

  _textDetail(String s) {
    return Text(
      s,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).canvasColor,
        fontSize: 16.sp,
      ),
    );
  }

  _button(String text) {
    return ButtonBar(
      alignment: MainAxisAlignment.center,
      children: [
        FlatButton(
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          minWidth: 200.w,
          height: 40.h,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
          splashColor: Colors.red,
          textColor: Colors.white,
          color: Theme.of(context).canvasColor,
          onPressed: () async {
            if (text == 'ดูรายละเอียด') {
              await Navigator.of(context)
                  .push(MaterialPageRoute(
                      builder: (context) => DetailActivityPage(
                            data: activityModel!,
                          )))
                  .then((value) => {
                        print(value),
                        setData(),
                      });
            } else if (text == "เพิ่มรายละเอียด") {
              final now = DateTime.now();
              if (activityModel!.acDstart!.isBefore(now)) {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => AddDetailJoinPage(
                        data: activityModel!,
                        joinActivityModel: JoinActivityModel.fromJson({
                          'ja_id': widget.joinAndActivityModel.jaId,
                          'ja_uj_email': widget.joinAndActivityModel.jaUjEmail,
                          'ja_ac_id': widget.joinAndActivityModel.acId,
                          'ja_img': widget.joinAndActivityModel.jaImg,
                          'ja_detail': widget.joinAndActivityModel.jaDetail,
                          'ja_status': widget.joinAndActivityModel.jaStatus,
                        }))));
              } else {
                dialogDontAddDetail(context);
              }
            }
          },
          child: Text(
            text,
            style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
