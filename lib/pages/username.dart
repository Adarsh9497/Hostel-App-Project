import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/models/usermodel.dart';
import 'package:hostel_app/user_app/user_navigator.dart';

import '../toasts.dart';

class UserName extends StatefulWidget {
  UserName({Key? key}) : super(key: key);

  @override
  _UserNameState createState() => _UserNameState();
}

class _UserNameState extends State<UserName> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  final TextEditingController _username = TextEditingController();

  void createUser(BuildContext context) async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(
                  width: 100.w,
                ),
                Text(
                  'Loading..',
                  style: kSubTitleText,
                ),
              ],
            ),
          );
        });
    String mobile = MySharedPref.getMobilenumber() ?? 'error';
    int code = await UserModel()
        .createUser(name: _username.text, mobilenumber: mobile);

    if (code != 200) {
      showToast(
        message: "Couldn't login, Try again later!",
      );
    }
    Navigator.pushAndRemoveUntil(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => UserNavigator(),
        transitionDuration: Duration(seconds: 0),
      ),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: kBackgroundColor,
        title: Text(
          'Hostello',
          style: TextStyle(
            fontSize: 90.sp,
            // fontWeight: FontWeight.bold,
            color: Colors.blue,
            letterSpacing: 1,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(left: 20, right: 30, top: 50),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Text(
                      'Hii,\nPlease enter your name',
                      style: TextStyle(
                        fontSize: 100.sp,
                        fontWeight: FontWeight.w500,
                        color: kLightBlackColor,
                        letterSpacing: 0.5,
                        wordSpacing: 1,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  TextFormField(
                    controller: _username,
                    decoration: InputDecoration(
                      hintText: 'Your name here',
                      disabledBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                    ),
                    validator: (val) {
                      if (val == null || val.isEmpty)
                        return 'Name cannot be empty';

                      RegExp v = RegExp(r'^[a-zA-Z ]+$');
                      if (v.hasMatch(val) == false)
                        return 'Name cannot contain numbers and special characters';

                      return null;
                    },
                    style: TextStyle(
                        fontSize: 80.sp,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.5,
                        color: kLightBlackColor,
                        height: 1.5),
                  ),
                  SizedBox(
                    height: 200.h,
                  ),
                  RawMaterialButton(
                    constraints: BoxConstraints(minHeight: 50, minWidth: 50),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        createUser(context);
                        //await HiveVariablesDB.setUserName(_username.text);
                        // Navigator.pushAndRemoveUntil(
                        //   context,
                        //   PageRouteBuilder(
                        //     pageBuilder: (context, animation1, animation2) =>
                        //         UserNavigator(),
                        //     transitionDuration: Duration(seconds: 0),
                        //   ),
                        //   (Route<dynamic> route) => false,
                        // );
                      }
                    },
                    fillColor: Colors.blue,
                    shape: CircleBorder(),
                    child: Icon(
                      Icons.navigate_next,
                      color: kBackgroundColor,
                      size: 100.sp,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
