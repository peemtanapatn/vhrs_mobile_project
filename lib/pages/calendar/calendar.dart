import 'dart:collection';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<ActivityModel>> selectedEvents;
  List<ActivityModel> activityList = [];
  CalendarFormat format = CalendarFormat.month;
  var selectedDay = DateTime.now();
  var focusedDay = DateTime.now();
  DateTime date = DateTime.now();
  String calendarUrl = "/getJoinCalendar";
  String email = "";
  String role = "";
  bool search = false;
  late ActivityModel dataSearh;

  TextEditingController searchController = TextEditingController();
  @override
  void initState() {
    selectedEvents = {};
    getActitvity();
    searchController.addListener(_runFilter);
    super.initState();
  }

  Future getActitvity() async {
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        email = preferences.getString("email")!;
        role = preferences.getString("typeUser")!;
      });
      if (role == "UserCreate") {
        calendarUrl = "/getJoinCreate";
      }
      var res = await http.post(Uri.parse(service.url + calendarUrl), body: {
        "email": email,
      });

      if (res.statusCode == 200) {
        activityList = activityModelFromJson(res.body);
        setEvent();

        return;
      }
    } catch (e) {
      print(e.toString());
      // throw e;
    }
  }

  checkMoreDateAddEvent(DateTime date, ActivityModel event) {
    var dateEnd = DateTime.utc(
        event.acDend!.year, event.acDend!.month, event.acDend!.day);
    if (date.compareTo(dateEnd) != 0) {
      for (;;) {
        date = date.add(Duration(days: 1));
        if (selectedEvents[date] != null) {
          var dateEnd = DateTime.utc(
              event.acDend!.year, event.acDend!.month, event.acDend!.day);
          selectedEvents[date]?.add(ActivityModel(
              acId: event.acId.toString(),
              acName: event.acName.toString(),
              acImg: event.acImg.toString()));
        } else {
          selectedEvents[date] = [
            ActivityModel(
                acId: event.acId.toString(),
                acName: event.acName.toString(),
                acImg: event.acImg.toString())
          ];
        }

        if (date.compareTo(dateEnd) == 0) {
          break;
        }
      }
    }
  }

  setEvent() {
    activityList.forEach((event) {
      date = DateTime.utc(
          event.acDstart!.year, event.acDstart!.month, event.acDstart!.day);
      log(event.acName.toString());
      if (selectedEvents[date] != null) {
        selectedEvents[date]?.add(ActivityModel(
            acId: event.acId.toString(),
            acName: event.acName.toString(),
            acImg: event.acImg.toString()));
        checkMoreDateAddEvent(date, event);
      } else {
        // var dateEnd = DateTime.utc(
        //     event.acDend!.year, event.acDend!.month, event.acDend!.day);
        // // var dateStart = date;
        // log("" + date.compareTo(dateEnd).toString());
        // if (date.compareTo(dateEnd) == 0) {
        selectedEvents[date] = [
          ActivityModel(
              acId: event.acId.toString(),
              acName: event.acName.toString(),
              acImg: event.acImg.toString())
        ];
        checkMoreDateAddEvent(date, event);
        // } else {
        //   for (;;) {
        //     if (selectedEvents[date] != null) {
        //       var dateEnd = DateTime.utc(
        //           event.acDend!.year, event.acDend!.month, event.acDend!.day);
        //       selectedEvents[date]?.add(ActivityModel(
        //           acId: event.acId.toString(),
        //           acName: event.acName.toString(),
        //           acImg: event.acImg.toString()));
        //     } else {
        //       selectedEvents[date] = [
        //         ActivityModel(
        //             acId: event.acId.toString(),
        //             acName: event.acName.toString(),
        //             acImg: event.acImg.toString())
        //       ];
        //     }
        //     if (date.compareTo(dateEnd) == 0) {
        //       break;
        //     }
        //     date = date.add(Duration(days: 1));
        //     log(date.day.toString());
        //   }
        // }
      }
      // log(selectedEvents[date].toString());
    });
    setState(() {});
  }

  List<ActivityModel> _getEventsfromsDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  void _runFilter() {
    List<ActivityModel>? results = [];
    results = activityList;
    if (searchController.text != "") {
      results = results
          .where((user) => user.acName!.contains(searchController.text, 0))
          .toList();

      if (results.isEmpty) {
        search = false;
      } else {
        dataSearh = results[0];
        search = true;
        selectedDay = DateTime(dataSearh.acDstart!.year,
            dataSearh.acDstart!.month, dataSearh.acDstart!.day);
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        centerTitle: true,
        title: Text(
          "ตารางกิจกรรม",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(children: [
            SizedBox(height: 10.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 400.w,
                  height: 60.h,
                  child: TextFormField(
                    style: TextStyle(fontSize: 18.sp),
                    controller: searchController,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Colors.red,
                                width: 10.w,
                                style: BorderStyle.solid),
                            borderRadius: BorderRadius.circular(50.r)),
                        fillColor: Colors.white,
                        filled: true,
                        contentPadding: EdgeInsets.all(10.w),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Theme.of(context).secondaryHeaderColor,
                          size: 20.sp,
                        ),
                        suffix: InkWell(
                          onTap: () => searchController.text = '',
                          child: Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Icon(
                              Icons.clear_outlined,
                              color: Colors.red,
                              size: 20.sp,
                            ),
                          ),
                        ),
                        hintText: "ชื่อกิจกรรมที่ต้องการค้นหา",
                        hintStyle:
                            TextStyle(color: Theme.of(context).hintColor)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: IconButton(
                    icon: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 30,
                    ),
                    tooltip: 'refresh',
                    onPressed: () {
                      searchController.text = "";
                      selectedEvents = {};
                      getActitvity();
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: 430.w,
                // padding: EdgeInsets.all(20.0.w),
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 245, 245, 245),
                  borderRadius: BorderRadius.circular(10.0.h),
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromARGB(255, 94, 94, 94).withOpacity(0.2),
                      blurRadius: 10,
                      offset: Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(children: [
                  calendarActivity(),
                  if (search == false)
                    ..._getEventsfromsDay(selectedDay).map(
                      (ActivityModel event) => eventList(
                          event.acName.toString(),
                          event.acImg.toString(),
                          event.acId.toString()),
                    ),
                  if (search == true)
                    eventList(dataSearh.acName.toString(),
                        dataSearh.acImg.toString(), dataSearh.acId.toString()),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  calendarActivity() {
    return TableCalendar(
      focusedDay: selectedDay,
      firstDay: DateTime(2010),
      lastDay: DateTime(2050),
      calendarFormat: format,
      onFormatChanged: (CalendarFormat _format) {
        setState(() {
          format = _format;
        });
      },
      daysOfWeekVisible: true,

      //Daychange
      onDaySelected: (selectDay, focusDay) {
        setState(() {
          search = false;
          searchController.text = "";
          selectedDay = selectDay;
          focusedDay = focusDay;
        });
        print(focusedDay);
      },
      // selectedDayPredicate: (DateTime date) {
      //   return isSameDay(selectedDay, date);
      // },
      selectedDayPredicate: (day) => isSameDay(day, selectedDay),
      eventLoader: _getEventsfromsDay,
      //To style the calendar
      calendarStyle: CalendarStyle(
          isTodayHighlighted: true,
          selectedDecoration: BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          selectedTextStyle: TextStyle(color: Colors.white),
          todayDecoration: BoxDecoration(
            color: Color.fromARGB(255, 120, 120, 120),
            shape: BoxShape.circle,
          )),
      headerStyle: HeaderStyle(formatButtonVisible: false, titleCentered: true),
    );
  }

  eventList(String nameEvent, String img, String id) {
    String image = "";
    if (img != "null" && img != "") {
      image = img;
    }
    return Padding(
      padding: EdgeInsets.all(8.w),
      child: Container(
        width: 350.w,
        // padding: EdgeInsets.symmetric(horizontal: 24.w),
        decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10.0.h),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 94, 94, 94).withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 10),
              ),
            ]),
        child: Align(
            alignment: Alignment.topLeft,
            child: Column(children: [
              SizedBox(height: 10.h),
              Row(
                children: [
                  SizedBox(width: 20.w),
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 35.r,
                    child: ClipRRect(
                      child: image == ""
                          ? Image.network(
                              service.defult_activity_img,
                              fit: BoxFit.cover,
                              height: 150.h,
                              width: 300.w,
                            )
                          : Image.network(
                              service.uploads + image,
                              loadingBuilder:
                                  ((context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Center(
                                    child: CircularProgressIndicator());
                              }),
                              fit: BoxFit.cover,
                              height: 150.h,
                              width: 300.w,
                            ),
                      borderRadius: BorderRadius.circular(0),
                    ),
                  ),
                  SizedBox(width: 20.w),
                  Expanded(
                      child: Text(nameEvent,
                          style: TextStyle(
                              color: Color.fromARGB(255, 12, 12, 12),
                              fontSize: 16.w,
                              fontWeight: FontWeight.bold))),
                ],
              ),
              SizedBox(height: 5.h),
              Container(
                width: 300.w,
                height: 40.h,
                child: RaisedButton(
                  onPressed: () async {
                    List<ActivityModel> searchActivityModel = [];
                    var res = await http.post(
                        Uri.parse(service.url + '/searchIDActivity'),
                        body: {
                          "id": id,
                        });

                    if (res.statusCode == 200) {
                      searchActivityModel = activityModelFromJson(res.body);
                    }
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => DetailActivityPage(
                              data: searchActivityModel[0],
                            )));
                  },
                  child: Text("จัดการกิจกรรม",
                      style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 15.w,
                      )),
                ),
              ),
              SizedBox(height: 10.h),
            ])),
      ),
    );
  }
}

