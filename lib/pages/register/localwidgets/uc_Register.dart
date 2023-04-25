// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vhrs_flutter_project/pages/register/register.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/password_input.dart';
import 'package:vhrs_flutter_project/widgets/text_input.dart';

class UcRegister extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  RegisterPage registerPage;
  UcRegister({Key? key, required this.registerPage}) : super(key: key);

  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  bool confirmPwd = false;

  @override
  State<UcRegister> createState() => _UcRegisterState();
}

class _UcRegisterState extends State<UcRegister> {
  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

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
                Validators.email("รูปแบบอีเมลไม่ถูกต้อง"),
              ]),
              icon: Icons.email_outlined,
              hint: "อีเมล",
              typeInput: TextInputType.emailAddress),
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
          PasswordInput(
              controller: widget.passwordController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกรหัสผ่าน"),
                Validators.minLength(8, "รหัสผ่านควรมีความยาวมากกว่า 8 อักษร")
              ]),
              icon: Icons.lock_outline,
              hint: 'รหัสผ่าน',
              isObscurePassword: _isObscurePassword),
          TextInput(
            controller: widget.jobController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกอาชีพ"),
            ]),
            icon: Icons.work,
            hint: "อาชีพ",
            typeInput: TextInputType.text,
          ),
          // PasswordInput(
          //     controller: widget.confirmPasswordController,
          //     compose: Validators.compose([
          //       Validators.required("กรุณากรอกรหัสผ่าน"),
          //       Validators.confirmPassword(
          //          widget.confirmPwd, "รหัสผ่านไม่ตรงกัน")
          //     ]),
          //     icon: Icons.lock_outline,
          //     hint: 'ยืนยันรหัสผ่าน',
          //     isObscurePassword: _isObscureConfirmPassword),
        ],
      ),
    );
  }
}
