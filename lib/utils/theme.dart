import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

themeDateTimePicker(BuildContext context, Widget? child) {
  return Theme(
    data: ThemeData(
      fontFamily: 'Prompt',
    ).copyWith(
      primaryColor: const Color.fromARGB(255, 8, 28, 138),
      colorScheme: const ColorScheme.light(
        primary: Color.fromARGB(255, 8, 28, 138), // header background color
        onPrimary: Colors.white,
        surface: Colors.white, // header text color
        onSurface: Color.fromARGB(255, 8, 28, 138), // body text color
      ),
    ),
    child: child!,
  );
}

List<BoxShadow> shadowList = [
  BoxShadow(color: Colors.grey, blurRadius: 24.r, offset: const Offset(0, 1))
];

theme_InputDecoration(
    IconData? prefixIcon, suffixIcon, String hint, Color color) {
  return InputDecoration(
    prefixIcon: Icon(
      prefixIcon,
      size: 20.sp,
      color: color,
    ),
    suffixIcon: suffixIcon == null
        ? Container()
        : Icon(
            suffixIcon,
            size: 20.sp,
            color: color,
          ),
    hintText: hint,
    label: Text(
      hint,
      style: TextStyle(
        fontSize: 18.sp,
        color: color,
      ),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(20.r),
      borderSide: BorderSide(
        color: color,
      ),
    ),
  );
}

class appTheme {
  ThemeData buildTheme() {
    Color darkBlue = const Color.fromARGB(255, 8, 28, 138);
    Color lightGrey = const Color.fromARGB(255, 164, 164, 164);
    Color darkGrey = const Color.fromARGB(255, 119, 124, 135);
    Color w = Colors.white;

    return ThemeData(
        fontFamily: 'Prompt',
        canvasColor: darkBlue,
        primaryColor: w,
        secondaryHeaderColor: darkBlue,
        hintColor: lightGrey,
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.r),
              borderSide: BorderSide(color: lightGrey)),
          // focusedBorder: OutlineInputBorder(
          //     borderRadius: BorderRadius.circular(20.0),
          //     borderSide: BorderSide(color: _darkBlue))
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.blueGrey.shade200,
              width: 1.w,
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              width: 2.w,
              color: Colors.blue.withOpacity(0.8),
            ),
            borderRadius: BorderRadius.circular(20.r),
          ),

          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.red,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: darkBlue,
          padding: EdgeInsets.symmetric(
            horizontal: 20.w,
          ),
          minWidth: 200.w,
          height: 60.h,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
        ),
        textTheme: TextTheme(
          button: TextStyle(color: darkBlue),
          bodyText1: TextStyle(color: darkBlue),
        ),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: lightGrey));
  }
}
