// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:searchfield/searchfield.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/models/uj_model_provider.dart';
import 'package:vhrs_flutter_project/services/service_url.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/text_input.dart';

class UjUpdate extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController stdIDController = TextEditingController();
  TextEditingController facultyController = TextEditingController();
  TextEditingController majorController = TextEditingController();

  List<String> majorList = [];

  UjUpdate({Key? key}) : super(key: key);

  @override
  State<UjUpdate> createState() => _UjUpdateState();
}

class _UjUpdateState extends State<UjUpdate> {
  String selectMajor = "";
  String selectFaculty = "";
  int n = 0;

  @override
  Widget build(BuildContext context) {
    setData();
    return Form(
      key: widget.formKey,
      child: Wrap(
        spacing: 20,
        runSpacing: 20,
        children: [
          TextInput(
              controller: widget.emailController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกอีเมล"),
                Validators.email("รูปแบบอีเมลไม่ถูกต้อง"),
              ]),
              icon: Icons.email_outlined,
              hint: "อีเมล",
              typeInput: TextInputType.emailAddress),
          TextInput(
            controller: widget.stdIDController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกรหัสประจำตัวนิสิต"),
              Validators.number(
                  "กรุณากรอกรหัสประจำตัวนิสิตให้เป็นตัวเลขทั้งหมด"),
              Validators.equalLength(11, "รหัสประจำตัวนิสิตต้องมี 11 หลัก")
            ]),
            icon: Icons.badge_outlined,
            hint: "รหัสประจำตัวนิสิต",
            typeInput: TextInputType.number,
          ),
          TextInput(
            controller: widget.nameController,
            compose: Validators.compose([Validators.required("กรุณากรอกชื่อ")]),
            icon: Icons.face_unlock_sharp,
            hint: "ชื่อ-นามสกุล",
            typeInput: TextInputType.name,
          ),
          TextInput(
            controller: widget.phoneController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกเบอร์โทรศัพท์"),
              Validators.number("กรุณากรอกเบอร์โทรศัพท์ให้เป็นตัวเลขทั้งหมด"),
              Validators.equalLength(10, "เบอร์โทรศัพท์ต้อง 10 หลัก"),
            ]),
            icon: Icons.phone_android_outlined,
            hint: "เบอร์โทรศัพท์",
            typeInput: TextInputType.number,
          ),
          dropdownSearch(
            widget.facultyController,
            "คณะ",
            selectFaculty,
            // widget.facultyList,
            dataFacultyAndMajor.keys.toList(),
            Icon(
              Icons.business,
              size: 18.sp,
            ),
          ),
          dropdownSearch(
            widget.majorController,
            "สาขา",
            selectMajor,
            majorList,
            Icon(
              Icons.bookmarks_outlined,
              size: 18.sp,
            ),
          ),
        ],
      ),
    );
  }

  dropdownSearch(TextEditingController controller, String hint,
      String selectItem, List<String> list, Icon icon) {
    return Container(
      child: SearchField(
          searchStyle: TextStyle(fontSize: 20.sp),
          suggestionStyle: TextStyle(fontSize: 20.sp),
          controller: controller,
          validator: Validators.compose([
            if (hint == "สาขา" && widget.facultyController.text == "")
              Validators.required("กรุณากรอกข้อมูลในช่องคณะก่อน"),
            Validators.required("กรุณากรอก" + hint),
            Validators.checkList(
                controller.text, list, "ไม่มีข้อมูลของ" + hint + "นี้")
          ]),
          hint: hint,
          searchInputDecoration: theme_InputDecoration(
            icon.icon,
            Icons.arrow_drop_down,
            hint,
            Theme.of(context).canvasColor,
          ),
          suggestionState: SuggestionState.enabled,
          maxSuggestionsInViewPort: 3,
          itemHeight: 50,
          suggestionsDecoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          onTap: (value) {
            setState(() {
              selectItem = value!;
              if (hint == "คณะ") {
                majorList = dataFacultyAndMajor[widget.facultyController.text]!
                    .toList();
              }
            });

            print(value);
          },
          suggestions: list),
    );
  }

  setData() {
    if (n <= 1) {
      selectFaculty = context.watch<UjModelProvider>().ujProfile.ujFaculty;
      if (selectFaculty != "") {
        majorList = dataFacultyAndMajor[selectFaculty]!.toList();
      }
      widget.emailController.text =
          context.watch<UjModelProvider>().ujProfile.ujEmail;
      widget.nameController.text =
          context.watch<UjModelProvider>().ujProfile.ujName;
      widget.phoneController.text =
          context.watch<UjModelProvider>().ujProfile.ujPhone;
      widget.stdIDController.text =
          context.watch<UjModelProvider>().ujProfile.ujIdstd;
      widget.facultyController.text =
          context.watch<UjModelProvider>().ujProfile.ujFaculty;
      widget.majorController.text =
          context.watch<UjModelProvider>().ujProfile.ujMajor;
    }

    n = n + 1;
  }
}
