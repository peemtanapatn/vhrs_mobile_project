// ignore_for_file: file_names

import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/joinActivity_model.dart';
import 'package:vhrs_flutter_project/models/join_activity_model.dart';
import 'package:vhrs_flutter_project/pages/chkActivityHour/detailJoinActivity.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/services/pdf_service.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/widgets/container.dart';
import 'package:vhrs_flutter_project/widgets/custom_datetimepick.dart';
import 'package:vhrs_flutter_project/widgets/snackBarWithText.dart';

class ChkActivityHourPage extends StatefulWidget {
  ChkActivityHourPage({Key? key}) : super(key: key);

  DateTime? startDate, endDate;

  var activityList = [];
  var _foundAc = [];

  @override
  State<ChkActivityHourPage> createState() => _ChkActivityHourPageState();
}

class _ChkActivityHourPageState extends State<ChkActivityHourPage> {
  String typeUser = "", email = "";
  String allThisAccountUrl = "";
  bool loading = false;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy', 'th');
  TextEditingController searchController = TextEditingController();
  String searchDate = "";
  var hour = 0, countAll = 0;
  var res;
  Color _print = Colors.white;

  List<bool> _isChecked = [];

  @override
  void initState() {
    super.initState();
    searchController.addListener(_runFilter);
    getActitvity();
  }

  Future getActitvity() async {
    setState(() {
      loading = true;
    });
    try {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      setState(() {
        typeUser = preferences.getString("typeUser")!;
        email = preferences.getString("email")!;
        if (typeUser == "UserJoin") {
          allThisAccountUrl = "/getJoinActivityWithEmail";
          searchDate = "/searchDateJoinActivityWithEmail";
        } else if (typeUser == "UserCreate") {
          allThisAccountUrl = "/getJoinCreate";
          searchDate = "/searchDateActivity";
        }
      });
      print(email);

      res = await http.post(Uri.parse(service.url + allThisAccountUrl), body: {
        "email": email,
      });

      if (mounted) {
        setState(() {});
      }

      if (res.statusCode == 200) {
        if (res.body != "Dont have") {
          if (mounted) {
            setState(() {
              if (typeUser == "UserCreate") {
                widget.activityList =
                    sortActivity(activityModelFromJson(res.body));
              } else if (typeUser == "UserJoin") {
                widget.activityList =
                    sortActivity(JoinAndActivityModelFromJson(res.body));
              }
              widget._foundAc = widget.activityList;
              _isChecked = List<bool>.filled(widget._foundAc.length, false);
            });
          }
        } else {
          widget.activityList = [];
          widget._foundAc = [];
          _isChecked = [];
        }
        if (typeUser == "UserCreate") {
          for (int i = 0; i < widget.activityList.length; i++) {
            widget.activityList[i].countJoin =
                await getCountJoin(widget.activityList[i].acId);
          }
        }

        countAll = widget.activityList.length;
        setHour();
        setState(() {
          loading = false;
        });
      }
    } catch (e) {
      print(e);
      // throw e;
    }
  }

  void _runFilter() {
    setState(() {
      loading = true;
    });

    print("_runFilter");
    var results = [];
    widget._foundAc = widget.activityList;

    if (searchController.text != "") {
      results = widget.activityList
          .where((user) => user.acName!.contains(searchController.text, 0))
          .toList();
      if (results.isEmpty) {
        widget._foundAc = [];
        getDateActitvity();
      } else {
        widget._foundAc = results;
      }
      try {
        _isChecked = List<bool>.filled(widget._foundAc.length, false);
      } catch (e) {
        log(e.toString());
      }
    } else {
      getActitvity();
    }

    setState(() {
      setHour();
      loading = false;
    });
  }

