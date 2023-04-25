// ignore_for_file: file_names

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vhrs_flutter_project/models/activity_model.dart';
import 'package:vhrs_flutter_project/models/joinActivity_model.dart';
import 'package:vhrs_flutter_project/pages/detailActivity/detailActivity.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

class ActivityCard extends StatefulWidget {
  ActivityModel model;

  ActivityCard({Key? key, required this.model}) : super(key: key);

  //  final String formatted = formatter.format(now);
  // print(formatted); // something like 2013-04-20

  @override
  State<ActivityCard> createState() => _ActivityCardState(model);
}

class _ActivityCardState extends State<ActivityCard> {
  final DateTime now = DateTime.now();
  final DateFormat formatter = DateFormat('dd MMM yyyy HH:mm', 'th');
  ActivityModel? data;
  // UcModel? ucModel;
  String img = "";

  int countJoin = 0;
  _ActivityCardState(ActivityModel model) {
    data = model;
  }

  @override
  void initState() {
    super.initState();

    getImage();
    setData();
  }

  setData() async {
    countJoin = await getCountJoin(data!.acId!);

    if (mounted) {
      setState(() {});
    }
  }

  getImage() {
    if (data!.acImg != null) {
      setState(() {
        img = data!.acImg.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 5.h),
        child: data != null
            ? Container(
                child: Card(
                  clipBehavior: Clip.antiAlias,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.r),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          img == ""
                              ? Image.network(
                                  service.defult_activity_img,
                                  fit: BoxFit.cover,
                                  height: 150.h,
                                  width: double.infinity,
                                )
                              : Image.network(
                                  service.uploads + img,
                                  loadingBuilder:
                                      ((context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return SizedBox(
                                      height: 150.h,
                                      width: double.infinity,
                                      child: Center(
                                          child: CircularProgressIndicator(
                                        color: Theme.of(context).canvasColor,
                                      )),
                                    );
                                  }),
                                  fit: BoxFit.cover,
                                  filterQuality: FilterQuality.low,
                                  height: 150.h,
                                  width: double.infinity,
                                ),
                          // Ink.image(
                          //   image: img == ""
                          //       ? NetworkImage(
                          //           service.defult_activity_img,
                          //         )
                          //       : NetworkImage(
                          //           service.uploads + img,
                          //         ),
                          //   height: 100.h,
                          //   fit: BoxFit.fitWidth,
                          // ),
                          Positioned(
                            bottom: 16,
                            // right: 100,
                            left: 10,
                            child: Container(
                              // width: double.infinity,
                              // padding: EdgeInsets.all(20.0),
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Theme.of(context).canvasColor),

                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '' + data!.acName.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 18.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 16,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.2),
                                      blurRadius: 10,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                  borderRadius: BorderRadius.circular(20.r),
                                  color: Theme.of(context).canvasColor),
                              child: Padding(
                                padding: const EdgeInsets.all(5),
                                child: Text(
                                  '+' + data!.acHour.toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(
                                horizontal: 8.w, vertical: 10.h)
                            .copyWith(bottom: 0),
                        child: Row(
                          children: [
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.location_on),
                                        Flexible(
                                            child: Text(
                                          " " + data!.acLocationName.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                          ),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.person_outline),
                                        Flexible(
                                            child: Text(
                                          " โดย ${data?.acUcName ?? ""}",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                          ),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                            Icons.people_outline_outlined),
                                        Flexible(
                                            child: Text(
                                          " ผู้สนใจเข้าร่วม " +
                                              countJoin.toString() +
                                              " / " +
                                              data!.acAmount.toString(),
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                )),
                            Expanded(
                                flex: 1,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.timer),
                                        Flexible(
                                            child: Text(
                                          " เริ่ม \n " +
                                              formatter
                                                  .format(data!.acDstart!) +
                                              "น.",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                          ),
                                        )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.timer_off),
                                        Flexible(
                                            child: Text(
                                          " สิ้นสุด \n " +
                                              formatter.format(data!.acDend!) +
                                              "น.",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                          ),
                                        )),
                                      ],
                                    ),
                                  ],
                                )),
                          ],
                        ),
                      ),
                      ButtonBar(
                        alignment: MainAxisAlignment.end,
                        children: [
                          FlatButton(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20.w,
                            ),
                            minWidth: 200.w,
                            height: 40.h,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r)),
                            splashColor: Colors.red,
                            textColor: Colors.white,
                            color: Theme.of(context).canvasColor,
                            onPressed: () {
                              // print(data!.acName);
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => DetailActivityPage(
                                        data: data!,
                                      )));

                              // Navigator.push(context, route)
                            },
                            child: Text(
                              'ดูรายละเอียด',
                              style: TextStyle(
                                  fontSize: 20.sp, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            : Container(
                child: const Center(
                child: CircularProgressIndicator(),
              )));
  }
}
