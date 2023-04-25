// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vhrs_flutter_project/models/uc_model_provider.dart';
import 'package:vhrs_flutter_project/utils/validationField.dart';
import 'package:vhrs_flutter_project/widgets/text_input.dart';

class UcUpdate extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController jobController = TextEditingController();
  String status = "";

  UcUpdate({Key? key}) : super(key: key);

  @override
  State<UcUpdate> createState() => _UcUpdateState();
}

class _UcUpdateState extends State<UcUpdate> {
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
            controller: widget.nameController,
            compose: Validators.compose([Validators.required("กรุณากรอกชื่อ")]),
            icon: Icons.face_unlock_sharp,
            hint: "ชื่อ-นามสกุล",
            typeInput: TextInputType.name,
          ),
          TextInput(
            controller: widget.jobController,
            compose: Validators.compose([
              Validators.required("กรุณากรอกอาชีพ"),
            ]),
            icon: Icons.work,
            hint: "อาชีพ",
            typeInput: TextInputType.text,
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
          TextInput(
              controller: widget.emailController,
              compose: Validators.compose([
                Validators.required("กรุณากรอกอีเมล"),
                Validators.email("รูปแบบอีเมลไม่ถูกต้อง"),
              ]),
              icon: Icons.email_outlined,
              hint: "อีเมล",
              typeInput: TextInputType.emailAddress),
        ],
      ),
    );
  }

  setData() {
    widget.nameController.text =
        context.watch<UcModelProvider>().ucProfile.ucName;
    widget.jobController.text =
        context.watch<UcModelProvider>().ucProfile.ucJob;
    widget.phoneController.text =
        context.watch<UcModelProvider>().ucProfile.ucPhone;
    widget.emailController.text =
        context.watch<UcModelProvider>().ucProfile.ucEmail;
    widget.status = context.watch<UcModelProvider>().ucProfile.ucStatus;
  }
}
