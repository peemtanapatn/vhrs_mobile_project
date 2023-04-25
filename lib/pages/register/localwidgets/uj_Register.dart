// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:searchfield/searchfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/services/service_url.dart';
import 'package:vhrs_flutter_project/utils/theme.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/password_input.dart';
import 'package:vhrs_flutter_project/widgets/text_input.dart';

class UjRegister extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterPage registerPage;
  UjRegister({Key? key, required this.registerPage}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController stdIDController = TextEditingController();
  TextEditingController facultyController = TextEditingController();
  TextEditingController majorController = TextEditingController();
  bool confirmPwd = false;

  List<String> majorList = [];

  @override
  State<UjRegister> createState() => _UjRegisterState();
}

class _UjRegisterState extends State<UjRegister> {
  final bool _isObscurePassword = true;
  final bool _isObscureConfirmPassword = true;
  String selectMajor = "";
  String selectFaculty = "";

  @override
  void initState() {
    super.initState();
    _getEmailInit();
  }

  _getEmailInit() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    widget.emailController.text = preferences.getString("emailRegister")!;
  }

  @override
  Widget build(BuildContext context) {
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
                Validators.emailMSU(
                    "รูปแบบอีเมลไม่ถูกต้อง (ตย. 62000000000@msu.ac.th)"),
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
          PasswordInput(
              controller: widget.passwordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.minLength(8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
              ]),
              icon: Icons.lock_outline,
              hint: 'รหัสผ่าน',
              isObscurePassword: _isObscurePassword),
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
}
