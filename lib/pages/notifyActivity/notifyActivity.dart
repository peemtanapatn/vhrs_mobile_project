// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/alert_activity_model.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/service_url.dart';
import 'package:vhrs_flutter_project/utils/alertCountNow.dart';

class NotifyActivityPage extends StatefulWidget {
  const NotifyActivityPage({Key? key}) : super(key: key);

  @override
  State<NotifyActivityPage> createState() => _NotifyActivityPageState();
}

class _NotifyActivityPageState extends State<NotifyActivityPage> {
  final DateFormat formatter = DateFormat('HH:mm น. dd MMM yyyy ', 'th');
  String email = "";
  String role = "";

  List<AlertActivityModel> allActivityList = [];
  List<AlertActivityModel> showList = [];

  // Color chkColor = Colors.grey;
  @override
  void initState() {
    getAllActitvity();
    super.initState();
  }

  Future getAllActitvity() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        email = preferences.getString("email")!;
        role = preferences.getString("typeUser")!;
      });
      var res = await http
          .post(Uri.parse(service.url + "/getAlertActivityWithEmail"), body: {
        "email": email,
      });

      if (res.statusCode == 200) {
        showList = [];
        allActivityList = AlertActivityModelFromJson(res.body);
        for (int i = 0; i < allActivityList.length; i++) {
          DateTime currentDate = DateTime.now();

          if (allActivityList[i].arTime!.isBefore(currentDate)) {
            showList.add(allActivityList[i]);
          }
        }
      }
      setState(() {});
    } catch (e) {
      print(e.toString());
      // throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
              "แจ้งเตือนกิจกรรม",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor),
            ),
            centerTitle: true,
            backgroundColor: Colors.white),
        body: allActivityList != []
            ? RefreshIndicator(
                onRefresh: () => getAllActitvity(),
                child: ListView.builder(
                    itemCount: showList.length,
                    padding:
                        EdgeInsets.symmetric(vertical: 5.h, horizontal: 5.w),
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        // selectedTileColor: Colors.red,
                        dense: true,
                        tileColor: Colors.white,
                        leading: showList[index].arStatus == "สำเร็จ"
                            ? Icon(
                                Icons.circle_outlined,
                                color: Theme.of(context).canvasColor,
                                size: 18.sp,
                              )
                            : Icon(
                                Icons.circle_rounded,
                                color: Theme.of(context).canvasColor,
                                size: 18.sp,
                              ),
                        title: Text.rich(
                          TextSpan(
                              text: "${showList[index].acName} ",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold),
                              children: <InlineSpan>[
                                TextSpan(
                                  text:
                                      "(${formatter.format(showList[index].arTime!)})",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.normal),
                                )
                              ]),
                        ),

                        subtitle: Text(
                          formatter.format(showList[index].acDstart!) +
                              " - " +
                              formatter.format(showList[index].acDend!),
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 14.sp,
                          ),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios_rounded,
                          color: Theme.of(context).canvasColor,
                          size: 18.sp,
                        ),
                        onTap: () async {
                          await Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => DetailActivityPage(
                                    data: ActivityModel.fromJson({
                                      "ac_id": showList[index].acId,
                                      "ac_uc_email": showList[index].acUcEmail,
                                      "ac_name": showList[index].acName,
                                      "ac_type": showList[index].acType,
                                      "ac_detail": showList[index].acDetail,
                                      "ac_location_name":
                                          showList[index].acLocationName,
                                      "ac_location_link":
                                          showList[index].acLocationLink,
                                      "ac_dstart":
                                          showList[index].acDstart.toString(),
                                      "ac_dend":
                                          showList[index].acDend.toString(),
                                      "ac_amount":
                                          showList[index].acAmount.toString(),
                                      "ac_hour":
                                          showList[index].acHour.toString(),
                                      "ac_img": showList[index].acImg
                                    }),
                                  )));
                          await http.post(
                              Uri.parse(url + "/updateStatusAlertWithId"),
                              body: {
                                'id': showList[index].arId,
                                "status": "สำเร็จ"
                              });

                          if (mounted) {
                            setState(() {
                              getAllActitvity();
                            });
                            alert = await chckAlertCount();
                          }
                        },
                      );
                    }),
              )
            : const Center(
                child: Text(
                  "ไม่มีการแจ้งเตือน",
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.red),
                ),
              ));
  }
}
