// // ignore_for_file: file_names

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:vhrs_flutter_project/widgets/listActivity.dart';

// class DatePickRange extends StatefulWidget {
//   ListActivity listActivity;
//   DatePickRange({Key? key, required this.listActivity}) : super(key: key);

//   @override
//   State<DatePickRange> createState() => _DatePickRangeState();
// }

// class _DatePickRangeState extends State<DatePickRange> {
//   final DateTime now = DateTime.now();
//   final DateFormat formatter = DateFormat('dd MMM yyyy', 'th');
//   @override
//   Widget build(BuildContext context) {
//     return IconButton(
//         onPressed: () async {
//           await showDateRangePicker(
//             context: context,
//             firstDate: DateTime(2000),
//             lastDate: DateTime(2100),
//             builder: (context, child) => _theme(child),
//             cancelText: "ยกเลิก",
//             confirmText: "ตกลง",
//             // fieldStartHintText: "เริ่ม",
//             // fieldEndHintText: "สิ้นสุด",
//             fieldEndLabelText: "สิ้นสุด",
//             fieldStartLabelText: "เริ่ม",
//             helpText: "เลือกช่วงวันที่"
            

//           ).then((newselect) => {
//                 if (newselect != null)
//                   {
//                     widget.listActivity.startDate = newselect.start,
//                     widget.listActivity.endDate = newselect.end,
//                     widget.listActivity.searchController.text =
//                         formatter.format(newselect.start) +
//                             " ถึง " +
//                             formatter.format(newselect.end)
//                   }
//               });
//         },
//         icon: const Icon(Icons.calendar_today_outlined, color: Colors.white));
//   }

//   _theme(child) {
//     return Theme(
//         data: ThemeData().copyWith(
//           colorScheme: ColorScheme.light(
//             primary: Theme.of(context).canvasColor, // header background color
//             onPrimary: Colors.red,
//             surface: Colors.black, // header text color
//             onSurface: Theme.of(context).canvasColor, // body text color
//           ),
//           textButtonTheme: TextButtonThemeData(
//             style: TextButton.styleFrom(
//               primary: Colors.red, // button text color
//             ),
//           ),
//         ),
//         child: child!);
//   }
// }
