import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/main.dart';
import 'package:hostel_app/models/hiveRooms_model.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/hiveoffers_model.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hostel_app/user_app/user_account_page.dart';
import 'package:hostel_app/user_app/user_homepage.dart';
import 'package:hostel_app/user_app/userloginpage.dart';

import '../toasts.dart';

class UserNavigator extends StatefulWidget {
  UserNavigator({this.index});
  final int? index;

  @override
  _UserNavigatorState createState() => _UserNavigatorState();
}

class _UserNavigatorState extends State<UserNavigator> {
  int _selectedIndex = 0;
  List<Widget> _widgetOptions = <Widget>[
    UserHomePage(),
    TemproryContent(),
    Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 0.27.sw,
            backgroundColor: Colors.transparent,
            child: Image.asset('images/whishlist.png'),
          ),
          SizedBox(
            height: 50.h,
          ),
          Text(
            'Wish List is Empty!',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 55.sp,
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    ),
    (MySharedPref.getMobilenumber() == null) ? UserLogin() : UserAccountPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.index != null) _selectedIndex = widget.index!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kBackgroundColor,
      appBar: (_selectedIndex > 0)
          ? AppBar(
              elevation: 0,
              toolbarHeight: (_selectedIndex == 1) ? 70 : null,
              backgroundColor: kBackgroundColor,
              title: (_selectedIndex != 1)
                  ? Text(
                      getAppBarTitle(_selectedIndex),
                      style: kTitleText,
                    )
                  : Container(
                      margin: EdgeInsets.only(top: 20),
                      child: TextFormField(
                        style: TextStyle(fontSize: 50.sp, height: 1.5),
                        decoration: InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            isDense: true,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 70.sp,
                            )),
                      ),
                    ),
              actions: (_selectedIndex == 3 &&
                      MySharedPref.getMobilenumber() != null)
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
                                      await Hive.box<RoomData>(roomsbox)
                                          .clear();
                                      await Hive.box<OwnerOffers>(offersbox)
                                          .clear();
                                      MySharedPref.setAskToLogin(false);

                                      showToast(
                                        message: "Logged Out Successfully",
                                      );

                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        PageRouteBuilder(
                                          pageBuilder: (context, animation1,
                                                  animation2) =>
                                              UserNavigator(),
                                          transitionDuration:
                                              Duration(seconds: 0),
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
                          )),
                    ]
                  : null,
            )
          : null,
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(
                top: BorderSide(color: Colors.grey.shade300, width: 1.0))),
        child: BottomNavigationBar(
          elevation: 0,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              backgroundColor: kBackgroundColor,
              icon: Icon(
                Icons.home,
                size: 25,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: kBackgroundColor,
              icon: Icon(
                Icons.search,
                size: 25,
              ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              backgroundColor: kBackgroundColor,
              activeIcon: Icon(
                FontAwesomeIcons.solidHeart,
                size: 22,
              ),
              icon: Icon(
                FontAwesomeIcons.heart,
                size: 22,
              ),
              label: 'Wishlist',
            ),
            BottomNavigationBarItem(
              backgroundColor: kBackgroundColor,
              icon: Icon(
                Icons.person,
                size: 25,
              ),
              label: 'Account',
            ),
          ],
          currentIndex: _selectedIndex,
          unselectedItemColor: kLightBlackColor,
          selectedItemColor: Colors.blue,
          onTap: _onItemTapped,
        ),
      ),
    );
  }
}

String getAppBarTitle(int index) {
  if (index == 2)
    return 'Wishlist';
  else if (index == 3)
    return 'Account';
  else
    return '';
}
