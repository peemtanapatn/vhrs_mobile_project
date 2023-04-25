import 'package:flutter/foundation.dart';

class UjModelProvider extends ChangeNotifier {
  UjProfile _ujProfile = UjProfile();
  UjProfile get ujProfile => _ujProfile;
  set ujProfile(UjProfile profile) {
    _ujProfile = profile;
    notifyListeners();
  }
}

class UjProfile {
  String ujEmail = "";
  String ujIdstd = "";
  String ujName = "";
  String ujImg = "";
  String ujPhone = "";
  String ujFaculty = "";
  String ujMajor = "";
}
