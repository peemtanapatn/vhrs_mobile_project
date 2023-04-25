// ignore_for_file: file_names

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;
import 'package:vhrs_flutter_project/widgets/activityCard.dart';
import 'package:vhrs_flutter_project/widgets/custom_datetimepick.dart';

class ListActivity extends StatefulWidget {
  String allUrl;
  ListActivity({Key? key, required this.allUrl}) : super(key: key);

  List<ActivityModel> activityList = [];
  List<ActivityModel> _foundUsers = [];
  DateTime? startDate, endDate;

  @override
  State<ListActivity> createState() => _ListActivityState();
}

class _ListActivityState extends State<ListActivity> {
  bool loading = false;
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy', 'th');
  TextEditingController searchController = TextEditingController();
  String searchDate = service.url + "/searchDateActivity";

  @override
  void initState() {
    super.initState();
    searchController.addListener(_runFilter);
    getActitvity();
  }

  @override
  void didUpdateWidget(covariant ListActivity oldWidget) {
    getActitvity();
    super.didUpdateWidget(oldWidget);
  }

  Future getActitvity() async {
    widget._foundUsers = [];
    List<ActivityModel> results = [];
    try {
      var res = await http.get(Uri.parse(service.url + widget.allUrl));

      if (res.statusCode == 200) {
        if (mounted) {
          results = activityModelFromJson(res.body);
          widget.activityList = sortActivity(results) as List<ActivityModel>;

          setState(() {
            widget._foundUsers = widget.activityList;
          });
        }
      }
    } catch (e) {
      print(e);
    }
    // setState(() {});
  }

  void _runFilter() {
    setState(() {
      loading = true;
    });
    print("_runFilter");
    List<ActivityModel>? results = [];

    if (searchController.text != "") {
      results = widget.activityList
          .where((user) => user.acName!.contains(searchController.text, 0))
          .toList();

      if (results.isEmpty) {
        results = widget.activityList
            .where((user) => user.acUcName!.contains(searchController.text, 0))
            .toList();
        if (results.isEmpty) {
          getDateActitvity();
        } else {
          widget._foundUsers = results;
        }
      } else {
        widget._foundUsers = results;
      }
    } else {
      widget._foundUsers = widget.activityList;
    }
    setState(() {
      loading = false;
    });
  }

  Future getDateActitvity() async {
    try {
      var res = await http.post(Uri.parse(searchDate), body: {
        "start": DateTime(widget.startDate!.year, widget.startDate!.month,
                widget.startDate!.day)
            .toString(),
        "end": DateTime(widget.endDate!.year, widget.endDate!.month,
                widget.endDate!.day + 1)
            .toString(),
        "email": "",
      });

      if (res.statusCode == 200) {
        widget._foundUsers = sortActivity(activityModelFromJson(res.body))
            as List<ActivityModel>;
      }
      setState(() {});
    } catch (e) {
      widget._foundUsers = [];
      setState(() {});
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
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
                    hintText: "ชื่อกิจกรรมหรือชื่อผู้จัดที่ต้องการค้นหา",
                    hintStyle: TextStyle(color: Theme.of(context).hintColor)),
              )),
              IconButton(
                  onPressed: () async {
                    customshowDateRangePicker(newselectDate, context,
                        DatePickerEntryMode.calendarOnly);
                  },
                  icon: Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.white,
                    size: 26.sp,
                  ))
            ],
          ),
        ),
        Expanded(
          child: Container(
              child: widget._foundUsers == null
                  ? const Center(
                      child: Text("ไม่มีข้อมูล..."),
                    )
                  : Container(
                      child: loading == true
                          ? const CircularProgressIndicator()
                          : RefreshIndicator(
                              onRefresh: () => getActitvity(),
                              child: ListView.builder(
                                  itemCount: widget._foundUsers.length,
                                  itemBuilder: (context, index) {
                                    return ActivityCard(
                                        key: ValueKey(
                                            widget._foundUsers[index].acId),
                                        model: widget._foundUsers[index]);
                                  }),
                            ),
                    )),
        ),
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
