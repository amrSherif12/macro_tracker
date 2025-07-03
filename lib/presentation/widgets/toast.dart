import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void toastBuilder(String text, BuildContext context) {
  Fluttertoast.cancel();
  Fluttertoast.showToast(
    msg: text,
    backgroundColor: Colors.black.withOpacity(0.7),
    toastLength: Toast.LENGTH_SHORT,
    fontSize: 15,
  );
}
