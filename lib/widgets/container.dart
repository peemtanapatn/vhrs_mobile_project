import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class appContainer extends StatelessWidget {
  final Widget child;

  const appContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical:20.h,horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.2),
            blurRadius: 10,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: child,
    );
  }
}
