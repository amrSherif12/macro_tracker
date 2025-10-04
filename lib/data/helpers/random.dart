import 'dart:math';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';


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
    return 'grams';
  } else if (unit == 'per 100 ml') {
    return 'milliliters';
  } else if (unit == 'per piece') {
    return 'pieces';
  } else {
    return 'table spoons';
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
