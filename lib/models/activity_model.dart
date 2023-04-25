// To parse this JSON data, do
//
//     final activityModel = activityModelFromJson(jsonString);

import 'dart:convert';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:vhrs_flutter_project/models/alert_activity_model.dart';
import 'package:vhrs_flutter_project/services/service_url.dart';

import 'package:http/http.dart' as http;

List<ActivityModel> activityModelFromJson(String str) =>
    List<ActivityModel>.from(
        json.decode(str).map((x) => ActivityModel.fromJson(x)));

String activityModelToJson(List<ActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

List<dynamic> sortActivity(List<dynamic> results) {
  List<dynamic> _list = [];
  final DateTime now = DateTime.now();

  try {
    _list = results.where((data) => data.acDend!.isBefore(now)).toList();
    results = results.where((data) => data.acDend!.isAfter(now)).toList();
    results.sort((a, b) {
      return a.acDend!.compareTo(b.acDend!);
    });
    _list.insertAll(0, results);
  } catch (e) {
    print(e);
  }

  return _list;
}

Future<String> delActivity(String id) async {
  try {
    var res =
        await http.post(Uri.parse(url + "/delActivity"), body: {'id': id});
    return res.body;
  } catch (e) {
    return e.toString();
  }
}

joinActivity(String emailUser, String? acId, BuildContext context, String str,
    DateTime acTime) async {
  String statusCode;

  Map<String, String>? map, mapAlert;
  String join = "", alert = "";

  if (str == "ยกเลิกการเข้าร่วม") {
    join = "/delJoinActivity";
    map = {
      'id': acId! + "_" + emailUser,
    };
    alert = "/delAlertActivity";
    List<AlertActivityModel> listAlertModel =
        await getDataAlert(emailUser, acId);
    List<String> array = [];
    for (var element in listAlertModel) {
      array.add(element.arId!.trim());
    }

    String str = array
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll(' ', '');
    print(str);
    mapAlert = {
      'id': str,
    };

    for (int i = 1; i <= listAlertModel.length; i++) {
      await AwesomeNotifications()
          .cancel(int.parse("${acId.split("_")[1].trim()}$i"));
    }
  } else if (str == "เข้าร่วม") {
    join = "/addJoinActivity";
    map = {
      'id': acId! + "_" + emailUser,
      'uj_email': emailUser,
      'ac_id': acId,
    };

    alert = "/addAlertActivity";
    mapAlert = {
      'id': "ar_1_" + acId + "_" + emailUser,
      'email': emailUser,
      'ac_id': acId,
      'ar_time': acTime.toString(),
    };
  }
  await http.post(Uri.parse(url + join), body: map).then((value) async => {
        statusCode = value.statusCode.toString(),
        await http
            .post(Uri.parse(url + alert), body: mapAlert)
            .then((value) => {
                  statusCode = value.statusCode.toString(),
                  print(statusCode),
                })
      });
}

class ActivityModelProvider extends ChangeNotifier {
  ActivityModel _activityModel = ActivityModel();
  ActivityModel get activity => _activityModel;
  set activity(ActivityModel data) {
    _activityModel = data;
    notifyListeners();
  }
}

class ActivityModel {
  ActivityModel({
    this.acId,
    this.acUcEmail,
    this.acUcName,
    this.acName,
    this.acType,
    this.acDetail,
    this.acLocationName,
    this.acLocationLink,
    this.acDstart,
    this.acDend,
    this.acAmount,
    this.acHour,
    this.acImg,
  });

  String? acId;
  String? acUcEmail;
  String? acUcName;
  String? acName;
  String? acType;
  String? acDetail;
  String? acLocationName;
  String? acLocationLink;
  DateTime? acDstart;
  DateTime? acDend;
  int? acAmount;
  int? acHour;
  int countJoin = 0;
  String? acImg;

  factory ActivityModel.fromJson(Map<String, dynamic> json) => ActivityModel(
        acId: json["ac_id"],
        acUcEmail: json["ac_uc_email"],
        acUcName: json["uc_name"],
        acName: json["ac_name"],
        acType: json["ac_type"],
        acDetail: json["ac_detail"],
        acLocationName: json["ac_location_name"],
        acLocationLink: json["ac_location_link"],
        acDstart: json["ac_dstart"] == null
            ? null
            : DateTime.parse(json["ac_dstart"]),
        acDend:
            json["ac_dend"] == null ? null : DateTime.parse(json["ac_dend"]),
        acAmount:
            json["ac_amount"] == null ? null : int.parse(json["ac_amount"]),
        acHour: json["ac_hour"] == null ? null : int.parse(json["ac_hour"]),
        acImg: json["ac_img"],
      );

  Map<String, dynamic> toJson() => {
        "ac_id": acId,
        "ac_uc_email": acUcEmail,
        "uc_name": acUcName,
        "ac_name": acName,
        "ac_type": acType,
        "ac_detail": acDetail,
        "ac_location_name": acLocationName,
        "ac_location_link": acLocationLink,
        "ac_dstart": acDstart,
        "ac_dend": acDend,
        "ac_amount": acAmount,
        "ac_hour": acHour,
        "ac_img": acImg,
      };
}
