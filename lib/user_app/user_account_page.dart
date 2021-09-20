import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/change_avatar.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hostel_app/models/url.dart';
import 'package:hostel_app/models/usermodel.dart';
import 'package:hostel_app/owner_app/owner_navigationbar.dart';
import 'package:hostel_app/owner_form/hostel_page.dart';
import 'package:hostel_app/toasts.dart';
import 'package:http/http.dart' as http;

String imageAvators = 'images_avators/Asset ';

class UserAccountPage extends StatefulWidget {
  @override
  _UserAccountPageState createState() => _UserAccountPageState();
}

class _UserAccountPageState extends State<UserAccountPage> {
  TextEditingController _username = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _mobileOTP = TextEditingController();
  TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _formKey1 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey3 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _username.text = HiveVariablesDB.getUserName() ?? '';
    _mobile.text = HiveVariablesDB.getMobilenumber() ?? '';
    _email.text = HiveVariablesDB.getEmail() ?? '';
  }

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
                  width: 70.w,
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
                          v.get(HiveVariablesDB.keyUserName)
                              //MySharedPref.getUserName()
                              ??
                              "User Name",
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
                )
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
          Button(
              text: 'Edit Name',
              ontap: () {
                _username.text = HiveVariablesDB.getUserName() ?? '';
                bool nameSubmitButton = false;
                bool loadingDialog = false;
                showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) {
                      return StatefulBuilder(builder: (_, setState) {
                        return (loadingDialog == false)
                            ? Form(
                                key: _formKey1,
                                child: AlertDialog(
                                  title: Text(
                                    'Enter Name',
                                    style: kSubTitleText,
                                  ),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextFormField(
                                        controller: _username,
                                        onChanged: (val) {
                                          if (val ==
                                              HiveVariablesDB.getUserName()) {
                                            setState(() {
                                              nameSubmitButton = false;
                                            });
                                          } else {
                                            setState(() {
                                              nameSubmitButton = true;
                                            });
                                          }
                                        },
                                        validator: (val) {
                                          if (val == null || val.isEmpty)
                                            return 'Name cannot be empty';

                                          RegExp v = RegExp(r'^[a-zA-Z ]+$');
                                          if (v.hasMatch(val) == false)
                                            return 'Name cannot contain numbers and special characters';

                                          if (val.length < 3)
                                            return 'Name should contain atleast 3 letters';

                                          return null;
                                        },
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        decoration: InputDecoration(
                                            errorMaxLines: 2,
                                            isDense: true,
                                            hintText: 'Name'),
                                        style: TextStyle(
                                          fontSize: 45.h,
                                          letterSpacing: 0.5,
                                          height: 1.2,
                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    Row(
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: Text(
                                              'Cancel',
                                              style: kSubTitleText.copyWith(
                                                  color: Colors.redAccent),
                                            )),
                                        TextButton(
                                            onPressed: (nameSubmitButton)
                                                ? () async {
                                                    if (_formKey1.currentState!
                                                        .validate()) {
                                                      setState(() {
                                                        loadingDialog = true;
                                                      });

                                                      int code = await UserModel()
                                                          .updateUserDetails(
                                                              id: MySharedPref
                                                                      .getUserID() ??
                                                                  '',
                                                              name: _username
                                                                  .text);

                                                      if (code != 200) {
                                                        showToast(
                                                            message:
                                                                "Couldn't Save Changes");
                                                        Navigator.pop(context);
                                                        return;
                                                      }
                                                      await HiveVariablesDB
                                                          .setUserName(
                                                              _username.text);
                                                      Navigator.pop(context);
                                                    }
                                                  }
                                                : null,
                                            child: Text(
                                              'Submit',
                                              style: kSubTitleText.copyWith(
                                                  color: (!nameSubmitButton)
                                                      ? Colors.grey
                                                      : Colors.blue),
                                            )),
                                      ],
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                    )
                                  ],
                                ),
                              )
                            : AlertDialog(
                                content: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(
                                      width: 100.w,
                                    ),
                                    Text(
                                      'Saving Name..',
                                      style: kSubTitleText,
                                    ),
                                  ],
                                ),
                              );
                      });
                    });
              }),
          (MySharedPref.IsOwner() == false || MySharedPref.IsOwner() == null)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Button(
                        text: 'Edit Phone Number',
                        ontap: () {
                          _mobile.text =
                              HiveVariablesDB.getMobilenumber() ?? '';
                          _mobileOTP.text = '';
                          bool verifyButton = false;
                          bool updatingDialog = false;
                          bool enterOTP = false;
                          bool showDuplicateDialog = false;
                          bool showDuplicateNumberCheckLoading = false;
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) => StatefulBuilder(
                                    builder: (_, setState) {
                                      return (updatingDialog == false)
                                          ? ((!showDuplicateDialog)
                                              ? Form(
                                                  key: _formKey2,
                                                  child: AlertDialog(
                                                    title: Text(
                                                      (enterOTP)
                                                          ? 'Enter 6-digit OTP Sent to\nnew mobile number.'
                                                          : 'Enter Mobile Number',
                                                      style: kSubTitleText,
                                                    ),
                                                    content: (enterOTP == false)
                                                        ? TextFormField(
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                            controller: _mobile,
                                                            onChanged: (val) {
                                                              if (val ==
                                                                  HiveVariablesDB
                                                                      .getMobilenumber()) {
                                                                setState(() {
                                                                  verifyButton =
                                                                      false;
                                                                });
                                                              } else {
                                                                setState(() {
                                                                  verifyButton =
                                                                      true;
                                                                });
                                                              }
                                                            },
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter phone number';
                                                              }
                                                              if (value
                                                                      .length !=
                                                                  10) {
                                                                return 'Invalid phone number';
                                                              }

                                                              final number =
                                                                  int.tryParse(
                                                                      value);
                                                              if (number ==
                                                                  null) {
                                                                return 'Invalid phone number';
                                                              }

                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                                    isDense:
                                                                        true,
                                                                    hintText:
                                                                        'Mobile number'),
                                                            style: TextStyle(
                                                              fontSize: 45.h,
                                                              letterSpacing:
                                                                  0.5,
                                                              height: 1.2,
                                                            ),
                                                          )
                                                        : TextFormField(
                                                            validator: (value) {
                                                              if (value ==
                                                                      null ||
                                                                  value
                                                                      .isEmpty) {
                                                                return 'Please enter OTP';
                                                              }
                                                              final number =
                                                                  int.tryParse(
                                                                      value);
                                                              if (number ==
                                                                  null) {
                                                                return 'Only Numbers';
                                                              }

                                                              if (value
                                                                      .length !=
                                                                  6) {
                                                                return 'Enter 6-digit OTP';
                                                              }
                                                              return null;
                                                            },
                                                            decoration:
                                                                InputDecoration(
                                                              isDense: true,
                                                              hintText:
                                                                  'Enter OTP',
                                                            ),
                                                            style: TextStyle(
                                                              fontSize: 45.h,
                                                              letterSpacing:
                                                                  0.5,
                                                              height: 1.2,
                                                            ),
                                                            controller:
                                                                _mobileOTP,
                                                            autovalidateMode:
                                                                AutovalidateMode
                                                                    .onUserInteraction,
                                                            keyboardType:
                                                                TextInputType
                                                                    .number,
                                                          ),
                                                    actions: [
                                                      if (enterOTP == false)
                                                        Row(
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: kSubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.redAccent),
                                                                )),
                                                            (showDuplicateNumberCheckLoading ==
                                                                    false)
                                                                ? TextButton(
                                                                    onPressed: (verifyButton ==
                                                                            true)
                                                                        ? () async {
                                                                            if (_formKey2.currentState!.validate()) {
                                                                              FocusScope.of(context).requestFocus(new FocusNode());
                                                                              setState(() {
                                                                                showDuplicateNumberCheckLoading = true;
                                                                              });
                                                                              int code = await UserModel().isMobileRegistered(mobilenumber: _mobile.text, checkDuplicate: true);

                                                                              if (code == 1) {
                                                                                setState(() {
                                                                                  showDuplicateDialog = true;
                                                                                });
                                                                              } else if (code == -1) {
                                                                                showToast(message: 'Error.Please Try again later!');
                                                                                Navigator.pop(context);
                                                                                return;
                                                                              }

                                                                              setState(() {
                                                                                showDuplicateNumberCheckLoading = false;
                                                                                enterOTP = true;
                                                                              });
                                                                            }
                                                                          }
                                                                        : null,
                                                                    child: Text(
                                                                      'Verify',
                                                                      style: kSubTitleText.copyWith(
                                                                          color: (verifyButton == true)
                                                                              ? Colors.green
                                                                              : Colors.grey),
                                                                    ))
                                                                : Container(
                                                                    height: 25,
                                                                    width: 25,
                                                                    child:
                                                                        CircularProgressIndicator(),
                                                                  ),
                                                          ],
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                        ),
                                                      if (enterOTP == true)
                                                        Row(
                                                          children: [
                                                            TextButton(
                                                                onPressed: () {
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                child: Text(
                                                                  'Cancel',
                                                                  style: kSubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.redAccent),
                                                                )),
                                                            TextButton(
                                                                onPressed:
                                                                    () async {
                                                                  if (_formKey2
                                                                      .currentState!
                                                                      .validate()) {
                                                                    setState(
                                                                        () {
                                                                      updatingDialog =
                                                                          true;
                                                                    });
                                                                    int code = await UserModel().updateUserDetails(
                                                                        id: MySharedPref.getUserID() ??
                                                                            '',
                                                                        mobile:
                                                                            _mobile.text);

                                                                    if (code !=
                                                                        200) {
                                                                      showToast(
                                                                          message:
                                                                              "Couldn't update Mobile Number");
                                                                    } else {
                                                                      MySharedPref.setMobilenumber(
                                                                          _mobile
                                                                              .text);
                                                                      HiveVariablesDB.setMobilenumber(
                                                                          _mobile
                                                                              .text);
                                                                    }

                                                                    Navigator.pop(
                                                                        context);
                                                                  }
                                                                },
                                                                child: Text(
                                                                  'Verify OTP',
                                                                  style: kSubTitleText
                                                                      .copyWith(
                                                                          color:
                                                                              Colors.blue),
                                                                )),
                                                          ],
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceEvenly,
                                                        )
                                                    ],
                                                  ),
                                                )
                                              : AlertDialog(
                                                  title: Text(
                                                      'Mobile Verification'),
                                                  content: Text(
                                                      'Error. This Mobile Number is already in use.'),
                                                  actions: [
                                                    TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text('OK',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .blue))),
                                                  ],
                                                ))
                                          : AlertDialog(
                                              content: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  CircularProgressIndicator(),
                                                  SizedBox(
                                                    width: 100.w,
                                                  ),
                                                  Expanded(
                                                    child: Text(
                                                      'Updating Mobile Number..',
                                                      style: kSubTitleText,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            );
                                    },
                                  ));
                        }),
                    Button(
                        text: 'Edit Email Address',
                        ontap: () {
                          _email.text = HiveVariablesDB.getEmail() ?? '';
                          bool verifyButton = false;
                          bool updatingDialog = false;
                          bool enterOTP = false;
                          bool showDuplicateDialog = false;
                          bool showDuplicateEmailCheckLoading = false;
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (_) =>
                                  StatefulBuilder(builder: (_, setState) {
                                    return (updatingDialog == false)
                                        ? ((!showDuplicateDialog)
                                            ? Form(
                                                key: _formKey3,
                                                child: AlertDialog(
                                                  title: Text(
                                                    'Enter Email Address',
                                                    style: kSubTitleText,
                                                  ),
                                                  content: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      TextFormField(
                                                        autovalidateMode:
                                                            AutovalidateMode
                                                                .onUserInteraction,
                                                        controller: _email,
                                                        validator: (val) {
                                                          if (val == null ||
                                                              val.isEmpty) {
                                                            return 'Enter new email';
                                                          }
                                                          final validCharacters =
                                                              RegExp(
                                                                  r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                                                          if (validCharacters
                                                                  .hasMatch(
                                                                      val) ==
                                                              false) {
                                                            return 'Invalid Email Address';
                                                          }
                                                          return null;
                                                        },
                                                        decoration:
                                                            InputDecoration(
                                                                isDense: true,
                                                                hintText:
                                                                    'Email'),
                                                        style: TextStyle(
                                                          fontSize: 45.h,
                                                          height: 1.2,
                                                        ),
                                                        onChanged: (val) {
                                                          if (val ==
                                                              HiveVariablesDB
                                                                  .getEmail()) {
                                                            setState(() {
                                                              verifyButton =
                                                                  false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              verifyButton =
                                                                  true;
                                                            });
                                                          }
                                                        },
                                                      ),
                                                      if (enterOTP == true)
                                                        Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            SizedBox(
                                                              height: 50.h,
                                                            ),
                                                            Text(
                                                              'Enter 6-digit OTP Sent to\nnew Email.',
                                                              style: kSubTitleText
                                                                  .copyWith(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500),
                                                            ),
                                                            SizedBox(
                                                              height: 40.h,
                                                            ),
                                                            TextFormField(
                                                              validator:
                                                                  (value) {
                                                                if (value ==
                                                                        null ||
                                                                    value
                                                                        .isEmpty) {
                                                                  return 'Please enter OTP';
                                                                }
                                                                final number =
                                                                    int.tryParse(
                                                                        value);
                                                                if (number ==
                                                                    null) {
                                                                  return 'Only Numbers';
                                                                }

                                                                if (value
                                                                        .length !=
                                                                    6) {
                                                                  return 'Enter 6-digit OTP';
                                                                }
                                                                return null;
                                                              },
                                                              decoration:
                                                                  InputDecoration(
                                                                isDense: true,
                                                                hintText:
                                                                    'Enter OTP',
                                                              ),
                                                              style: TextStyle(
                                                                fontSize: 45.h,
                                                                letterSpacing:
                                                                    0.5,
                                                                height: 1.2,
                                                              ),
                                                              autovalidateMode:
                                                                  AutovalidateMode
                                                                      .onUserInteraction,
                                                              keyboardType:
                                                                  TextInputType
                                                                      .number,
                                                            ),
                                                          ],
                                                        ),
                                                    ],
                                                  ),
                                                  actions: [
                                                    if (enterOTP == false)
                                                      Row(
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                style: kSubTitleText
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .redAccent),
                                                              )),
                                                          (showDuplicateEmailCheckLoading ==
                                                                  false)
                                                              ? TextButton(
                                                                  onPressed: (verifyButton ==
                                                                          true)
                                                                      ? () async {
                                                                          if (_formKey3
                                                                              .currentState!
                                                                              .validate()) {
                                                                            setState(() {
                                                                              showDuplicateEmailCheckLoading = true;
                                                                            });

                                                                            // if (code == 1) {
                                                                            //   setState(() {
                                                                            //     showDuplicateDialog = true;
                                                                            //   });
                                                                            // } else if (code == -1) {
                                                                            //   showToast(message: 'Error.Please Try again later!');
                                                                            //   Navigator.pop(context);
                                                                            //   return;
                                                                            // }
                                                                            await Future.delayed(Duration(seconds: 3));
                                                                            setState(() {
                                                                              // showDuplicateNumberCheckLoading = false;
                                                                              enterOTP = true;
                                                                            });
                                                                          }
                                                                        }
                                                                      : null,
                                                                  child: Text(
                                                                    'Verify',
                                                                    style: kSubTitleText.copyWith(
                                                                        color: (verifyButton ==
                                                                                true)
                                                                            ? Colors.green
                                                                            : Colors.grey),
                                                                  ))
                                                              : Container(
                                                                  height: 25,
                                                                  width: 25,
                                                                  child:
                                                                      CircularProgressIndicator(),
                                                                ),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                      ),
                                                    if (enterOTP == true)
                                                      Row(
                                                        children: [
                                                          TextButton(
                                                              onPressed: () {
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child: Text(
                                                                'Cancel',
                                                                style: kSubTitleText
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .redAccent),
                                                              )),
                                                          TextButton(
                                                              onPressed:
                                                                  () async {
                                                                if (_formKey3
                                                                    .currentState!
                                                                    .validate()) {
                                                                  setState(() {
                                                                    updatingDialog =
                                                                        true;
                                                                  });
                                                                  int code = await UserModel().updateUserDetails(
                                                                      id: MySharedPref
                                                                              .getUserID() ??
                                                                          '',
                                                                      email: _email
                                                                          .text);

                                                                  if (code !=
                                                                      200) {
                                                                    showToast(
                                                                        message:
                                                                            "Couldn't update Email");
                                                                  } else {
                                                                    HiveVariablesDB
                                                                        .setEmail(
                                                                            _email.text);
                                                                  }

                                                                  Navigator.pop(
                                                                      context);
                                                                }
                                                              },
                                                              child: Text(
                                                                'Verify OTP',
                                                                style: kSubTitleText
                                                                    .copyWith(
                                                                        color: Colors
                                                                            .blue),
                                                              )),
                                                        ],
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceEvenly,
                                                      )
                                                  ],
                                                ),
                                              )
                                            : AlertDialog(
                                                title:
                                                    Text('Email Verification'),
                                                content: Text(
                                                    'Error. This Email is already in use.'),
                                                actions: [
                                                  TextButton(
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: Text('OK',
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .blue))),
                                                ],
                                              ))
                                        : AlertDialog(
                                            content: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                CircularProgressIndicator(),
                                                SizedBox(
                                                  width: 100.w,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Updating Email..',
                                                    style: kSubTitleText,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                  }));
                        }),
                  ],
                )
              : Container(
                  margin:
                      EdgeInsets.symmetric(horizontal: 100.w, vertical: 30.h),
                  child: Text(
                    'Since you have a registered Hostel/PG,\nSo your Mobile number and Email can be changed from your Hostel/PG Dashboard.',
                    style: TextStyle(
                      fontSize: 45.sp,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ),
          Divider(
            thickness: 1,
          ),
          GestureDetector(
            onTap: () async {
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
              } else {
                Navigator.push(
                    context, MaterialPageRoute(builder: (_) => HostelPage()));
              }
            },
            child: Container(
              margin: EdgeInsets.only(left: 100.w, top: 50.h),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.blue, width: 1.5),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Text(
                (MySharedPref.IsOwner() == false ||
                        MySharedPref.IsOwner() == null)
                    ? 'Register Hostel/PG'
                    : 'Your Hostel/PG Dashboard',
                style: TextStyle(
                    fontSize: 50.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue),
              ),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 100.w),
            child: RaisedButton(
              onPressed: () async {
                print('send');
                try {
                  var response = await http.post(
                    Uri.parse(Url().saveHostel),
                    headers: <String, String>{
                      'Content-Type': 'application/json; charset=UTF-8',
                    },
                    body: jsonEncode({
                      'prices': ["200", "300"],
                      'ownerName': "Any Name",
                      'rooms': {
                        'roomType': "Name",
                        'rent': 3000,
                        'securityMoney': 4000,
                        'facilities': ["hello", "ifjk"],
                      },
                      'location': {
                        'latitude': 8575,
                        'longitude': 5766,
                        'accuracy': 8768,
                      },
                      'contact': {
                        'phoneNo': ["85947t09", "797985943"],
                        'email': ["gdxikchx", "hoixlxjvjx"],
                        'whatsapp': "598347497",
                      },
                      'images': ["image1", "image2"],
                      'rules': {},
                      'facilities': ["cctv", "water"],
                      'gender': "male",
                      'address': "any",
                      'city': "any",
                      'locality': "any",
                      'landmark': "any",
                      'pincode': 875859,
                      'offers': {
                        'offerName': "any",
                        'offerDiscription': "jdk",
                        'eligibility': "kop",
                        'offerTimePeriod': "jisd"
                      }
                    }),
                  );

                  print(response.statusCode);
                  print(response.body);
                } catch (e) {
                  print(e);
                }
              },
              child: Text('${MySharedPref.getUserID()}'),
            ),
          )
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
