import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/owner_app/offer_page.dart';
import 'package:hostel_app/owner_app/update_rent.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../toasts.dart';

class homewidget extends StatefulWidget {
  @override
  _homewidgetState createState() => _homewidgetState();
}

class _homewidgetState extends State<homewidget> {
  var kownerTitleStyle = TextStyle(
      fontSize: 55.sp, fontWeight: FontWeight.w500, color: kLightBlackColor);

  var kownerheadingStyle = kSubTitleText.copyWith(fontWeight: FontWeight.w500);

  var kownersubTitleStyle =
      TextStyle(fontSize: 45.sp, color: Colors.grey.shade700);

  TextEditingController _updatebeds = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _updatebeds.text = MySharedPref.getAvailableBeds() ?? '0';
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.symmetric(horizontal: 50.w, vertical: 50.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'Views',
                        style: kTitleText50,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '0',
                        style:
                            kTitleText100.copyWith(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Searches',
                        style: kTitleText50,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '0',
                        style:
                            kTitleText100.copyWith(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'Activity',
                        style: kTitleText50,
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        '0',
                        style:
                            kTitleText100.copyWith(color: Colors.grey.shade600),
                      )
                    ],
                  ),
                ],
              ),
            ),
            kdividerLine,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Post to your ${MySharedPref.getPropertyType()}',
                    style: kownerTitleStyle,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Text(
                    'Offers',
                    style: kownerheadingStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Attract new users with deals or coupon',
                      style: kownersubTitleStyle),
                  SizedBox(
                    height: 30.h,
                  ),
                  AddButton(
                    icon: Icons.add,
                    text: 'New offer',
                    ontap: () {
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              OfferPage(),
                          transitionDuration: Duration(milliseconds: 400),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            kdividerLine,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 60.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add Update',
                    style: kownerTitleStyle,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Text(
                    'Update beds available',
                    style: kownerheadingStyle,
                  ),
                  SizedBox(
                    height: 5.h,
                  ),
                  Text('Update to number of beds currently available',
                      style: kownersubTitleStyle),
                  SizedBox(
                    height: 30.h,
                  ),
                  Form(
                    key: _formKey,
                    child: Container(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: SizedBox(
                              width: 400.w,
                              child: TextFormField(
                                autovalidateMode:
                                    AutovalidateMode.onUserInteraction,
                                controller: _updatebeds,
                                validator: (val) {
                                  if (val == null || val.isEmpty) return '';

                                  RegExp r = RegExp(r'^[0-9]+$');
                                  if (!r.hasMatch(val)) return 'Invalid value';

                                  return null;
                                },
                                onChanged: (val) {
                                  if (_formKey.currentState!.validate())
                                    setState(() {
                                      isButtonDisabled = false;
                                    });
                                  else {
                                    setState(() {
                                      isButtonDisabled = true;
                                    });
                                  }
                                },
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  isDense: true,
                                  icon: Icon(
                                    FontAwesomeIcons.bed,
                                    size: 20,
                                    color: Colors.blue,
                                  ),
                                  hintText: 'beds',
                                  errorStyle: TextStyle(
                                      fontSize: 15, color: Colors.red[900]),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 8),
                                ),
                                style: TextStyle(fontSize: 50.sp, height: 1.5),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 50.w,
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                minimumSize: Size(10, 30)),
                            onPressed: isButtonDisabled
                                ? null
                                : () {
                                    setState(() {
                                      MySharedPref.setAvailableBeds(
                                          _updatebeds.text);
                                      showToast(
                                        message: "Available Beds Updated",
                                      );

                                      isButtonDisabled = true;
                                    });
                                  },
                            child: Text(
                              'Save',
                              style: TextStyle(color: kBackgroundColor),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 50.h, bottom: 50.h),
                    width: double.infinity,
                    height: 2.h,
                    color: Color(0xffDBDBDB),
                  ),
                  Text(
                    'Update rent',
                    style: kownerTitleStyle,
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  AddButton(
                      icon: Icons.edit,
                      iconSize: 60,
                      text: ' New rent ',
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => OwnerUpdateRent()));
                      })
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final int iconSize;
  final Function ontap;

  AddButton(
      {required this.icon,
      required this.text,
      required this.ontap,
      this.iconSize = 70});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: () => ontap(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 30.w),
          height: 85.h,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue),
              borderRadius: BorderRadius.circular(30)),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(
                icon,
                size: iconSize.sp,
                color: Colors.blue,
              ),
              SizedBox(
                width: 20.w,
              ),
              Text(
                text,
                style: kSubTitleText,
              )
            ],
          ),
        ),
      ),
    );
  }
}
