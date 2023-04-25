// To parse this JSON data, do
//
//     final ujModel = ujModelFromJson(jsonString);

import 'dart:convert';

List<UjModel> ujModelFromJson(String str) =>
    List<UjModel>.from(json.decode(str).map((x) => UjModel.fromJson(x)));

String ujModelToJson(List<UjModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class UjModel {
  UjModel({
    this.ujEmail,
    this.ujPassword,
    this.ujIdstd,
    this.ujName,
    this.ujImg,
    this.ujPhone,
    this.ujFaculty,
    this.ujMajor,
  });

  String? ujEmail;
  String? ujPassword;
  String? ujIdstd;
  String? ujName;
  String? ujImg;
  String? ujPhone;
  String? ujFaculty;
  String? ujMajor;

  factory UjModel.fromJson(Map<String, dynamic> json) => UjModel(
        ujEmail: json["uj_email"],
        ujPassword: json["uj_password"],
        ujIdstd: json["uj_idstd"],
        ujName: json["uj_name"],
        ujImg: json["uj_img"],
        ujPhone: json["uj_phone"],
        ujFaculty: json["uj_faculty"],
        ujMajor: json["uj_major"],
      );

  Map<String, dynamic> toJson() => {
        "uj_email": ujEmail,
        "uj_password": ujPassword,
        "uj_idstd": ujIdstd,
        "uj_name": ujName,
        "uj_img": ujImg,
        "uj_phone": ujPhone,
        "uj_faculty": ujFaculty,
        "uj_major": ujMajor,
      };
}

// To parse this JSON data, do
//
//     final userJoinModel = userJoinModelFromJson(jsonString);

