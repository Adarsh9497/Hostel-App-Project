import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/owner_app/edithosteldetails_page.dart';
import 'package:hostel_app/owner_app/editprofile_page.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../change_avatar.dart';

class OwnerAccountPage extends StatefulWidget {
  @override
  _OwnerAccountPageState createState() => _OwnerAccountPageState();
}

class _OwnerAccountPageState extends State<OwnerAccountPage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(top: 70.h),
            padding: EdgeInsets.only(left: 100.w, right: 50.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CircleAvatar(
                    radius: 150.w,
                    backgroundColor: Colors.transparent,
                    child: Image.asset(
                      imageAvators + '${MySharedPref.getAvatar() + 1}.png',
                    )),
                SizedBox(
                  width: 100.w,
                ),
                ValueListenableBuilder(
                  valueListenable: HiveVariablesDB.variablesDB.listenable(),
                  builder: (context, Box<String> v, _) => Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          v.get(HiveVariablesDB.keyOwnerName) ?? "User Name",
                          style:
                              kTitleText.copyWith(fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          v.get(HiveVariablesDB.keyMobilenumber) ??
                              "Mobile Number",
                          style: kSubTitleText.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Text(
                          v.get(HiveVariablesDB.keyEmail) ?? "No Email Address",
                          style: kSubTitleText.copyWith(
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade700),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 100.h),
            child: TextButton(
              onPressed: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (_) => ChangeAvatar()))
                    .then((_) => setState(() {}));
              },
              child: Text(
                'Change Avatar',
                style: TextStyle(color: Colors.blue, fontSize: 39.sp),
              ),
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Button(
                  text: 'Edit Profile',
                  ontap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => OwnerEditProfile()));
                  }),
              Button(
                  text: 'Edit Hostel/PG',
                  ontap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => OwnerEditHostelDetails()));
                  }),
              Divider(
                thickness: 1,
              ),
              GestureDetector(
                onTap: () async {
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
                  margin: EdgeInsets.only(left: 100.w, top: 50.h),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue, width: 1.5),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    'Search Hostel/PG',
                    style: TextStyle(
                        fontSize: 50.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Button extends StatelessWidget {
  final Color colour;
  final String text;
  final Function ontap;

  Button(
      {this.colour = kBackgroundColor,
      required this.text,
      required this.ontap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: colour,
      child: InkWell(
        onTap: () => ontap(),
        child: Container(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: kSubTitleText.copyWith(fontWeight: FontWeight.w500),
              ),
              Icon(Icons.chevron_right),
            ],
          ),
          padding: EdgeInsets.symmetric(horizontal: 100.w, vertical: 50.h),
        ),
      ),
    );
  }
}
