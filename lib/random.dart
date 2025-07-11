import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

String getWeekDay(int day) {
  switch (day) {
    case 1:
      return "Mon";
    case 2:
      return "Tue";
    case 3:
      return "Wed";
    case 4:
      return "Thur";
    case 5:
      return "Fri";
    case 6:
      return "Sat";
    case 7:
      return "Sun";
    default:
      return "Sun";
  }
}

bool isToday(DateTime date) {
  DateTime now = DateTime.now();
  if (date.day == now.day && date.year == now.year && date.month == now.month) {
    return true;
  }
  return false;
}

String idGenerator() {
  const chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random rnd = Random();

  String getRandomString(int length) => String.fromCharCodes(
    Iterable.generate(
      length,
      (_) => chars.codeUnitAt(rnd.nextInt(chars.length)),
    ),
  );

  String id = "";
  id += getRandomString(7);

  id += DateTime.now().second.toString();
  id += DateTime.now().hour.toString();
  id += DateTime.now().day.toString();
  id += DateTime.now().month.toString();
  id += DateTime.now().year.toString().substring(3);

  return id;
}

String unitConverter(String unit) {
  if (unit == 'per 100 gm') {
    return 'gram';
  } else if (unit == 'per 100 ml') {
    return 'milliliter';
  } else if (unit == 'per piece') {
    return 'piece';
  } else {
    return 'table spoon';
  }
}

Future<bool> connectedToInternet() async {
  bool connected = await InternetConnection().hasInternetAccess;
  return connected;
}

extension DoubleExtensions on double {
  int toIntIfNoDecimal() {
    return this == truncateToDouble() ? toInt() : round();
  }

  String withoutZeroDecimal() {
    return toStringAsFixed(truncateToDouble() == this ? 0 : 1);
  }
}
