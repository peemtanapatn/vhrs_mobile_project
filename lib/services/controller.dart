import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Controller extends GetxController {
  Future<void> createNotify(int id, String acId, String title, String body,
      String pic, DateTime scheduleTime) async {
    // String timezone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    bool isallowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isallowed) {
      //no permission of local notification
      AwesomeNotifications().requestPermissionToSendNotifications();
    } else {
      var data = {"ac_id": acId};
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: id,
            channelKey: "basic_channel",
            ticker: "ticker",
            title: title,
            body: body,
            wakeUpScreen: true,
            color: const Color.fromARGB(255, 20, 33, 107),
            notificationLayout: NotificationLayout.Inbox,
            payload: data),
        schedule: NotificationCalendar.fromDate(
            date: scheduleTime, preciseAlarm: true),
      );
    }
    try {
      AwesomeNotifications().actionStream.listen((receivedAction) async {
        var payload = receivedAction.payload;

        print(payload!['ac_id']);
        createNotify(id, acId, title, body, pic, scheduleTime);

        if (payload['ac_id'] != null) {
          Get.toNamed("/DetailActivityPage/" + payload['ac_id']!);
        }
      });
    } catch (e) {
      print(e);
    }
  }
}
