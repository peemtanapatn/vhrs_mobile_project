import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget LogoAppbar(BuildContext context) {
  return Row(
    children: [
      Image(
          image: new ExactAssetImage("assets/images/GroupLOGOnoText.jpg"),
          height: 50.h,
          width: 50.w,
          alignment: FractionalOffset.center),
      Text(
        "  VHRS ",
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
      ),
    ],
  );
}
