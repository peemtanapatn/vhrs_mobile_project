import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PasswordInput extends StatefulWidget {
  final TextEditingController controller;
  final FormFieldValidator<String> compose;
  final IconData icon;
  final String hint;
  bool isObscurePassword;
  PasswordInput({
    Key? key,
    required this.controller,
    required this.compose,
    required this.icon,
    required this.hint,
    required this.isObscurePassword,
  }) : super(key: key);
  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isObscurePassword,
      style: TextStyle(fontSize: 20.sp),
      // onSaved: (newValue) => _passwordController,
      controller: widget.controller,
      decoration: InputDecoration(
        prefixIcon: Icon(
          widget.icon,
          size: 20.sp,
          color: Theme.of(context).canvasColor,
        ),
        suffixIcon: IconButton(
            onPressed: () {
              widget.isObscurePassword = hide(widget.isObscurePassword);
            },
            icon: Icon(
              widget.isObscurePassword
                  ? Icons.visibility
                  : Icons.visibility_off,
              size: 20.sp,
              color: Theme.of(context).canvasColor,
            )),
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
      validator: widget.compose,
    );
  }

  bool hide(bool isObscure) {
    setState(() {
      isObscure = !isObscure;
    });

    return isObscure;
  }
}
