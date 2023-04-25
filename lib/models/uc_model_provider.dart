import 'package:flutter/foundation.dart';

class UcModelProvider extends ChangeNotifier {
  UcProfile _ucProfile = UcProfile();
  UcProfile get ucProfile => _ucProfile;
  set ucProfile(UcProfile profile) {
    _ucProfile = profile;
    notifyListeners();
  }
}

class UcProfile {
  String ucEmail = "";
  String ucName = "";
  String ucStatus = "";
  String ucJob = "";
  String ucImg = "";
  String ucPhone = "";
  String ucImgconfirmjob = "";
}
