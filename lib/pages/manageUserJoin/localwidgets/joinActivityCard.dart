// import 'dart:collection';
// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:vhrs_flutter_project/models/ujAndJoinActivity_model.dart';
// import 'package:vhrs_flutter_project/pages/manageUserJoin/localwidgets/dialogDetailJoin.dart';
// import 'package:vhrs_flutter_project/pages/manageUserJoin/manageUj.dart';
// import 'package:vhrs_flutter_project/services/service_url.dart' as service;
// import 'package:http/http.dart' as http;

// class JoinActivityCard extends StatefulWidget {
//   UjAndJoinActivityModel model;
//   JoinActivityCard({Key? key, required this.model}) : super(key: key);

//   @override
//   State<JoinActivityCard> createState() => _JoinActivityCardState(this.model);
// }

// class _JoinActivityCardState extends State<JoinActivityCard> {
//   UjAndJoinActivityModel? data;
//   bool checkDetailFully = false;
//   String img = "";
//   _JoinActivityCardState(UjAndJoinActivityModel model) {
//     data = model;
//   }
//   HashSet<UjAndJoinActivityModel> selectedItem = HashSet();
//   bool isMutiSelectEnabled = false;

//   void doMultiSelection(UjAndJoinActivityModel model) {
//     // if (isMutiSelectEnabled) {
//     if (selectedItem.contains(model)) {
//       selectedItem.remove(model);
//     } else {
//       selectedItem.add(model);
//     }
//     log(getSelectedItemCount());
//     setState(() {});
//     // } else {}
//   }

//   String getSelectedItemCount() {
//     return selectedItem.isNotEmpty
//         ? selectedItem.length.toString() + " รายการ"
//         : "";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return InkWell(
//       onTap: () {
//         doMultiSelection(data!);
//       },
//       // onLongPress: () {
//       //   isMutiSelectEnabled = true;
//       //   doMultiSelection(data!);
//       // },
//       child: Padding(
//           padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
//           child: data != null
//               ? Card(
//                   elevation: 5.0,
//                   shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5.r)),
//                   child: Container(
//                     width: MediaQuery.of(context).size.width,
//                     padding:
//                         EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
//                     child: Column(children: [
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Container(child: profileCircleAvatar()),
//                                 SizedBox(width: 10.w),
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Row(
//                                       mainAxisAlignment:
//                                           MainAxisAlignment.spaceBetween,
//                                       children: [
//                                         Text(data!.ujName.toString(),
//                                             style: TextStyle(
//                                                 color: Colors.black,
//                                                 fontSize: 18.w,
//                                                 fontWeight: FontWeight.bold)),
//                                       ],
//                                     ),
//                                     Row(children: [
//                                       Icon(
//                                         Icons.email,
//                                         color:
//                                             Color.fromARGB(255, 170, 170, 170),
//                                         size: 24.w,
//                                         semanticLabel:
//                                             'Text to announce in accessibility modes',
//                                       ),
//                                       SizedBox(width: 5.w),
//                                       Text(data!.jaUjEmail.toString(),
//                                           style: TextStyle(
//                                             color: Color.fromARGB(
//                                                 255, 108, 108, 108),
//                                             fontSize: 16.w,
//                                           ))
//                                     ]),
//                                     Row(children: [
//                                       Icon(
//                                         Icons.call,
//                                         color:
//                                             Color.fromARGB(255, 170, 170, 170),
//                                         size: 24.w,
//                                         semanticLabel:
//                                             'Text to announce in accessibility modes',
//                                       ),
//                                       SizedBox(width: 5.w),
//                                       Text(data!.ujPhone.toString(),
//                                           style: TextStyle(
//                                             color: Color.fromARGB(
//                                                 255, 108, 108, 108),
//                                             fontSize: 16.w,
//                                           ))
//                                     ])
//                                   ],
//                                 ),
//                               ]),
//                           Container(
//                               alignment: Alignment.topRight,
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: 10, vertical: 0),
//                               child: data!.jaStatus == "ยืนยันการเข้าร่วม"
//                                   ? Row(
//                                       children: [
//                                         Icon(
//                                           Icons.check_circle,
//                                           color: Colors.green,
//                                           size: 24.w,
//                                           semanticLabel:
//                                               'Text to announce in accessibility modes',
//                                         ),
//                                         Text("ยืนยันแล้ว",
//                                             style: TextStyle(
//                                               color: Colors.green,
//                                               fontSize: 16.w,
//                                             )),
//                                       ],
//                                     )
//                                   : Visibility(
//                                       // visible: isMutiSelectEnabled,
//                                       child: Icon(
//                                         selectedItem.contains(data)
//                                             ? Icons.check_circle
//                                             : Icons.radio_button_unchecked,
//                                         size: 24.w,
//                                         color: Colors.red,
//                                       ),
//                                     ))
//                         ],
//                       ),
//                       SizedBox(height: 10.h),
//                       Container(
//                         width: 370.w,
//                         height: 35.h,
//                         child: RaisedButton(
//                           onPressed: () {
//                             showDialogDetailJoin(context);
//                           },
//                           child: Text("ตรวจสอบการข้าร่วมกิจกรรม",
//                               style: TextStyle(
//                                 color: Color.fromARGB(255, 255, 255, 255),
//                                 fontSize: 15.w,
//                               )),
//                         ),
//                       )
//                     ]),
//                   ))
//               : Container(
//                   child: Center(
//                   child: CircularProgressIndicator(),
//                 ))),
//     );
//   }

//   profileCircleAvatar() {
//     return CircleAvatar(
//         backgroundColor: Colors.white,
//         radius: 40.r,
//         child: ClipRRect(
//           child: data!.ujImg.toString() != null || data!.ujImg.toString() != ""
//               ? Image.network(
//                   service.uploads + data!.ujImg.toString(),
//                   fit: BoxFit.cover,
//                   height: 200.h,
//                   width: 300.w,
//                 )
//               : Image.asset(
//                   "assets/images/user.jpg",
//                   fit: BoxFit.cover,
//                   height: 200.h,
//                   width: 300.w,
//                 ),
//           borderRadius: BorderRadius.circular(80.r),
//         ));
//   }

//   showDialogDetailJoin(BuildContext context) {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) {
//           return Dialog(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(20.r)),
//               child: DialogDetailJoin(
//                 model: data!,
//               ));
//         });
//   }
// }
