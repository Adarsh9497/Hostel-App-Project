import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/owner_form/data_provider.dart';
import 'package:provider/provider.dart';

class AppbarBottom extends StatelessWidget {
  AppbarBottom({
    required this.text,
    this.isUnderlined = false,
  });

  final bool isUnderlined;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(bottom: 10.h),
        decoration: (isUnderlined)
            ? BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: kBackgroundColor,
                    width: 3.0,
                  ),
                ),
              )
            : null,
        child: Text(text,
            style: TextStyle(
              color: (isUnderlined) ? kBackgroundColor : Colors.blueGrey[50],
              fontSize: (isUnderlined) ? 50.sp : 45.sp,
              fontWeight: (isUnderlined) ? FontWeight.bold : FontWeight.normal,
            )),
      ),
    );
  }
}

class RadioButtonBox extends StatelessWidget {
  final Color bordercolour;
  final Color textcolour;
  final String text;
  final Color backgroundcolour;
  final Function() onPressed;

  RadioButtonBox(
      {this.backgroundcolour = Colors.white,
      required this.text,
      required this.onPressed,
      this.bordercolour = Colors.grey,
      this.textcolour = Colors.black87});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 17.h, horizontal: 50.w),
        child: Center(
          child: Text(
            text,
            style: TextStyle(color: textcolour, fontSize: 40.sp),
          ),
        ),
        decoration: BoxDecoration(
            border: Border.all(color: bordercolour),
            color: backgroundcolour,
            borderRadius: BorderRadius.circular(20.0)),
      ),
    );
  }
}

Future<bool> onWillPop(BuildContext context) async {
  return (await showDialog(
        context: context,
        builder: (context) => new AlertDialog(
          title: new Text('Discard your Progress?'),
          //content: new Text('Do you want to exit an App'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: new Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Provider.of<DataProvider>(context, listen: false)
                    .deleteProviderData();
                Navigator.of(context).pop(true);
              },
              child: new Text('Discard'),
            ),
          ],
        ),
      )) ??
      false;
}
