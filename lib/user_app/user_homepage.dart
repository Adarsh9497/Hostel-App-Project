import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/owner_app/owner_navigationbar.dart';
import 'package:hostel_app/owner_app/owner_profileview_page.dart';
import 'package:hostel_app/owner_form/hostel_page.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/pages/login_verify.dart';
import 'package:hostel_app/user_app/user_hostel_box.dart';

class UserHomePage extends StatefulWidget {
  @override
  _UserHomePageState createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  bool isFood = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: NestedScrollView(
          headerSliverBuilder: (_, value) {
            return [
              SliverAppBar(
                elevation: 0,
                toolbarHeight: 98,
                actions: [
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (_) => LoactionPopUp(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))));
                    },
                    child: Container(
                      margin: EdgeInsets.all(10),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.green,
                          ),
                          Text(
                            'Bhopal',
                            style: TextStyle(
                                fontSize: 60.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.green),
                          ),
                          Icon(
                            Icons.arrow_drop_down_outlined,
                            color: kLightBlackColor,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
                backgroundColor: kBackgroundColor,
                title: Text(
                  'Hostello',
                  style: TextStyle(
                      color: Colors.blue, fontSize: 100.sp, letterSpacing: 0.8),
                ),
                snap: true,
                floating: true,
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(0),
                  child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(color: Colors.grey.shade300),
                    )),
                    child: ScrollConfiguration(
                      behavior: MyBehavior(),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            FilterRow(
                              ontap: () {},
                              text: 'Locality',
                              margin: 30,
                            ),
                            FilterRow(
                              ontap: () {},
                              text: 'Price',
                            ),
                            FilterRow(
                              text: 'Food',
                              bgColor: isFood ? Colors.blue.shade50 : null,
                              borderColor: isFood ? Colors.blue : null,
                              icon: isFood ? Icons.close : null,
                              ontap: () {
                                setState(() {
                                  isFood = !isFood;
                                });
                              },
                            ),
                            FilterRow(
                              ontap: () {},
                              text: 'Gender',
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ];
          },
          body: TemproryContent()),
    );
  }
}

class TemproryContent extends StatelessWidget {
  const TemproryContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 100.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'At the moment we are only collecting Hostels/PGs Details.',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 55.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400),
              ),
              SizedBox(
                height: 100.h,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: kblueColor),
                onPressed: () async {
                  dynamic isowner = MySharedPref.IsOwner();
                  if (isowner == true) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            OwnerNavigator(),
                        transitionDuration: Duration(seconds: 0),
                      ),
                      (Route<dynamic> route) => false,
                    );
                  } else if (MySharedPref.getMobilenumber() == null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => LoginScreen()));
                  } else {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (_) => HostelPage()));
                  }
                },
                child: Text(
                  (MySharedPref.getMobilenumber() == null)
                      ? 'Sign Up to\nAdd your Hostel/PG'
                      : 'Add your Hostel/PG',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 50.sp,
                    wordSpacing: 1,
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class LoactionPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 0.5.sh,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.close)),
              Text(
                'Select City',
                style: kTitleText.copyWith(fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(
            height: 40.h,
          ),
          Container(
              width: double.infinity,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(vertical: 20.h),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  border: Border(
                      top: BorderSide(color: Colors.grey.shade400),
                      bottom: BorderSide(color: Colors.grey.shade400))),
              child: Text(
                'Currently we are available in ',
                style: TextStyle(fontSize: 48.sp, color: kLightBlackColor),
              )),
          SizedBox(
            height: 50.h,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 50.w),
              padding: EdgeInsets.symmetric(
                vertical: 20.sp,
              ),
              decoration: BoxDecoration(
                  border:
                      Border(bottom: BorderSide(color: Colors.grey.shade400))),
              child: Text(
                'Bhopal, Madhya Pradesh',
                style: TextStyle(
                    fontSize: 48.sp,
                    color: kLightBlackColor,
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class FilterRow extends StatefulWidget {
  FilterRow(
      {Key? key,
      required this.text,
      this.margin = 0,
      this.bgColor,
      this.icon,
      this.borderColor,
      required this.ontap})
      : super(key: key);

  final String text;
  final int margin;
  final Function ontap;
  final Color? borderColor;
  final Color? bgColor;
  final IconData? icon;

  @override
  _FilterRowState createState() => _FilterRowState();
}

class _FilterRowState extends State<FilterRow> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: widget.margin.w, right: 40.w),
      child: Material(
        color: kBackgroundColor,
        child: InkWell(
          onTap: () => widget.ontap(),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: widget.bgColor ?? null,
              border:
                  Border.all(color: widget.borderColor ?? Colors.grey.shade300),
            ),
            child: Row(
              children: [
                Text(
                  widget.text,
                  style: TextStyle(
                      fontSize: 50.sp,
                      fontWeight: FontWeight.w500,
                      color: kLightBlackColor),
                ),
                Icon(
                  widget.icon ?? Icons.arrow_drop_down_outlined,
                  size: 20,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
