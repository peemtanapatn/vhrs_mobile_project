// To parse this JSON data, do
//
//     final ujAndJoinActivityModel = ujAndJoinActivityModelFromJson(jsonString);

import 'dart:convert';

import 'package:vhrs_flutter_project/services/service_url.dart';

List<UjAndJoinActivityModel> ujAndJoinActivityModelFromJson(String str) =>
    List<UjAndJoinActivityModel>.from(
        json.decode(str).map((x) => UjAndJoinActivityModel.fromJson(x)));

String ujAndJoinActivityModelToJson(List<UjAndJoinActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UjAndJoinActivityModel {
  UjAndJoinActivityModel({
    this.jaId,
    this.jaUjEmail,
    this.jaAcId,
    this.jaImg,
    this.jaDetail,
    this.jaStatus,
    this.ujName,
    this.ujPhone,
    this.ujFaculty,
    this.ujMajor,
    this.ujImg,
    this.ujIdstd,
    // this.isSelected
  });

  String? jaId;
  String? jaUjEmail;
  String? jaAcId;
  String? jaImg;
  String? jaDetail;
  String? jaStatus;
  String? ujName;
  String? ujPhone;
  String? ujFaculty;
  String? ujMajor;
  String? ujImg;
  String? ujIdstd;
  // bool? isSelected = false;

  factory UjAndJoinActivityModel.fromJson(Map<String, dynamic> json) =>
      UjAndJoinActivityModel(
        jaId: json["ja_id"],
        jaUjEmail: json["ja_uj_email"],
        jaAcId: json["ja_ac_id"],
        jaImg: json["ja_img"],
        jaDetail: json["ja_detail"],
        jaStatus: json["ja_status"],
        ujName: json["uj_name"],
        ujPhone: json["uj_phone"],
        ujFaculty: json["uj_faculty"],
        ujMajor: json["uj_major"],
        ujImg: json["uj_img"],
        ujIdstd: json["uj_idstd"],
      );

  Map<String, dynamic> toJson() => {
        "ja_id": jaId,
        "ja_uj_email": jaUjEmail,
        "ja_ac_id": jaAcId,
        "ja_img": jaImg,
        "ja_detail": jaDetail,
        "ja_status": jaStatus,
        "uj_name": ujName,
        "uj_phone": ujPhone,
        "uj_faculty": ujFaculty,
        "uj_major": ujMajor,
        "uj_img": ujImg,
        "uj_idstd": ujIdstd,
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UjAndJoinActivityModel &&
          runtimeType == other.runtimeType &&
          jaId == other.jaId;

  @override
  int get hashCode => jaId.hashCode;
}
