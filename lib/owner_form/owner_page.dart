import 'package:flutter/material.dart';
import 'package:hostel_app/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/owner_form/address_page.dart';
import 'package:hostel_app/owner_form/data_provider.dart';
import 'package:hostel_app/owner_form/hostel_page.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:provider/provider.dart';
import 'widgets/custom_widgets.dart';

class OwnerPage extends StatefulWidget {
  static const String id = "owner_basic2_page";

  @override
  _OwnerPageState createState() => _OwnerPageState();
}

class _OwnerPageState extends State<OwnerPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ScrollController _scrollController = ScrollController();

  String ownerName = "";
  String mobileNumber = "";
  String whatsappNumber = "";
  String emailAddress = "";

  TextEditingController _ownername = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _whatsapp = TextEditingController();

  @override
  void initState() {
    super.initState();
    initializeData();
  }

  void initializeData() async {
    var data = Provider.of<DataProvider>(context, listen: false);
    if (data.ownerDataUpdated) {
      _ownername.text = data.ownerName;
      _mobile.text = data.updatedMobileNumber;
      _email.text = data.email;
      if (data.whatsappNumber != data.mobileNumber)
        _whatsapp.text = data.whatsappNumber;
    } else {
      _ownername.text = "";
      _mobile.text = HiveVariablesDB.getMobilenumber() ?? '';
      _whatsapp.text = "";
      _email.text = "";
    }
  }

  void updataOwnerData() {
    var data = Provider.of<DataProvider>(context, listen: false);
    data.updataOwnerData(
        ownerName: _ownername.text,
        updatedMobileNumber: _mobile.text,
        whatsappNumber: _whatsapp.text,
        email: _email.text);
  }

  @override
  Widget build(BuildContext context) {
    var dataProvider = Provider.of<DataProvider>(context);
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            if (_formKey.currentState!.validate()) {}
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
            backgroundColor: kBackgroundColor,
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: Row(
                children: [
                  Container(
                    width: 0.5.sw,
                    height: 150.h,
                    child: Material(
                      color: Color(0xff3A3B3C),
                      child: InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  HostelPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                            //(Route<dynamic> route) => false,
                          );
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.arrow_back_outlined,
                                color: kBackgroundColor,
                              ),
                              Text(
                                'Back',
                                style: kTitleText.copyWith(
                                    color: kBackgroundColor),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 0.5.sw,
                    height: 150.h,
                    child: Material(
                      color: Colors.blue,
                      child: InkWell(
                        onTap: () {
                          if (_formKey.currentState!.validate()) {
                            updataOwnerData();

                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        AddressPage(),
                                transitionDuration: Duration(seconds: 0),
                              ),
                              //(Route<dynamic> route) => false,
                            );
                          } else {
                            _scrollController.animateTo(
                                _scrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Next',
                                style: kTitleText.copyWith(
                                    color: kBackgroundColor),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: kBackgroundColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              elevation: 6,
            ),
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 4,
              title: Text(
                "Add your Hostel/PG",
                style: TextStyle(color: Colors.white),
              ),
              bottom: PreferredSize(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppbarBottom(text: 'Hostel'),
                      AppbarBottom(text: 'Owner', isUnderlined: true),
                      AppbarBottom(text: 'Address'),
                      AppbarBottom(text: 'Rent'),
                      AppbarBottom(text: 'Photos'),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(40),
              ),
            ),
            body: Column(
              children: [
                Form(
                  key: _formKey,
                  child: Expanded(
                      child: Container(
                    child: SingleChildScrollView(
                      controller: _scrollController,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(50.w, 60.h, 70.w, 50.h),
                        child: Column(
                          children: [
                            Text(
                              'Owner Details',
                              style: kTitleText,
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 50.h),
                              child: TextFormField(
                                controller: _ownername,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return 'Name cannot be blank';
                                  }

                                  final validCharacters =
                                      RegExp(r'^[a-zA-Z ]+$');
                                  if (validCharacters.hasMatch(val) == false) {
                                    return 'Name cannot contain numbers and special characters';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red[900]),
                                  labelText: 'Owner name',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: 'Hostel/PG Owner Name',
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {
                                  ownerName = val;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 40.h),
                              child: TextFormField(
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
                                controller: _mobile,
                                decoration: InputDecoration(
                                  errorStyle: TextStyle(color: Colors.red[900]),
                                  labelText: 'Mobile Number',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {
                                  mobileNumber = val;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 40.h),
                              child: TextFormField(
                                controller: _whatsapp,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return null;
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
                                decoration: InputDecoration(
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
                                  errorStyle: TextStyle(color: Colors.red[900]),
                                  labelText: 'Whatsapp Number',
                                  hintText: _mobile.text,
                                  helperText: 'If same number then leave blank',
                                  helperStyle:
                                      TextStyle(color: Colors.blueAccent),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {
                                  whatsappNumber = val;
                                },
                                onSaved: (val) {
                                  if (val != null)
                                    dataProvider.whatsappNumber = val;
                                },
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 40.h),
                              child: TextFormField(
                                controller: _email,
                                validator: (val) {
                                  if (val == null || val.isEmpty) {
                                    return null;
                                  }

                                  final validCharacters = RegExp(
                                      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
                                  if (validCharacters.hasMatch(val) == false) {
                                    return 'Invalid Email Address';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                  suffixIcon: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Verify',
                                      style: kSubTitleText.copyWith(
                                          color: Colors.blue.shade300),
                                    ),
                                  ),
                                  labelText: 'Email (optional)',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {
                                  emailAddress = val;
                                },
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),
                    ),
                  )),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
