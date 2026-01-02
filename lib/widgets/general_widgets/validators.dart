import 'dart:math';

class Validators {
  static bool isStringNotEmpty(String? value, [bool isRequired = true]) {
    if (isRequired) {
      if ((value == null) || (value.isEmpty)) {
        return false;
      }
    }
    return true;
  }

  static bool isIntNotEmpty(String? value, [bool isRequired = true]) {
    if (isRequired) {
      if ((value != null) || (value!.isNotEmpty)) {
        if (RegExp(r'^[1-9][0-9]*$').hasMatch(value)) {
          return true;
        }
      }
    }
    return false;
  }

  static bool isEmail(String? value) {
    if (isStringNotEmpty(value)) {
      if (RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
          .hasMatch(value!)) {
        return true;
      }
    }
    return false;
  }

  static bool isPassword(String? value, [String? first]) {
    if (isStringNotEmpty(value)) {
      if (value!.length >= 5) {
        if (first != null) {
          return value == first;
        }
        return true;
      }
    }
    return false;
  }

  static bool isPhoneNumber(String? value) {
    if (isInt(value)) {
      if (value!.length == 8) {
        return true;
      }
    }
    return false;
  }

  static bool isDouble(String? value) {
    if (value == null) {
      return false;
    }
    return double.tryParse(value) != null;
  }

  static bool isInt(String? value) {
    if (value == null) {
      return false;
    }
    return int.tryParse(value) != null;
  }

  static bool isCount(String? value) {
    if (value == null) {
      return false;
    }
    int? n = int.tryParse(value);
    return n == null ? false : n > 0;
  }
}

final Random random = Random();
