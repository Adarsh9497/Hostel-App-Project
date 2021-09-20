import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants.dart';

class HostelBox extends StatelessWidget {
  const HostelBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      children: [
        Container(
          color: Colors.grey,
          height: 450.h,
          width: double.infinity,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 50.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(top: 20.h, bottom: 10.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Container(
                        child: Text(
                          'Hostel Name 1',
                          style: TextStyle(
                              fontSize: 57.sp,
                              color: kLightBlackColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 50.w,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 30.w, vertical: 15.h),
                      color: Colors.blue,
                      child: Text(
                        'Boys',
                        style:
                            kSubSubTitleText.copyWith(color: kBackgroundColor),
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Sector B, Indrapuri, Bhopal',
                style: TextStyle(
                  fontSize: 53.sp,
                  color: Colors.grey.shade800,
                ),
              ),
              SizedBox(
                height: 30.h,
              ),
              Text(
                '₹ 3000/bed',
                style: TextStyle(
                    fontSize: 57.sp,
                    color: kLightBlackColor,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 30.h,
              ),
            ],
          ),
        ),
        Container(
          color: Colors.grey.shade300,
          height: 8,
        )
      ],
    ));
  }
}
