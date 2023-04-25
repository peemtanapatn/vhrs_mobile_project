import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextInput extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> compose;
  final IconData icon;
  final String hint;
  final TextInputType typeInput;
  const TextInput({
    Key? key,
    required this.controller,
    required this.compose,
    required this.icon,
    required this.hint,
    required this.typeInput,
  }) : super(key: key);

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: TextStyle(
        fontSize: 20.sp,
        color: Colors.black,
      ),
      controller: widget.controller,
      validator: widget.compose,
      keyboardType: widget.typeInput,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          size: 20.sp,
          color: Theme.of(context).canvasColor,
        ),
        hintText: widget.hint,
        label: Text(
          widget.hint,
          style: TextStyle(
            fontSize: 18.sp,
            color: Theme.of(context).canvasColor,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20.r),
          borderSide: BorderSide(
            color: Theme.of(context).canvasColor,
          ),
        ),
      ),
    );
  }
}
