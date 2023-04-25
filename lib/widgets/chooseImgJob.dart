import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/pages/update/update.dart';
import 'package:vhrs_flutter_project/services/service_url.dart' as service;

class ChooseImgJob extends StatefulWidget {
  RegisterPage? registerPage;
  UpdatePage? updatePage;
  ChooseImgJob({Key? key, required this.registerPage, required this.updatePage})
      : super(key: key);

  @override
  State<ChooseImgJob> createState() => _ChooseImgJobState();
}

class _ChooseImgJobState extends State<ChooseImgJob> {
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
          widget.registerPage!.imageJob = image;
        } else if (widget.updatePage != null) {
          widget.updatePage!.imageJob = image;
        }
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.registerPage != null) {
      image = widget.registerPage!.imageJob;
    } else if (widget.updatePage != null) {
      image = widget.updatePage!.imageJob;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            radius: 120.r,
            child: ClipRRect(
              child: image == null || image == "null" || image == ""
                  ? Image.asset(
                      "assets/images/cardjob.jpg",
                      fit: BoxFit.cover,
                    )
                  : image is String
                      ? Image.network(
                          '${service.serverPath}/VHRSservice/uploads/' + image,
                          loadingBuilder: ((context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                color: Theme.of(context).canvasColor,
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
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          Positioned(
              bottom: 0.r,
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
}
