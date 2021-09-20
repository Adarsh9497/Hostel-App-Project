import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/pages/login_verify.dart';

class UserLogin extends StatelessWidget {
  const UserLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: EdgeInsets.only(top: 50.h, right: 50.w, left: 50.w),
        child: Column(
          children: [
            Align(
              alignment: Alignment.center,
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 150.h,
                child: Image.asset('images_avators/Asset 2.png'),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Divider(),
            SizedBox(
              height: 20.h,
            ),
            Container(
              child: Text(
                'Hi User,\nSign up to keep your favorites and sync them across devices.\n\nSign up to Register your Hostel/PG.',
                style: TextStyle(fontSize: 60.sp, color: Colors.grey.shade700),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Divider(),
            SizedBox(
              height: 200.h,
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
              child: Container(
                alignment: Alignment.center,
                width: 800.w,
                padding: EdgeInsets.all(15),
                child: Text(
                  'Sign Up with Mobile Number',
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 54.sp,
                      color: Colors.white),
                ),
                decoration: BoxDecoration(
                    color: kblueColor, borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
