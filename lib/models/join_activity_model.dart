import 'dart:convert';

List<JoinAndActivityModel> JoinAndActivityModelFromJson(String str) =>
    List<JoinAndActivityModel>.from(
        json.decode(str).map((x) => JoinAndActivityModel.fromJson(x)));

String JoinAndActivityModelToJson(List<JoinAndActivityModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class JoinAndActivityModel {
  JoinAndActivityModel({
    this.jaId,
    this.jaUjEmail,
    this.jaImg,
    this.jaDetail,
    this.jaStatus,
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

  String? jaId;
  String? jaUjEmail;
  String? jaImg;
  String? jaDetail;
  String? jaStatus;
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

  factory JoinAndActivityModel.fromJson(Map<String, dynamic> json) =>
      JoinAndActivityModel(
        jaId: json["ja_id"],
        jaUjEmail: json["ja_uj_email"],
        jaImg: json["ja_img"],
        jaDetail: json["ja_detail"],
        jaStatus: json["ja_status"],
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
        "ja_id": jaId,
        "ja_uj_email": jaUjEmail,
        "ja_img": jaImg,
        "ja_detail": jaDetail,
        "ja_status": jaStatus,
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
