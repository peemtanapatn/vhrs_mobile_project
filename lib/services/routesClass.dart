// ignore_for_file: file_names

import 'package:get/get.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/splash.dart';
import 'package:vhrs_flutter_project/widgets/bottombar.dart';

class RoutesClass {
  static String home = "/";
  static String detailAcPage = "/DetailActivityPage/:id";
  static String bottomBar = "/Home";

  String getHomeRote() => home;

  static List<GetPage> routes = [
    GetPage(page: () => Splash(), name: home),
    GetPage(page: () => BottomBar(), name: bottomBar),
    GetPage(
        page: () => DetailActivityPage(
              data: null,
            ),
        name: detailAcPage),
  ];
}
