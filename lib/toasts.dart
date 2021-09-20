import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

void showToast({required String message, String gravity = 'bottom'}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: (gravity == 'top')
          ? ToastGravity.TOP
          : (gravity == 'center' ? ToastGravity.CENTER : ToastGravity.BOTTOM),
      timeInSecForIosWeb: 1,
      backgroundColor: Color(0xff515151),
      textColor: Colors.white,
      fontSize: 15.0);
}
