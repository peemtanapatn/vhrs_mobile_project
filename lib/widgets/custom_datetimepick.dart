import 'package:flutter/material.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<void> customshowDateRangePicker(
    Function(DateTimeRange? newselect) newselectDate,
    BuildContext context,
    DatePickerEntryMode mode) async {
  await showDateRangePicker(
          context: context,
          initialEntryMode: mode,
          builder: (context, child) {
            return Theme(
              data: ThemeData(
                fontFamily: 'Prompt',
              ).copyWith(
                primaryColor: Color.fromARGB(255, 8, 28, 138),
                colorScheme: ColorScheme.light(
                  primary: Color.fromARGB(
                      255, 8, 28, 138), // header background color
                  onPrimary: Colors.white,
                  surface: Colors.black, // header text color
                  onSurface: Color.fromARGB(255, 8, 28, 138), // body text color
                ),
              ),
              child: child!,
            );
          },
          locale: const Locale('en', 'TH'),
          errorFormatText: 'dd/mm/yyyy',
          fieldEndHintText: 'dd/mm/yyyy',
          fieldStartHintText: 'dd/mm/yyyy',
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          cancelText: "ยกเลิก",
          confirmText: "ตกลง",
          saveText: "ตกลง",
          fieldEndLabelText: "สิ้นสุด",
          fieldStartLabelText: "เริ่ม",
          helpText: "เลือกวันที่")
      .then((newselect) => {
            if (newselect != null)
              {newselectDate(newselect)}
            else
              {newselectDate(null)}
          });
}