// class _CalendarPageState extends State<CalendarPage> {
//   List<ActivityModel> activityList = [];
//   DateTime selectedDay = DateTime.now();
//   List<CleanCalendarEvent> selectedEvent = [];

//   Map<DateTime, List<CleanCalendarEvent>> events = {
//     // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day): [
//     //   CleanCalendarEvent('Event A',
//     //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day, 10, 0),
//     //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day, 12, 0),
//     //       description: 'A special event',
//     //       color: Colors.blue),
//     // ],
//     // DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 1):
//     //     [
//     //   CleanCalendarEvent('Event B',
//     //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day + 2, 10, 0),
//     //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day + 2, 12, 0),
//     //       color: Colors.orange),
//     //   CleanCalendarEvent('Event C',
//     //       startTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day + 2, 14, 30),
//     //       endTime: DateTime(DateTime.now().year, DateTime.now().month,
//     //           DateTime.now().day + 2, 17, 0),
//     //       color: Colors.pink),
//     // ],
//   };
//   String email = "";
//   String calendarUrl = "/getJoinCalendar";

//   void _handleData(date) {
//     setState(() {
//       selectedDay = date;
//       selectedEvent = events[selectedDay] ?? [];
//     });
//     print(selectedDay);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     getDataCalendar();
//     selectedEvent = events[selectedDay] ?? [];
//     super.initState();
//   }

