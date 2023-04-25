// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/pages/update/update.dart';

snackBarWithText(String text) {
  return SnackBar(
    content: Text(text),
    action: SnackBarAction(
      label: 'X',
      onPressed: () {
        // Some code to undo the change.
      },
    ),
  );
}

// showDialog<void>(
//     context: context,
//     barrierDismissible: false, // user must tap button!
//     builder: (BuildContext context) {
//       return AlertDialog(
//         title: const Text('AlertDialog Title'),
//         content: SingleChildScrollView(
//           child: ListBody(
//             children: const <Widget>[
//               Text('This is a demo alert dialog.'),
//               Text('Would you like to approve of this message?'),
//             ],
//           ),
//         ),
//         actions: <Widget>[
//           TextButton(
//             child: const Text('Approve'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ],
//       );
//     },
//   );

popUpSelect(BuildContext context, String title, String yes, String no,
    String email, String? acID, DateTime acTime) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: Text(yes),
            onPressed: () {
              if (yes == "เข้าร่วม") {
                joinActivity(email, acID, context, "เข้าร่วม", acTime);
              } else if (yes == "ยกเลิกการเข้าร่วม") {
                joinActivity(email, acID, context, "ยกเลิกการเข้าร่วม", acTime);
              }
              Navigator.of(context).pop(true);
            },
          ),
          TextButton(
            child: Text(no),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

dialogDontJoin(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("ไม่อนุญาตให้เข้าร่วม",
            style: TextStyle(
                color: const Color.fromARGB(255, 8, 28, 138),
                fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[
              Text("โปรดเพิ่มข้อมูลส่วนตัวหากต้องการเข้าร่วม")
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("แก้ไขข้อมูลส่วนตัว"),
            onPressed: () {
              Navigator.of(context).pop(false);
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UpdatePage(role: "Userjoin")));
            },
          ),
          TextButton(
            child: const Text("ปิด"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}

dialogDontAddDetail(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text("ไม่อนุญาตให้เพิ่มรายละเอียด",
            style: TextStyle(
                color: const Color.fromARGB(255, 8, 28, 138),
                fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: ListBody(
            children: const <Widget>[Text("ยังไม่ถึงเวลาเริ่มกิจกรรม")],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text("ปิด"),
            onPressed: () {
              Navigator.of(context).pop(false);
            },
          ),
        ],
      );
    },
  );
}
