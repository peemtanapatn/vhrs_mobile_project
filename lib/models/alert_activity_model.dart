import 'dart:convert';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vhrs_flutter_project/services/controller.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;

List<AlertActivityModel> AlertActivityModelFromJson(String str) =>
    List<AlertActivityModel>.from(
        json.decode(str).map((x) => AlertActivityModel.fromJson(x)));

String AlertActivityModelToJson(List<AlertActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

addAlertActivity(String id, String email, String acid, String artime) async {
  await http.post(Uri.parse(service.url + "/addAlertActivity"),
      body: {"id": id, "email": email, "ac_id": acid, 'ar_time': artime});
}

delAlertActivity(String id) async {
  await http
      .post(Uri.parse(service.url + "/delAlertActivity"), body: {"id": id});
}

List<AlertActivityModel> sortAlertActivity(List<AlertActivityModel> results) {
  List<AlertActivityModel> _list = [];
  final DateTime now = DateTime.now();

  try {
    _list = results.where((data) => data.arTime!.isBefore(now)).toList();
    results = results.where((data) => data.arTime!.isAfter(now)).toList();
    results.sort((a, b) {
      return a.arTime!.compareTo(b.arTime!);
    });
    _list.insertAll(0, results);
  } catch (e) {
    print(e);
  }

  return _list;
}

createPhoneAlert(
  int id,
  String acId,
  String acname,
  String location,
  String img,
  DateTime start,
  DateTime end,
  DateTime? arTime,
) async {
  final _controller = Get.find<Controller>();
  final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm', 'th');
  String _start = formatter.format(start);
  String _end = formatter.format(end);
  await _controller.createNotify(
      id,
      acId,
      "กิจกรรม : $acname ",
      "เริ่ม $_start น. ถึง $_end น. " "\n" " สถานที่ : $location",
      img,
      arTime ?? start);
}

Future<List<AlertActivityModel>> getDataAlert(
    String email, String? acId) async {
  List<AlertActivityModel> allActivityList = [];
  try {
    var res = await http
        .post(Uri.parse(service.url + "/getAlertActivityWithEmail"), body: {
      "email": email,
    });

    if (res.statusCode == 200) {
      if (res.body != 'Dont have') {
        allActivityList = AlertActivityModelFromJson(res.body);
        allActivityList =
            allActivityList.where((element) => element.acId == acId).toList();
      }
    }
  } catch (e) {
    print(e);
  }
  return allActivityList;
}

class AlertActivityModel {
  AlertActivityModel({
    this.arId,
    this.arEmail,
    this.arStatus,
    this.arTime,
    this.acId,
    this.acUcEmail,
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

  String? arId;
  String? arEmail;
  String? arStatus;
  DateTime? arTime;
  String? acId;
  String? acUcEmail;
  String? acName;
  String? acType;
  String? acDetail;
  String? acLocationName;
  String? acLocationLink;
  DateTime? acDstart;
  DateTime? acDend;
  int? acAmount;
  int? acHour;
  String? acImg;

  factory AlertActivityModel.fromJson(Map<String, dynamic> json) =>
      AlertActivityModel(
        arId: json["ar_id"],
        arEmail: json["ar_email"],
        arStatus: json["ar_status"],
        arTime:
            json["ar_time"] == null ? null : DateTime.parse(json["ar_time"]),
        acId: json["ac_id"],
        acUcEmail: json["ac_uc_email"],
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
        "ar_id": arId,
        "ar_email": arEmail,
        "ar_status": arStatus,
        "ar_time": arTime,
        "ac_id": acId,
        "ac_uc_email": acUcEmail,
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
