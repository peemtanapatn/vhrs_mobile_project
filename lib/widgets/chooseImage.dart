// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vhrs_flutter_project/pages/addDetailJoin/addDetailJoin.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/pages/update/update.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;
import 'package:http/http.dart' as http;

Future<void> uploadImage(File _image) async {
  String url = service.url;
  String upload = "/uploadImg";
  String statusCode = "";

  var pic = await http.MultipartFile.fromPath("image", _image.path);

  var request = http.MultipartRequest('POST', Uri.parse(url + upload));
  request.fields['name'] = _image.path.split("/").last;
  request.files.add(pic);
  var response = await request.send();

  if (response.statusCode == 200) {
    print("image uploaded");
  } else {
    print("image not uploaded");
    // print(response.toString());
  }
}

class ChooseImage extends StatefulWidget {
  int r1, r2, b;
  RegisterPage? registerPage;
  UpdatePage? updatePage;
  AddDetailJoinPage? addDetailJoinPage;
  ChooseImage(
      {Key? key,
      required this.r1,
      required this.r2,
      required this.b,
      required this.registerPage,
      required this.updatePage,
      required this.addDetailJoinPage})
      : super(key: key);

  @override
  State<ChooseImage> createState() => _ChooseImageState();
}

class _ChooseImageState extends State<ChooseImage> {
  final picker = ImagePicker();
  var image;

  Future openImage() async {
    var pickImage = await picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 10,
    );
    if (pickImage != null) {
      setState(() {
        image = File(pickImage.path);
        if (widget.registerPage != null) {
          widget.registerPage!.image = image;
        } else if (widget.updatePage != null) {
          widget.updatePage!.image = image;
        } else {
          widget.addDetailJoinPage!.image = image;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.registerPage != null) {
      image = widget.registerPage!.image;
    } else if (widget.updatePage != null) {
      image = widget.updatePage!.image;
    } else {
      image = widget.addDetailJoinPage!.image;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: widget.r1.r,
            child: ClipRRect(
              child: image == null || image == "null" || image == ""
                  ? Image.asset(
                      widget.r1 == 60
                          ? "assets/images/user.jpg"
                          : "assets/images/Activity.png",
                      fit: BoxFit.cover,
                    )
                  : image is String
                      ? Image.network(
                          '${service.serverPath}/VHRSservice/uploads/' + image,
                          loadingBuilder: ((context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                backgroundColor: Theme.of(context).canvasColor,
                              ),
                            );
                          }),
                          fit: BoxFit.cover,
                          height: 200.h,
                          width: 300.w,
                        )
                      : Image.file(
                          image,
                          frameBuilder: ((
                            context,
                            child,
                            frame,
                            wasSynchronouslyLoaded,
                          ) {
                            if (wasSynchronouslyLoaded) return child;
                            return AnimatedSwitcher(
                              duration: const Duration(
                                milliseconds: 200,
                              ),
                              child: frame != null
                                  ? child
                                  : SizedBox(
                                      height: 200.h,
                                      width: 300.w,
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          color: Theme.of(context).canvasColor,
                                        ),
                                      ),
                                    ),
                            );
                          }),
                          fit: BoxFit.cover,
                          height: 200.h,
                          width: 300.w,
                        ),
              borderRadius: BorderRadius.circular(widget.r2.r),
            ),
          ),
          Positioned(
              bottom: widget.b.r,
              right: 0,
              left: 0,
              child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                      onPressed: openImage,
                      icon: Icon(
                        Icons.add_photo_alternate_rounded,
                        size: 30.sp,
                        color: Colors.green,
                      )) // change this children
                  ))
        ],
      ),
    );
  }

  checkImg() {}
}
