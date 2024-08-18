
import 'package:flutter/material.dart';

extension StringCasingExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String toTitleCase() => replaceAll(RegExp(' +'), ' ')
      .split(' ')
      .map((str) => str.toCapitalized())
      .join(' ');
  bool isValidEmail() {
    return RegExp(
            r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
        .hasMatch(this);
  }

  bool isValidContact() {
    return (length == 10) ? true : false;
  }

  String getInitials({int? limitTo}) {
    var buffer = StringBuffer();
    var split = this.split(' ');
    for (var i = 0; i < (limitTo ?? split.length); i++) {
      buffer.write(split[i][0]);
    }

    return buffer.toString();
  }
}

extension ScreenSize on BuildContext {
  double get screenWidth => MediaQuery.of(this).size.width;// device width
  double get screenHeight => MediaQuery.of(this).size.height; // device height
  Size get screenSize => MediaQuery.of(this).size;// device Size
}

Map<int, String> monthsInYear = {
  1: "January",
  2: "February",
  3: "March",
  4: "April",
  5: "May",
  6: "June",
  7: "July",
  8: "August",
  9: "September",
  10: "October",
  11: "November",
  12: "December"
};


  List<Map<String, dynamic>> genderList = [
    {"name": "Male", "input": 1},
    {"name": "Female", "input": 2},
    {"name": "Transgender", "input": 3},
    {"name": "Other", "input": 4},
  ];
  List<Map<String, dynamic>> marriageStatusList = [
    {"name": "Married", "input": 1},
    {"name": "Unmarried", "input": 2},
    {"name": "Divorcee", "input": 3},
     {"name": "Widowed", "input": 4},
  ];