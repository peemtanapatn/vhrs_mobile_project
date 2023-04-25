// To parse this JSON data, do
//
//     final ucModel = ucModelFromJson(jsonString);

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/services/service_url.dart';

List<UcModel> ucModelFromJson(String str) =>
    List<UcModel>.from(json.decode(str).map((x) => UcModel.fromJson(x)));

String ucModelToJson(List<UcModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

Future<UcModel?> getUcName(String email) async {
  List<UcModel>? ucModel;
  try {
    var res = await http
        .post(Uri.parse(url + "/get_ucProfile"), body: {'email': email});
    ucModel = ucModelFromJson(res.body);
    return ucModel[0];
  } catch (e) {
    return null;
  }
}

class UcModel {
  UcModel({
    this.ucEmail,
    this.ucPassword,
    this.ucName,
    this.ucJob,
    this.ucPhone,
    this.ucStatus,
    this.ucImg,
    this.ucImgconfirmjob,
  });

  String? ucEmail;
  String? ucPassword;
  String? ucName;
  String? ucJob;
  String? ucPhone;
  String? ucStatus;
  String? ucImg;
  String? ucImgconfirmjob;

  factory UcModel.fromJson(Map<String, dynamic> json) => UcModel(
        ucEmail: json["uc_email"] == null ? null : json["uc_email"],
        ucPassword: json["uc_password"] == null ? null : json["uc_password"],
        ucName: json["uc_name"] == null ? null : json["uc_name"],
        ucJob: json["uc_job"] == null ? null : json["uc_job"],
        ucPhone: json["uc_phone"] == null ? null : json["uc_phone"],
        ucStatus: json["uc_status"] == null ? null : json["uc_status"],
        ucImg: json["uc_img"] == null ? null : json["uc_img"],
        ucImgconfirmjob:
            json["uc_imgconfirmjob"] == null ? null : json["uc_imgconfirmjob"],
      );

  Map<String, dynamic> toJson() => {
        "uc_email": ucEmail == null ? null : ucEmail,
        "uc_password": ucPassword == null ? null : ucPassword,
        "uc_name": ucName == null ? null : ucName,
        "uc_job": ucJob == null ? null : ucJob,
        "uc_phone": ucPhone == null ? null : ucPhone,
        "uc_status": ucStatus == null ? null : ucStatus,
        "uc_img": ucImg == null ? null : ucImg,
        "uc_imgconfirmjob": ucImgconfirmjob == null ? null : ucImgconfirmjob,
      };
}
