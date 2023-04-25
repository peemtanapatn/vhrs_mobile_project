import 'dart:collection';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
import 'package:vhrs_flutter_project/models/ujAndJoinActivity_model.dart';
import 'package:vhrs_flutter_project/pages/manageUserJoin/localwidgets/dialogDetailJoin.dart';

import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;

class ManageUjPage extends StatefulWidget {
  String acId;
  ManageUjPage({Key? key, required this.acId}) : super(key: key);

  List<UjAndJoinActivityModel> joinActivityModel = [];
  List<UjAndJoinActivityModel> dataJoinActivity = [];

  @override
  State<ManageUjPage> createState() => _ManageUjPageState();
}

class _ManageUjPageState extends State<ManageUjPage> {
  bool checkDetailFully = false;
  bool checkAllDetailFull = false;

  HashSet<UjAndJoinActivityModel> selectedItem = HashSet();
  bool isMutiSelectEnabled = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // selectedItem.clear();
    getJoinActivity();
  }

  Future getJoinActivity() async {
    log("test : " + widget.dataJoinActivity.toString());
    try {
      var response = await http.post(
          Uri.parse(service.url + "/getJoinActivityAndUjProfileById"),
          body: {
            "acId": widget.acId,
          });
      if (response.statusCode == 200 && response.body != "Dont have") {
        if (mounted) {
          setState(() {
            widget.joinActivityModel =
                ujAndJoinActivityModelFromJson(response.body);
            widget.joinActivityModel
                .sort((a, b) => a.jaStatus!.compareTo(b.jaStatus.toString()));
            widget.dataJoinActivity = widget.joinActivityModel;
          });
        }
      }
      setState(() {});
    } catch (e) {
      log(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Theme.of(context).secondaryHeaderColor,
        title: Text(
          "ตรวจสอบผู้เข้าร่วมกิจกรรม",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        // actions: [Text(joinActivityCard!.selectedItem!.length.toString())],
      ),
      body: Column(children: [
        Visibility(
          visible: widget.joinActivityModel.isNotEmpty,
          child: Theme(
            data:
                Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
            child: Container(
              height: 35.h,
              child: CheckboxListTile(
                title: Text("แสดงผู้เข้าร่วมที่เพิ่มรายละเอียดครบถ้วน",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.w,
                    )),
                controlAffinity: ListTileControlAffinity.leading,
                value: checkDetailFully,
                onChanged: (bool? value) {
                  setState(() {
                    checkDetailFully = value!;
                    setDataSelectedCheckbox();
                  });
                },
                checkColor: Colors.white,
                activeColor: Colors.green,
              ),
            ),
          ),
        ),
        Visibility(
          visible: widget.joinActivityModel.isNotEmpty,
          child: Theme(
              data: Theme.of(context)
                  .copyWith(unselectedWidgetColor: Colors.white),
              child: Container(
                height: 40.h,
                child: CheckboxListTile(
                  title:
                      Text("เลือกผู้เข้าร่วมที่เพิ่มรายละเอียดครบถ้วนทั้งหมด",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.w,
                          )),
                  controlAffinity: ListTileControlAffinity.leading,
                  value: checkAllDetailFull,
                  onChanged: (bool? value) {
                    setState(() {
                      checkAllDetailFull = value!;
                      setDataSelectedCheckbox();
                    });
                  },
                  checkColor: Colors.white,
                  activeColor: Colors.green,
                ),
              )),
        ),
        Expanded(
          child: Container(
              child: widget.dataJoinActivity.isEmpty
                  ? const Center(
                      child: Text("ยังไม่มีผู้เข้าร่วมกิจกรรมในรายการนี้...",
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16)),
                    )
                  : Container(
                      child: ListView.builder(
                          itemCount: widget.dataJoinActivity.length,
                          itemBuilder: (context, index) {
                            return listJoinActivityCard(
                                // key: ValueKey(
                                //     widget.dataJoinActivity[index].jaId),
                                // model:
                                widget.dataJoinActivity[index]);
                          }),
                    )),
        ),
        if (selectedItem.isNotEmpty)
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
                padding: EdgeInsets.all(8.w),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  RaisedButton(
                    onPressed: () async {
                      await upDateStatus();
                      // widget.dataJoinActivity.clear();
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => ManageUjPage(
                                    acId: widget.acId,
                                  )));
                      // await getJoinActivity();
                      // setState(() {});
                      ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
                        content: const Text('ยืนยันการเข้าร่วมสำเร็จ!'),
                      ));
                    },
                    color: Colors.green,
                    textColor: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text('ยืนยัน' + getSelectedItemCount(),
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp))),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  RaisedButton(
                    onPressed: () {
                      selectedItem.clear();
                      checkAllDetailFull = false;
                      setState(() {});
                    },
                    color: Colors.red,
                    textColor: Colors.white,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Text('ยกเลิก',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp))),
                  ),
                ])),
          ),
      ]),
    );
  }

  Future upDateStatus() async {
    ProgressDialog pd = ProgressDialog(context: context);
    pd.show(max: 80, msg: 'โปรดรอสักครู่...');
    for (var join in selectedItem) {
      var res = await http
          .post(Uri.parse(service.url + "/update_statusJoinPass"), body: {
        "status": "ยืนยันการเข้าร่วม",
        "id": join.jaId.toString(),
      });
    }
    pd.close();
    // setState(() {});
  }

  setDataSelectedCheckbox() {
    if (checkDetailFully == true) {
      widget.dataJoinActivity = widget.joinActivityModel
          .where((join) => join.jaDetail!.isNotEmpty)
          .toList();
      selectedCheckAddDetailAll();
    } else {
      widget.dataJoinActivity = widget.joinActivityModel;
      selectedCheckAddDetailAll();
    }
    setState(() {});
  }

  selectedCheckAddDetailAll() {
    if (checkAllDetailFull == true) {
      List<UjAndJoinActivityModel> checkAll = widget.joinActivityModel
          .where((join) => join.jaDetail!.isNotEmpty)
          .toList();
      checkAll.forEach((all) async {
        if (all.jaStatus == "") {
          selectedItem.add(all);
        }
      });
    } else {
      selectedItem.clear();
    }
  }
  /////////////////////////////////////////////////////Join activity card/////////////////////////////////////////
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  void doMultiSelection(UjAndJoinActivityModel model) {
    // if (isMutiSelectEnabled) {
    if (selectedItem.contains(model)) {
      selectedItem.remove(model);
    } else {
      if (model.jaStatus == "") {
        selectedItem.add(model);
      }
    }
    setState(() {});
    // } else {}
  }

  String getSelectedItemCount() {
    return selectedItem.isNotEmpty
        ? " (" + selectedItem.length.toString() + " รายการ)"
        : "";
  }

  listJoinActivityCard(UjAndJoinActivityModel data) {
    return InkWell(
      onTap: () {
        doMultiSelection(data);
      },
      // onLongPress: () {
      //   isMutiSelectEnabled = true;
      //   doMultiSelection(data!);
      // },
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          child: data != null
              ? Card(
                  elevation: 5.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.r)),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: profileCircleAvatar(
                                        data.ujImg.toString())),
                                SizedBox(width: 10.w),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(data.ujName.toString(),
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 18.w,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                    Row(children: [
                                      Icon(
                                        Icons.email,
                                        color:
                                            Color.fromARGB(255, 170, 170, 170),
                                        size: 24.w,
                                        semanticLabel:
                                            'Text to announce in accessibility modes',
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(data.jaUjEmail.toString(),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 108, 108, 108),
                                            fontSize: 16.w,
                                          ))
                                    ]),
                                    Row(children: [
                                      Icon(
                                        Icons.call,
                                        color:
                                            Color.fromARGB(255, 170, 170, 170),
                                        size: 24.w,
                                        semanticLabel:
                                            'Text to announce in accessibility modes',
                                      ),
                                      SizedBox(width: 5.w),
                                      Text(data.ujPhone.toString(),
                                          style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 108, 108, 108),
                                            fontSize: 16.w,
                                          ))
                                    ])
                                  ],
                                ),
                              ]),
                          Container(
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 0),
                              child: data.jaStatus == "ยืนยันการเข้าร่วม"
                                  ? Row(
                                      children: [
                                        Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 24.w,
                                          semanticLabel:
                                              'Text to announce in accessibility modes',
                                        ),
                                        Text("ยืนยันแล้ว",
                                            style: TextStyle(
                                              color: Colors.green,
                                              fontSize: 16.w,
                                            )),
                                      ],
                                    )
                                  : Visibility(
                                      visible:
                                          data.jaStatus != "ยืนยันการเข้าร่วม",
                                      child: Icon(
                                        selectedItem.contains(data)
                                            ? Icons.check_circle
                                            : Icons.radio_button_unchecked,
                                        size: 24.w,
                                        color: Colors.green,
                                      ),
                                    ))
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Container(
                        width: 370.w,
                        height: 35.h,
                        child: RaisedButton(
                          onPressed: () {
                            showDialogDetailJoin(context, data);
                          },
                          child: Text("ตรวจสอบการข้าร่วมกิจกรรม",
                              style: TextStyle(
                                color: Color.fromARGB(255, 255, 255, 255),
                                fontSize: 15.w,
                              )),
                        ),
                      )
                    ]),
                  ))
              : Container(
                  child: Center(
                  child: CircularProgressIndicator(),
                ))),
    );
  }

  profileCircleAvatar(String img) {
    return CircleAvatar(
        backgroundColor: Colors.white,
        radius: 40.r,
        child: ClipRRect(
          child: img != null && img != ""
              ? Image.network(
                  service.uploads + img,
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 300.w,
                )
              : Image.asset(
                  "assets/images/user.jpg",
                  fit: BoxFit.cover,
                  height: 200.h,
                  width: 300.w,
                ),
          borderRadius: BorderRadius.circular(80.r),
        ));
  }

  showDialogDetailJoin(BuildContext context, UjAndJoinActivityModel model) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r)),
              child: DialogDetailJoin(
                model: model,
              ));
        });
  }
}
