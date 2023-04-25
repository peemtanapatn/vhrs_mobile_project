import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/alert_activity_model.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';

class SettingAlertPage extends StatefulWidget {
  final ActivityModel activityModel;
  final String emailUser;
  const SettingAlertPage(
      {Key? key, required this.activityModel, required this.emailUser})
      : super(key: key);

  @override
  State<SettingAlertPage> createState() => _SettingAlertPageState();
}

class _SettingAlertPageState extends State<SettingAlertPage> {
  List<AlertActivityModel> allList = [];
  final DateFormat formatter = DateFormat('HH:mm น. dd MMM yyyy ', 'th');

  @override
  void initState() {
    super.initState();
    setDataAlert();
  }

  setDataAlert() async {
    try {
      allList =
          await getDataAlert(widget.emailUser, widget.activityModel.acId!);
      allList = sortAlertActivity(allList);

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("การแจ้งเตือน"),
        backgroundColor: Theme.of(context).canvasColor,
        actions: [
          IconButton(
            onPressed: () {
              addAlert();
            },
            icon: const Icon(Icons.add_alert_sharp),
            color: Colors.white,
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 50.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "เวลาจัดกิจกรรม",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18.sp,
                  ),
                ),
                Text(
                  "${formatter.format(widget.activityModel.acDstart!)} - ${formatter.format(widget.activityModel.acDend!)}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: allList != []
                ? RefreshIndicator(
                    onRefresh: () => setDataAlert(),
                    child: ListView.builder(
                        itemCount: allList.length,
                        padding: EdgeInsets.symmetric(
                            vertical: 5.h, horizontal: 5.w),
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            // selectedTileColor: Colors.red,
                            dense: true,
                            tileColor: Colors.white,
                            leading: Icon(
                              Icons.alarm_rounded,
                              color:
                                  allList[index].arTime!.isAfter(DateTime.now())
                                      ? Colors.amber
                                      : Colors.green,
                              size: 30.sp,
                            ),
                            title: Text.rich(
                              TextSpan(
                                  text:
                                      "แจ้งเตือน : ${formatter.format(allList[index].arTime!)} ",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold),
                                  children: const <InlineSpan>[
                                    // TextSpan(
                                    //   text:
                                    //       "(${formatter.format(showList[index].arTime!)})",
                                    //   style: TextStyle(
                                    //       color: Colors.black,
                                    //       fontSize: 12.sp,
                                    //       fontWeight: FontWeight.normal),
                                    // )
                                  ]),
                            ),

                            trailing: widget.activityModel.acDstart !=
                                    allList[index].arTime
                                ? allList[index].arTime!.isAfter(DateTime.now())
                                    ? IconButton(
                                        icon: Icon(
                                          Icons.delete,
                                          color: Colors.red,
                                          size: 18.sp,
                                        ),
                                        onPressed: () {
                                          _delThisAlert(allList[index].arId!);
                                        },
                                      )
                                    : Text(
                                        "สำเร็จ",
                                        style: TextStyle(
                                          fontSize: 14.sp,
                                          color: Colors.green,
                                        ),
                                      )
                                : Text(
                                    "พื้นฐาน",
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                          );
                        }),
                  )
                : const Center(
                    child: Text(
                      "ไม่มีการแจ้งเตือน",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  void addAlert() async {
    try {
      DateTime? date = await showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        initialEntryMode: DatePickerEntryMode.calendarOnly,
        initialDate: DateTime.now(),
        lastDate: widget.activityModel.acDend!,
        cancelText: "ยกเลิก",
        confirmText: "ตกลง",
        helpText: "เลือกวันที่แจ้งเตือน",
        errorFormatText: 'mm/dd/yyyy',
        locale: const Locale('en'),
        builder: (context, child) => themeDateTimePicker(context, child),
      );
      if (date != null) {
        TimeOfDay? time = await showTimePicker(
            cancelText: "ยกเลิก",
            confirmText: "ตกลง",
            helpText: "เลือกเวลาแจ้งเตือน",
            context: context,
            initialTime: TimeOfDay.fromDateTime(DateTime.now()),
            builder: (context, child) => themeDateTimePicker(context, child));
        if (time != null) {
          DateTime addTime = applied(time, date);
          if (addTime.isAfter(widget.activityModel.acDend!)) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarWithText(
                "กรุณากรอกวัน-เวลาแจ้งเตือนให้อยู่ในช่วงก่อนวันสิ้นสุดกิจกรรม ${formatter.format(widget.activityModel.acDend!)}",
              ),
            );
            // await Future.delayed(const Duration(seconds: 2), () {});
            // addAlert();
          } else if (addTime.isBefore(DateTime.now())) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarWithText(
                "กรุณากรอกวัน-เวลาแจ้งเตือนให้เกินปัจจุบัน",
              ),
            );
            // await Future.delayed(const Duration(seconds: 2), () {});
            // addAlert();
          } else if (chkList(addTime)) {
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarWithText(
                "มีแจ้งเตือนเวลานี้แล้ว",
              ),
            );
            // await Future.delayed(const Duration(seconds: 2), () {});
            // addAlert();
          } else {
            setDataAlert();
            String acId = widget.activityModel.acId ?? "";

            String arLength = findIdMax();
            addAlertActivity(
              "ar_${arLength}_${acId}_${widget.emailUser}",
              widget.emailUser,
              acId,
              addTime.toString(),
            );
            createPhoneAlert(
              int.parse("${acId.split("_")[1].trim()}$arLength"),
              widget.activityModel.acId ?? "",
              widget.activityModel.acName ?? "",
              widget.activityModel.acLocationName ?? "",
              widget.activityModel.acImg ?? "",
              widget.activityModel.acDstart!,
              widget.activityModel.acDend!,
              addTime,
            );
            ScaffoldMessenger.of(context).showSnackBar(
              snackBarWithText(
                "เพิ่มแจ้งเตือนสำเร็จ ",
              ),
            );
            await Future.delayed(const Duration(seconds: 1), () {});
            setDataAlert();
            setState(() {});
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }

  DateTime applied(TimeOfDay time, DateTime date) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  bool chkList(DateTime addTime) {
    try {
      AlertActivityModel? model;
      model = allList.where((element) => element.arTime == addTime).first;

      if (model == null) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  void _delThisAlert(String id) {
    showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('ลบข้อมูลการแจ้งเตือน'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยืนยัน'),
              onPressed: () {
                delAlertActivity(
                  id,
                );
                Navigator.of(context).pop();
                clearPhoneAlert();
                setPhoneAlert();
              },
            ),
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
          ],
        );
      },
    );
  }

  void clearPhoneAlert() async {
    for (int i = 1; i <= allList.length; i++) {
      await AwesomeNotifications().cancel(
          int.parse("${widget.activityModel.acId!.split("_")[1].trim()}$i"));
    }
  }

  void setPhoneAlert() {
    setDataAlert();
    try {
      for (var i = 0; i < allList.length; i++) {
        createPhoneAlert(
          int.parse(
              "${widget.activityModel.acId!.split("_")[1].trim()}${i + 1}"),
          widget.activityModel.acId ?? "",
          widget.activityModel.acName ?? "",
          widget.activityModel.acLocationName ?? "",
          widget.activityModel.acImg ?? "",
          widget.activityModel.acDstart!,
          widget.activityModel.acDend!,
          allList[i].arTime,
        );
      }
    } catch (e) {
      print(e);
    }
  }

  String findIdMax() {
    int max = 1;
    for (AlertActivityModel element in allList) {
      int c = int.parse(element.arId!.split("_")[1]);
      if (c > max) {
        max = c;
      }
    }
    return (max + 1).toString();
  }
}
