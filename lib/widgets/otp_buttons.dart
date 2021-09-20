import 'package:flutter/material.dart';
import 'package:hostel_app/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

SizedBox OtpButtons({required Widget child, required Function ontap}) {
  return SizedBox(
    width: 0.5.sw,
    height: 130.h,
    child: RaisedButton(
      onPressed: () async {
        ontap();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: child,
      color: kDarkblueColor,
    ),
  );
}
