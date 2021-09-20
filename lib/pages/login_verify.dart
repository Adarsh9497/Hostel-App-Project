import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/models/usermodel.dart';
import 'package:hostel_app/pages/username.dart';
import 'package:hostel_app/toasts.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

enum MobileVerificationState {
  SHOW_MOBILE_FORM_STATE,
  SHOW_OTP_FORM_STATE,
}

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  MobileVerificationState currentState =
      MobileVerificationState.SHOW_MOBILE_FORM_STATE;

  late Timer _timer;
  int _start = 60;
  bool isTimerActive = false;
  bool resendOTP = false;

  final _number = TextEditingController();
  String? otp;

  FirebaseAuth _auth = FirebaseAuth.instance;

  final _formKey1 = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  late String verificationId;

  bool showLoading = false;

  void signInWithPhoneAuthCredential(
      PhoneAuthCredential phoneAuthCredential) async {
    setState(() {
      showLoading = true;
    });

    try {
      final authCredential =
          await _auth.signInWithCredential(phoneAuthCredential);

      setState(() {
        showLoading = false;
      });

      if (authCredential.user != null) {
        AgentOtp();
      }
    } on FirebaseAuthException catch (e) {
      print(e);
      setState(() {
        showLoading = false;
      });
      showToast(message: 'Invalid OTP', gravity: 'center');
    }
  }

  Future<void> startTimer() async {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (!mounted) return;
          setState(() {
            timer.cancel();
          });
        } else {
          if (!mounted) return;
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  loginWidget(context) {
    return Form(
      key: _formKey1,
      child: SingleChildScrollView(
          child: Container(
        margin: EdgeInsets.symmetric(horizontal: 50.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 150.h),
              child: Text(
                'Welcome to Hostello',
                style: TextStyle(
                    fontSize: 100.sp,
                    color: kLightBlackColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Text(
                'Enter your phone number',
                style: TextStyle(
                    fontSize: 70.sp,
                    color: kLightBlackColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 100.h,
            ),
            TextFormField(
              autofocus: true,
              controller: _number,
              keyboardType: TextInputType.number,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              style: TextStyle(
                  fontSize: 70.sp, color: kLightBlackColor, letterSpacing: 0.5),
              decoration: InputDecoration(
                prefixText: '+91  ',
                border: new OutlineInputBorder(
                  borderRadius: new BorderRadius.circular(10.0),
                  borderSide: new BorderSide(),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter phone number';
                }
                if (value.length != 10) {
                  return 'Invalid phone number';
                }

                final number = int.tryParse(value);
                if (number == null) {
                  return 'Invalid phone number';
                }

                return null;
              },
              onChanged: (val) {
                if (val.length == 10) {
                  FocusScope.of(context).unfocus();
                }
              },
            ),
          ],
        ),
      )),
    );
  }

  otpWidget(context) {
    return Form(
      key: _formKey2,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 50.w),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(top: 50.h),
              child: Text(
                'Verify your number',
                style: TextStyle(
                    fontSize: 100.sp,
                    color: kLightBlackColor,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 30.h),
              child: Text(
                'Enter the OTP sent to',
                style: TextStyle(
                    fontSize: 70.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10.h, bottom: 100.h),
              child: Text(
                '+91 ${_number.text}',
                style: TextStyle(
                    fontSize: 70.sp,
                    color: Colors.grey.shade700,
                    fontWeight: FontWeight.w400),
              ),
            ),
            Container(
              padding: EdgeInsets.only(right: 200.w),
              child: PinCodeTextField(
                autoFocus: true,
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                autovalidateMode: AutovalidateMode.disabled,
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) return 'Please enter OTP';

                  RegExp r = RegExp(r'^[0-9]+$');
                  if (!r.hasMatch(val)) return 'OTP Should be a number';

                  if (val.length != 6) return 'Please enter 6-digit OTP';

                  return null;
                },
                pinTheme: PinTheme(
                    //fieldOuterPadding: EdgeInsets.symmetric(horizontal: 10.w),
                    fieldWidth: 35,
                    inactiveColor: Colors.grey,
                    shape: PinCodeFieldShape.underline,
                    activeFillColor: Colors.white,
                    disabledColor: kBackgroundColor),
                animationDuration: Duration(milliseconds: 100),
                onCompleted: (v) {},
                onChanged: (value) {
                  otp = value;
                },
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: (context),
              ),
            ),
            (_start != 0)
                ? Container(
                    margin: EdgeInsets.only(top: 70.h),
                    child: Text(
                      'Having trouble? Request a new OTP in\n00:$_start',
                      style: TextStyle(
                          fontSize: 55.sp,
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w400),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(top: 70.h),
                    child: Row(
                      children: [
                        Text(
                          'Having trouble?',
                          style: TextStyle(
                              fontSize: 55.sp,
                              color: Colors.grey.shade700,
                              fontWeight: FontWeight.w400),
                        ),
                        (resendOTP && _start == 0)
                            ? Text(
                                '  Try Again Later!',
                                style: TextStyle(
                                    fontSize: 55.sp,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.w400),
                              )
                            : GestureDetector(
                                onTap: () {
                                  if (isTimerActive) _timer.cancel();
                                  _start = 120;
                                  resendOTP = true;
                                  setState(() {
                                    showLoading = true;
                                  });

                                  startTimer();
                                  isTimerActive = true;
                                  verifyPhoneNumber();
                                },
                                child: Text(
                                  '  Request a new OTP',
                                  style: TextStyle(
                                      fontSize: 55.sp,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                      ],
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    if (isTimerActive) _timer.cancel();
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  buildShowDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  Future<void> AgentOtp() async {
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
                  'Please wait..',
                  style: kSubTitleText,
                ),
              ],
            ),
          );
        });
    int code = await UserModel().isMobileRegistered(mobilenumber: _number.text);

    if (code == -1)
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Error..'),
              content: Text(
                  'Servers are busy at the moment,\nplease try again later!'),
              actions: [
                TextButton(
                    onPressed: () {
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
                    child: Text('OK'))
              ],
            );
          });
    else if (code == 1) {
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => UserNavigator(),
          transitionDuration: Duration(seconds: 0),
        ),
        (Route<dynamic> route) => false,
      );
    } else if (code == 0) {
      await MySharedPref.setMobilenumber(_number.text);
      await HiveVariablesDB.setMobilenumber(_number.text);
      await MySharedPref.setOwner(false);
      Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => UserName(),
          transitionDuration: Duration(seconds: 0),
        ),
        (Route<dynamic> route) => false,
      );
    }
  }

  void verifyPhoneNumber() async {
    await _auth.verifyPhoneNumber(
      phoneNumber: '+91${_number.text}',
      verificationCompleted: (phoneAuthCredential) async {
        setState(() {
          showLoading = false;
        });
        signInWithPhoneAuthCredential(phoneAuthCredential);
        showToast(message: 'Logged In.Verified Automatically');
      },
      verificationFailed: (verificationFailed) async {
        setState(() {
          showLoading = false;
        });
        print(verificationFailed.message);
        showToast(message: 'Error. Verification Failed,try again later');
      },
      codeSent: (verificationId, resendingToken) async {
        setState(() {
          showLoading = false;
          currentState = MobileVerificationState.SHOW_OTP_FORM_STATE;
          this.verificationId = verificationId;
        });
      },
      codeAutoRetrievalTimeout: (verificationId) async {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
        key: _scaffoldKey,
        appBar: (currentState != MobileVerificationState.SHOW_MOBILE_FORM_STATE)
            ? AppBar(
                backgroundColor: kBackgroundColor,
                elevation: 0,
                leading: BackButton(
                  color: kLightBlackColor,
                ),
              )
            : null,
        bottomNavigationBar: (!showLoading)
            ? Container(
                margin: EdgeInsets.all(20),
                child: FlatButton(
                  padding: EdgeInsets.all(10),
                  minWidth: double.infinity,
                  onPressed: (currentState ==
                          MobileVerificationState.SHOW_MOBILE_FORM_STATE)
                      ? () async {
                          if (_formKey1.currentState!.validate()) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            setState(() {
                              showLoading = true;
                            });
                            startTimer();
                            isTimerActive = true;
                            verifyPhoneNumber();
                          }
                        }
                      : () {
                          if (_formKey2.currentState!.validate()) {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());
                            PhoneAuthCredential phoneAuthCredential =
                                PhoneAuthProvider.credential(
                                    verificationId: verificationId,
                                    smsCode: otp ?? '');

                            signInWithPhoneAuthCredential(phoneAuthCredential);
                          }
                        },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  color: kblueColor,
                  child: Text(
                    'Next',
                    style: TextStyle(fontSize: 70.sp, color: Colors.white),
                  ),
                ),
              )
            : null,
        body: Container(
          child: showLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : currentState == MobileVerificationState.SHOW_MOBILE_FORM_STATE
                  ? loginWidget(context)
                  : otpWidget(context),
        ));
  }
}
