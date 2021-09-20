import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/owner_app/owner_account_page.dart';

class OwnerEditHostelDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          'Edit Hostel',
          style: TextStyle(color: kLightBlackColor),
        ),
        leading: BackButton(
          color: kLightBlackColor,
        ),
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Button(text: 'Edit Hostel Details', ontap: () {}),
            Divider(),
            Button(text: 'Edit Hostel Address', ontap: () {}),
            Divider(),
            Button(text: 'Edit Hostel Rent', ontap: () {}),
            Divider(),
            Button(text: 'Edit Hostel Photos', ontap: () {}),
            Divider(),
            GestureDetector(
              onTap: () async {},
              child: Container(
                margin: EdgeInsets.only(left: 100.w, top: 50.h),
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.red.shade700, width: 1.5),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.delete_forever,
                      color: Colors.red.shade700,
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Text(
                      'Delete Hostel/PG',
                      style: TextStyle(
                          fontSize: 47.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.red.shade700),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
