import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:vhrs_flutter_project/pages/login/localwidgets/formLogin.dart';
import 'package:vhrs_flutter_project/widgets/container.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "เข้าสู่ระบบ",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 45.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  LogInForm()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