//   Future getDataCalendar() async {
//     try {
//       SharedPreferences preferences = await SharedPreferences.getInstance();
//       setState(() {
//         email = preferences.getString("email")!;
//       });
//       var res = await http.post(Uri.parse(service.url + calendarUrl), body: {
//         "email": email,
//       });

//       if (res.statusCode == 200) {
//         activityList = activityModelFromJson(res.body);

//         setEvent();

//         return;
//       }
//     } catch (e) {
//       // print(e.toString());
//       throw e;
//     }
//   }

//   setEvent() {
//     // log("true");
//     // selectedEvents[date] = [Event(title: "")];
//     // for (var i = 0; i < activityList.length; i++) {
//     //   DateTime dateStart = DateTime(
//     //       activityList[i].acDstart!.year,
//     //       activityList[i].acDstart!.month,
//     //       activityList[i].acDstart!.day,
//     //       activityList[i].acDstart!.hour,
//     //       activityList[i].acDstart!.minute);
//     //   DateTime dateEnd = DateTime(
//     //       activityList[i].acDend!.year,
//     //       activityList[i].acDend!.month,
//     //       activityList[i].acDend!.day,
//     //       activityList[i].acDend!.hour,
//     //       activityList[i].acDend!.minute);
//     //   events.addAll({
//     //     dateStart: [
//     //       CleanCalendarEvent(activityList[i].acId.toString(),
//     //           startTime: dateStart, endTime: dateEnd, color: Colors.blue),
//     //     ],
//     //   });
//     // }
//     activityList.forEach((event) {
//       log(event.acDstart.toString());
//       DateTime dateStart = DateTime(event.acDstart!.year, event.acDstart!.month,
//           event.acDstart!.day, event.acDstart!.hour, event.acDstart!.minute);
//       DateTime dateEnd = DateTime(event.acDend!.year, event.acDend!.month,
//           event.acDend!.day, event.acDend!.hour, event.acDend!.minute);
//       events.addAll({
//         DateTime(
//             event.acDstart!.year, event.acDstart!.month, event.acDstart!.day): [
//           CleanCalendarEvent(event.acId.toString(),
//               startTime: dateStart, endTime: dateEnd, color: Colors.blue),
//         ],
//       });
//     });
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Calendar'),
//         centerTitle: true,
//       ),
//       body: SafeArea(
//         child: Align(
//           alignment: Alignment.topCenter,
//           child: Container(
//             width: 430.w,
//             // padding: EdgeInsets.all(20.0.w),
//             padding: EdgeInsets.symmetric(horizontal: 24.w),
//             decoration: BoxDecoration(
//               color: Color.fromARGB(255, 245, 245, 245),
//               borderRadius: BorderRadius.circular(10.0.h),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromARGB(255, 94, 94, 94).withOpacity(0.2),
//                   blurRadius: 10,
//                   offset: Offset(0, 10),
//                 ),
//               ],
//             ),
//             child: Calendar(
//               startOnMonday: true,
//               selectedColor: Colors.blue,
//               todayColor: Colors.red,
//               eventColor: Colors.green,
//               eventDoneColor: Colors.amber,
//               bottomBarColor: Colors.deepOrange,
//               onRangeSelected: (range) {
//                 print('selected Day ${range.from},${range.to}');
//               },
//               onDateSelected: (date) {
//                 return _handleData(date);
//               },
//               events: events,
//               isExpanded: true,
//               dayOfWeekStyle: TextStyle(
//                 fontSize: 15,
//                 color: Colors.black12,
//                 fontWeight: FontWeight.w100,
//               ),
//               bottomBarTextStyle: TextStyle(
//                 color: Color.fromARGB(255, 16, 16, 16),
//               ),
//               hideBottomBar: false,
//               hideArrows: false,
//               weekDays: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
