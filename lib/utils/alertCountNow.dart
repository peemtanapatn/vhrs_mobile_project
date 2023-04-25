// ignore: file_names

import 'package:vhrs_flutter_project/models/alert_activity_model.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
// ignore_for_file: file_names

import 'package:shared_preferences/shared_preferences.dart';

int alert = 0;
Future<int> chckAlertCount() async {
  int c = 0;
  try {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    String email = preferences.getString("email")!;
    // String  typeUser = preferences.getString("typeUser")!;

    var res = await http
        .post(Uri.parse(service.url + "/getAlertActivityWithEmail"), body: {
      "email": email,
    });
    List<AlertActivityModel> allActivityList = [];
    if (res.statusCode == 200) {
      allActivityList = AlertActivityModelFromJson(res.body);
      for (int i = 0; i < allActivityList.length; i++) {
        DateTime currentDate = new DateTime.now();

        if (allActivityList[i].arTime!.isBefore(currentDate) &&
            allActivityList[i].arStatus == "รอ") {
          c = c + 1;
        }
      }
    }
  } catch (e) {
    print(e.toString());
    // throw e;
  }
  return c;
}
