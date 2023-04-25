// ignore_for_file: file_names

import 'dart:developer';

import 'package:flutter/widgets.dart' show FormFieldValidator;

class Validators {
  static FormFieldValidator<String> required(String errorMessage) {
    return (value) {
      if (value!.isEmpty)
        return errorMessage;
      else
        return null;
    };
  }

  static FormFieldValidator<String> min(double min, String errorMessage) {
    return (value) {
      if (value!.trim().isEmpty)
        return null;
      else {
        final dValue = _toDouble(value);
        if (dValue < min)
          return errorMessage;
        else
          return null;
      }
    };
  }

  static FormFieldValidator<String> confirmPassword(
      bool confirmPwd, String errorMessage) {
    return (value) {
      // print(value==confirmPwd);
      // log(value!);
      //log(confirmPwd.toString());
      if (confirmPwd)
        return null;
      else {
        return errorMessage;
      }
    };
  }

  static FormFieldValidator<String> max(double max, String errorMessage) {
    return (value) {
      if (value!.trim().isEmpty)
        return null;
      else {
        final dValue = _toDouble(value);
        if (dValue > max)
          return errorMessage;
        else
          return null;
      }
    };
  }

  static FormFieldValidator<String> emailMSU(String errorMessage) {
    return (value) {
      if (value!.isEmpty)
        return null;
      else {
        final emailRegex = RegExp(r"^[0-9]+@msu.ac.th");
        if (emailRegex.hasMatch(value))
          return null;
        else
          return errorMessage;
      }
    };
  }

  static FormFieldValidator<String> email(String errorMessage) {
    return (value) {
      if (value!.isEmpty)
        return null;
      else {
        final emailRegex = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
        if (emailRegex.hasMatch(value))
          return null;
        else
          return errorMessage;
      }
    };
  }

  static FormFieldValidator<String> number(String errorMessage) {
    return (value) {
      if (value!.isEmpty)
        return null;
      else {
        final emailRegex = RegExp(r"^[0-9]*$");
        if (emailRegex.hasMatch(value))
          return null;
        else
          return errorMessage;
      }
    };
  }

  static FormFieldValidator<String> minLength(
      int minLength, String errorMessage) {
    return (value) {
      if (value!.isEmpty) return null;

      if (value.length < minLength)
        return errorMessage;
      else
        return null;
    };
  }

  static FormFieldValidator<String> equalLength(
      int equalLength, String errorMessage) {
    return (value) {
      // log(value!.length.toString());
      if (value!.isEmpty) return null;

      if (value.length != equalLength)
        return errorMessage;
      else
        return null;
    };
  }

  static FormFieldValidator<String> maxLength(
      int maxLength, String errorMessage) {
    return (value) {
      if (value!.isEmpty) return null;

      if (value.length > maxLength)
        return errorMessage;
      else
        return null;
    };
  }

  static FormFieldValidator<String> patternString(
      String pattern, String errorMessage) {
    return patternRegExp(RegExp(pattern), errorMessage);
  }

  static FormFieldValidator<String> patternRegExp(
      RegExp pattern, String errorMessage) {
    return (value) {
      if (value!.isEmpty) return null;

      if (pattern.hasMatch(value))
        return null;
      else
        return errorMessage;
    };
  }

  static FormFieldValidator<String> compose(
      List<FormFieldValidator<String>> validators) {
    return (value) {
      for (final validator in validators) {
        final result = validator(value);
        if (result != null) return result;
      }
      return null;
    };
  }

  static FormFieldValidator<String> checkList(
      String text, List<String> list, String errorMessage) {
    return (value) {
      log(list.contains(text).toString());
      if (list.contains(text)) {
        return null;
      } else {
        return errorMessage;
      }
    };
  }

  // -------------------- private functions ---------------------- //

  static double _toDouble(String value) {
    value = value.replaceAll(' ', '').replaceAll(',', '');
    return double.parse(value);
  }
}