  Future getDateActitvity() async {
    try {
      var res = await http.post(Uri.parse(service.url + searchDate), body: {
        "start": DateTime(widget.startDate!.year, widget.startDate!.month,
                widget.startDate!.day)
            .toString(),
        "end": DateTime(widget.endDate!.year, widget.endDate!.month,
                widget.endDate!.day + 1)
            .toString(),
        "email": email,
      });
      setState(() {});
      if (res.statusCode == 200) {
        var results = [];
        if (typeUser == "UserCrete") {
          results = activityModelFromJson(res.body);
        } else {
          results = JoinAndActivityModelFromJson(res.body);
        }
        widget._foundAc = results;

        _isChecked = List<bool>.filled(widget._foundAc.length, false);

        setHour();
        return json.decode(res.body);
      }
      setState(() {});
    } catch (e) {
      setState(() {});
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).canvasColor,
        foregroundColor: Colors.white,
        title: Text(
          "รายงานกิจกรรม",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        actions: [
          typeUser == 'UserJoin'
              ? Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          if (_print == Colors.green) {
                            _print = Colors.white;
                          } else {
                            _print = Colors.green;
                          }
                          setState(() {});
                        },
                        icon: Icon(
                          Icons.print,
                          color: _print,
                          size: 30.sp,
                        )),
                    _print == Colors.green
                        ? Row(
                            children: [
                              IconButton(
                                  onPressed: () async {
                                    List<JoinAndActivityModel> listSelect = [];
                                    for (int i = 0;
                                        i < _isChecked.length;
                                        i++) {
                                      if (_isChecked[i] == true &&
                                          widget._foundAc[i].jaStatus ==
                                              "ยืนยันการเข้าร่วม") {
                                        listSelect.add(widget._foundAc[i]);
                                        print(widget._foundAc[i].acName);
                                      }
                                    }
                                    print(listSelect.length);
                                    if (listSelect.isNotEmpty) {
                                      ProgressDialog pd =
                                          ProgressDialog(context: context);
                                      pd.show(max: 80, msg: 'โปรดรอสักครู่...');
                                      await createPDF(email, listSelect);
                                      Navigator.of(context).pop();
                                    } else {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBarWithText(
                                              'กรุณาเลือกกิจกรรมที่ต้องการ'));
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    _print = Colors.white;

                                    setState(() {});
                                  },
                                  icon: const Icon(
                                    Icons.cancel_sharp,
                                    color: Colors.red,
                                  )),
                            ],
                          )
                        : Container(),
                  ],
                )
              : Container(),
        ],
      ),
      body: res == "Dont have"
          ? const Center(
              child: Text("ยังไม่มีกิจกรรมที่มีส่วนร่วม"),
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: [
                Expanded(
                  child: Column(
                    children: [
                      _search(),
                      Padding(
                          padding: EdgeInsets.fromLTRB(18.w, 0, 0, 10.h),
                          child: _countResult()),
                      Expanded(
                          child: Container(
                        child: RefreshIndicator(
                          onRefresh: () => getActitvity(),
                          child: ListView.builder(
                              shrinkWrap: true,
                              itemCount: _isChecked.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10.h, vertical: 10.w),
                                    child: appContainer(
                                        child: ListTile(
                                            leading: typeUser == "UserCreate"
                                                ? const Icon(
                                                    Icons.library_books_sharp,
                                                    color: Colors.red,
                                                  )
                                                : _print == Colors.green
                                                    ? widget._foundAc[index]!
                                                                .jaStatus ==
                                                            ""
                                                        ? SizedBox(
                                                            width: 5.w,
                                                          )
                                                        : _isChecked[index] ==
                                                                false
                                                            ? const Icon(
                                                                Icons
                                                                    .check_box_outline_blank,
                                                                color:
                                                                    Colors.red,
                                                              )
                                                            : const Icon(
                                                                Icons.check_box,
                                                                color: Colors
                                                                    .green,
                                                              )
                                                    : widget._foundAc[index]!
                                                                .jaStatus ==
                                                            ""
                                                        ? const Icon(
                                                            Icons
                                                                .cancel_outlined,
                                                            color: Colors.red,
                                                          )
                                                        : const Icon(
                                                            Icons
                                                                .check_circle_outline,
                                                            color: Colors.green,
                                                          ),
                                            trailing: Text(
                                              typeUser == "UserCreate"
                                                  ? widget.activityList[index]
                                                          .countJoin
                                                          .toString() +
                                                      "/" +
                                                      widget._foundAc[index]
                                                          .acAmount!
                                                          .toString()
                                                  : widget._foundAc[index]
                                                          .acHour!
                                                          .toString() +
                                                      " ชั่วโมงจิตอาสา",
                                              style: TextStyle(
                                                  color: typeUser ==
                                                          "UserCreate"
                                                      ? Theme.of(context)
                                                          .canvasColor
                                                      : widget._foundAc[index]
                                                                  .jaStatus ==
                                                              ""
                                                          ? Colors.red
                                                          : Colors.green,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            title: SizedBox(
                                              width: 180.w,
                                              child: Text(
                                                widget._foundAc[index].acName!,
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                                softWrap: false,
                                                style: TextStyle(
                                                    color: Theme.of(context)
                                                        .canvasColor,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                            subtitle: Text(
                                              formatter.format(widget
                                                      ._foundAc[index]
                                                      .acDstart!) +
                                                  " -> " +
                                                  formatter.format(widget
                                                      ._foundAc[index].acDend!),
                                              style: TextStyle(
                                                  fontSize: 12.sp,
                                                  color: Colors.black),
                                            ),
                                            onTap: () async {
                                              if (typeUser == "UserCreate") {
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailActivityPage(
                                                              data: widget
                                                                      ._foundAc[
                                                                  index]!,
                                                            )))
                                                    .then((value) => {
                                                          // if (value)
                                                          //   {
                                                          setState(() {
                                                            getActitvity();
                                                          })
                                                          //   }
                                                        });
                                              } else if (typeUser ==
                                                  "UserJoin") {
                                                if (_print == Colors.green) {
                                                  if (_isChecked[index] ==
                                                      false) {
                                                    _isChecked[index] = true;
                                                  } else {
                                                    _isChecked[index] = false;
                                                  }

                                                  setState(() {});
                                                } else {
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                          builder: (context) =>
                                                              DetailJoinPage(
                                                                  joinAndActivityModel:
                                                                      widget._foundAc[
                                                                          index]!)))
                                                      .then((value) => {
                                                            print(value),
                                                            if (value)
                                                              {
                                                                setState(() {
                                                                  getActitvity();
                                                                })
                                                              }
                                                          });
                                                }
                                              }
                                            })));
                              }),
                        ),
                      ))
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  _search() {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: 10.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
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
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).secondaryHeaderColor,
                  size: 20.sp,
                ),
                suffix: InkWell(
                  onTap: () {
                    searchController.text = '';
                  },
                  child: Icon(
                    Icons.clear_outlined,
                    color: Colors.red,
                    size: 20.sp,
                  ),
                ),
                hintText: "ชื่อกิจกรรมที่ต้องการค้นหา",
                hintStyle: TextStyle(color: Theme.of(context).hintColor)),
          )),
          IconButton(
              onPressed: () async {
                customshowDateRangePicker(
                    newselectDate, context, DatePickerEntryMode.calendarOnly);
              },
              icon: Icon(
                Icons.calendar_today_outlined,
                color: Colors.white,
                size: 26.sp,
              ))
        ],
      ),
    );
  }

  _countResult() {
    if (typeUser == "UserJoin") {
      if (searchController.text == "") {
        return _countResultRow(Column(
          children: [
            rowAmount("จำนวนกิจกรรมทั้งหมด " + countAll.toString() + " กิจกรรม")
          ],
        ));
      } else {
        return Column(
          children: [
            rowAmount("จำนวนชั่วโมงสะสม " + hour.toString() + " ชั่วโมง"),
            SizedBox(height: 15.sp),
            barPercent("รายเทอม", hour, 18, (hour / 18)),
            SizedBox(height: 20.sp),
            barPercent("ปีการศึกษา", hour, 36, (hour / 36)),
          ],
        );
      }
    } else {
      return _countResultRow(
        Column(children: [
          rowAmount(
            "จำนวนกิจกรรม " + countAll.toString() + " กิจกรรม",
          )
        ]),
      );
    }
  }

  barPercent(String lead, int per, int full, double percent) {
    if (percent > 1) {
      percent = 0;
    }

    if (per >= full) {
      percent = 1;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        LinearPercentIndicator(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          width: 250.w,
          animation: true,
          animationDuration: 1000,
          lineHeight: 20.0,
          leading: Text(lead,
              style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600)),
          trailing: per >= full
              ? const Text("")
              : Text("ขาด " + (full - per).toString() + " ชั่วโมง",
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.red,
                      fontWeight: FontWeight.w600)),
          percent: percent,
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: Colors.green,
          barRadius: Radius.circular(20.r),
        )
      ],
    );
  }

  // _list() {
  // return Expanded(
  //     child: Container(
  //   child: RefreshIndicator(
  //     onRefresh: () => getActitvity(),
  //     child: ListView.builder(
  //         shrinkWrap: true,
  //         itemCount: _isChecked.length,
  //         itemBuilder: (context, index) {
  //           return Padding(
  //               padding:
  //                   EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.w),
  //               child: appContainer(
  //                   child: ListTile(
  //                       leading: typeUser == "UserCreate"
  //                           ? Icon(
  //                               Icons.library_books_sharp,
  //                               color: Colors.red,
  //                             )
  //                           : _print == Colors.green
  //                               ? widget._foundAc[index]!.jaStatus == ""
  //                                   ? SizedBox(
  //                                       width: 5.w,
  //                                     )
  //                                   : _isChecked[index] == false
  //                                       ? Icon(
  //                                           Icons.check_box_outline_blank,
  //                                           color: Colors.red,
  //                                         )
  //                                       : Icon(
  //                                           Icons.check_box,
  //                                           color: Colors.green,
  //                                         )
  //                               : widget._foundAc[index]!.jaStatus == ""
  //                                   ? Icon(
  //                                       Icons.cancel_outlined,
  //                                       color: Colors.red,
  //                                     )
  //                                   : Icon(
  //                                       Icons.check_circle_outline,
  //                                       color: Colors.green,
  //                                     ),
  //                       trailing: Text(
  //                         typeUser == "UserCreate"
  //                             ? "0 / " +
  //                                 widget._foundAc[index].acAmount!
  //                                     .toString()
  //                             : widget._foundAc[index].acHour!.toString() +
  //                                 " ชั่วโมงจิตอาสา",
  //                         style: TextStyle(
  //                             color: typeUser == "UserCreate"
  //                                 ? Theme.of(context).canvasColor
  //                                 : widget._foundAc[index].jaStatus == ""
  //                                     ? Colors.red
  //                                     : Colors.green,
  //                             fontSize: 14.sp,
  //                             fontWeight: FontWeight.bold),
  //                       ),
  //                       title: Container(
  //                         width: 180.w,
  //                         child: Text(
  //                           widget._foundAc[index].acName!,
  //                           overflow: TextOverflow.fade,
  //                           maxLines: 1,
  //                           softWrap: false,
  //                           style: TextStyle(
  //                               color: Theme.of(context).canvasColor,
  //                               fontWeight: FontWeight.w600),
  //                         ),
  //                       ),
  //                       subtitle: Text(
  //                         formatter.format(
  //                                 widget._foundAc[index].acDstart!) +
  //                             " -> " +
  //                             formatter
  //                                 .format(widget._foundAc[index].acDend!),
  //                         style:
  //                             TextStyle(fontSize: 12.sp, color: Colors.black),
  //                       ),
  //                       onTap: () async {
  //                         if (typeUser == "UserCreate") {
  //                           var c = await Navigator.of(context)
  //                               .push(MaterialPageRoute(
  //                                   builder: (context) => DetailActivityPage(
  //                                         data: widget._foundAc[index]!,
  //                                       )))
  //                               .then((value) => {
  //                                     print(value),
  //                                     if (value)
  //                                       {
  //                                         setState(() {
  //                                           getActitvity();
  //                                         })
  //                                       }
  //                                   });
  //                         } else if (typeUser == "UserJoin") {
  //                           if (_print == Colors.green) {
  //                             if (_isChecked[index] == false) {
  //                               _isChecked[index] = true;
  //                             } else {
  //                               _isChecked[index] = false;
  //                             }

  //                             setState(() {});
  //                           } else {
  //                             Navigator.of(context)
  //                                 .push(MaterialPageRoute(
  //                                     builder: (context) => DetailJoinPage(
  //                                         joinAndActivityModel:
  //                                             widget._foundAc[index]!)))
  //                                 .then((value) => {
  //                                       print(value),
  //                                       if (value)
  //                                         {
  //                                           setState(() {
  //                                             getActitvity();
  //                                           })
  //                                         }
  //                                     });
  //                           }
  //                         }
  //                       })));
  //         }),
  //   ),
  // ));
  // }

  void setHour() {
    hour = 0;
    if (typeUser == "UserJoin") {
      for (int i = 0; i < widget._foundAc.length; i++) {
        if (widget._foundAc[i].jaStatus != "") {
          try {
            hour += widget._foundAc[i].acHour! as int;
          } catch (e) {
            print(e);
          }
        }
      }
    } else {
      setState(() {
        countAll = widget._foundAc.length;
      });
    }
  }

  _countResultRow(Column child) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
        child: child,
      ),
    );
  }

  rowAmount(String txt) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(txt,
            style: TextStyle(
                fontSize: 16.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  newselectDate(var newselect) {
    if (newselect != null) {
      widget.startDate = newselect.start;
      widget.endDate = newselect.end;
      searchController.text = formatter.format(newselect.start) +
          " ถึง " +
          formatter.format(newselect.end);
    }
  }
}
