import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/main.dart';
import 'package:hostel_app/models/hiveRooms_model.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/hiveoffers_model.dart';
import 'package:hostel_app/owner_app/edithosteldetails_page.dart';
import 'package:hostel_app/owner_app/owner_account_page.dart';
import 'package:hostel_app/owner_app/owner_profileview_page.dart';
import 'package:hostel_app/owner_form/data_provider.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:provider/provider.dart';
import '../toasts.dart';
import 'owner_home_page.dart';
import 'package:hostel_app/models/sharedpref.dart';

class OwnerNavigator extends StatefulWidget {
  static const String id = "owner_homepage";

  @override
  _OwnerNavigatorState createState() => _OwnerNavigatorState();
}

class _OwnerNavigatorState extends State<OwnerNavigator> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    homewidget(),
    OwnerProfilePage(),
    OwnerAccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: kBackgroundColor,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: kBackgroundColor,
          title: (_selectedIndex == 0)
              ? Center(
                  child: Text(
                    '${MySharedPref.getHostelName()}',
                    style: TextStyle(fontSize: 67.sp, color: kLightBlackColor),
                  ),
                )
              : Text(
                  (_selectedIndex == 1) ? 'Profile View' : 'Account',
                  style: TextStyle(fontSize: 67.sp, color: kLightBlackColor),
                ),
          bottom: (_selectedIndex == 0 && MySharedPref.getTimeCreated() <= 24)
              ? PreferredSize(
                  child: Card(
                    margin: EdgeInsets.zero,
                    child: Container(
                      color: Color(0xffFEF6DF),
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      height: 120.h,
                      width: double.infinity,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Color(0xff936D00),
                          ),
                          Flexible(
                            child: Container(
                              margin: EdgeInsets.only(left: 50.w),
                              child: Text(
                                'Your ${(data.hostel) ? 'Hostel' : 'PG'} will be made live after your application review within next 48 hours.',
                                style: TextStyle(
                                    fontSize: 45.sp,
                                    color: Color(0xff866505),
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  preferredSize: Size.fromHeight(50),
                )
              : null,
          actions: (_selectedIndex == 2)
              ? [
                  TextButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text('Logout of app?'),
                            actions: [
                              TextButton(
                                child: Text(
                                  'Logout',
                                  style: TextStyle(
                                      fontSize: 50.sp,
                                      color: kLightBlackColor,
                                      fontWeight: FontWeight.bold),
                                ),
                                onPressed: () async {
                                  await MySharedPref.deleteAll();
                                  await HiveVariablesDB.deleteAll();
                                  await Hive.box<RoomData>(roomsbox).clear();
                                  await Hive.box<OwnerOffers>(offersbox)
                                      .clear();
                                  MySharedPref.setAskToLogin(false);

                                  showToast(
                                    message: "Logged Out Successfully",
                                  );

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              UserNavigator(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                    (Route<dynamic> route) => false,
                                  );
                                },
                              ),
                              SizedBox(
                                width: 50.w,
                              ),
                              TextButton(
                                child: Text(
                                  'Cancel',
                                  style: TextStyle(
                                      fontSize: 50.sp,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                      child: Text(
                        'LogOut',
                        style: kSubTitleText.copyWith(color: Colors.blue),
                      ))
                ]
              : null,
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(
                  top: BorderSide(color: Colors.grey.shade300, width: 1.0))),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: kBackgroundColor,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit),
                label: 'Profile',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Account',
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.blue,
            onTap: _onItemTapped,
          ),
        ),
        floatingActionButton: (_selectedIndex == 1)
            ? FloatingActionButton(
                onPressed: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => OwnerEditHostelDetails()));
                },
                child: Icon(Icons.edit),
              )
            : null,
      ),
    );
  }
}
