// To parse this JSON data, do
//
//     final joinActivityModel = joinActivityModelFromJson(jsonString);

// ignore_for_file: file_names

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/service_url.dart';

List<JoinActivityModel> joinActivityModelFromJson(String str) =>
    List<JoinActivityModel>.from(
        json.decode(str).map((x) => JoinActivityModel.fromJson(x)));

String joinActivityModelToJson(List<JoinActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

getUjJoin(String id) async {
  List<JoinActivityModel> joins = [];
  try {
    var res = await http.post(Uri.parse(url + "/getJointActivityWithAcID"),
        body: {'ac_id': id});
    if (res.body != "Dont have") {
      joins = joinActivityModelFromJson(res.body);
    } else {
      joins = [];
    }
  } catch (e) {
    // throw (e);
    // print(e);
  }
  return joins;
}

getCountJoin(String id) async {
  List<JoinActivityModel> joins = await getUjJoin(id);
  if (joins == []) {
    return 0;
  } else {
    return joins.length;
  }
}

class JoinActivityModel {
  JoinActivityModel({
    this.jaId,
    this.jaUjEmail,
    this.jaAcId,
    this.jaImg,
    this.jaDetail,
    this.jaStatus,
  });

  String? jaId;
  String? jaUjEmail;
  String? jaAcId;
  String? jaImg;
  String? jaDetail;
  String? jaStatus;

  factory JoinActivityModel.fromJson(Map<String, dynamic> json) =>
      JoinActivityModel(
        jaId: json["ja_id"],
        jaUjEmail: json["ja_uj_email"],
        jaAcId: json["ja_ac_id"],
        jaImg: json["ja_img"],
        jaDetail: json["ja_detail"],
        jaStatus: json["ja_status"],
      );

  Map<String, dynamic> toJson() => {
        "ja_id": jaId,
        "ja_uj_email": jaUjEmail,
        "ja_ac_id": jaAcId,
        "ja_img": jaImg,
        "ja_detail": jaDetail,
        "ja_status": jaStatus,
      };
}
