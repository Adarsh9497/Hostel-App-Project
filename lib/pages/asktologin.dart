import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/pages/login_verify.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:lottie/lottie.dart';
import '../constants.dart';

class AskToLogin extends StatelessWidget {
  const AskToLogin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kblueColor,
      appBar: AppBar(
        backgroundColor: kblueColor,
        elevation: 0,
        title: Text(
          'Hostello',
          style: TextStyle(fontSize: 90.sp),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          //margin: EdgeInsets.only(top: 50.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Lottie.asset('asset/31938-welcome.json',
                  height: 600.h, repeat: false, reverse: false, animate: true),
              SizedBox(
                height: 70.h,
              ),
              Text(
                'Hi there fella!',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 80.sp,
                    fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 20.h,
              ),
              Text(
                'Sign up to keep your favorites and\nsync them across devices.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60.sp,
                ),
              ),
              SizedBox(
                height: 150.h,
              ),
              GestureDetector(
                onTap: () {
                  MySharedPref.setAskToLogin(false);

                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          LoginScreen(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  width: 800.w,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Sign Up with Mobile Number',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 54.sp,
                        color: kblueColor),
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              SizedBox(
                height: 10.h,
              ),
              GestureDetector(
                onTap: () {
                  MySharedPref.setAskToLogin(false);
                  Navigator.pushAndRemoveUntil(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          UserNavigator(),
                      transitionDuration: Duration(seconds: 0),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Proceed without Sign Up',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 54.sp,
                        color: Colors.white),
                  ),
                  color: kblueColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
