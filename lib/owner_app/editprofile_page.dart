import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hostel_app/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';

class OwnerEditProfile extends StatefulWidget {
  @override
  _OwnerEditProfileState createState() => _OwnerEditProfileState();
}

class _OwnerEditProfileState extends State<OwnerEditProfile> {
  final TextEditingController _name = TextEditingController();

  final TextEditingController _mobile = TextEditingController();

  final TextEditingController _whatsapp = TextEditingController();

  final TextEditingController _email = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isButtonDisabled = true;

  @override
  void initState() {
    super.initState();
    _name.text = HiveVariablesDB.getOwnerName() ?? '';
    _mobile.text = HiveVariablesDB.getMobilenumber() ?? '';
    _whatsapp.text = MySharedPref.getWhatsappMobile() ?? '';
    _email.text = HiveVariablesDB.getEmail() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      bottomNavigationBar: GestureDetector(
        onTap: !isButtonDisabled
            ? () {
                if (_formKey.currentState!.validate()) {
                  HiveVariablesDB.setOwnerName(_name.text);
                  HiveVariablesDB.setMobilenumber(_mobile.text);
                  MySharedPref.setMobilenumber(_mobile.text);
                  MySharedPref.setWhatsappMobile(_whatsapp.text);
                  if (_email.text != "" && _email.text.length != 0)
                    HiveVariablesDB.setEmail(_email.text);
                  Navigator.pop(context);
                }
              }
            : null,
        child: Container(
          alignment: Alignment.center,
          color: isButtonDisabled ? Colors.grey.shade300 : Colors.blue,
          height: 150.h,
          child: Text(
            'Save',
            style: TextStyle(
                fontSize: 55.sp,
                fontWeight: FontWeight.w600,
                color: kBackgroundColor),
          ),
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(color: kLightBlackColor),
        ),
        leading: BackButton(
          color: kLightBlackColor,
        ),
        backgroundColor: kBackgroundColor,
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.only(top: 50.h),
              padding: EdgeInsets.symmetric(horizontal: 70.w),
              child: Column(
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                      radius: 38,
                      backgroundColor: Colors.transparent,
                      child: Image.asset(
                        'images_avators/Asset ${MySharedPref.getAvatar() + 1}.png',
                      )),
                  SizedBox(
                    height: 110.h,
                  ),
                  TextFormField(
                    controller: _name,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return 'Name cannot be blank';
                      }

                      final validCharacters = RegExp(r'^[a-zA-Z ]+$');
                      if (validCharacters.hasMatch(val) == false) {
                        return 'Name cannot contain numbers and special characters';
                      }

                      return null;
                    },
                    onChanged: (val) {
                      if (_formKey.currentState!.validate())
                        setState(() {
                          isButtonDisabled = false;
                        });
                      else
                        setState(() {
                          isButtonDisabled = true;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit Name',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  TextFormField(
                    controller: _mobile,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                      if (_formKey.currentState!.validate())
                        setState(() {
                          isButtonDisabled = false;
                        });
                      else
                        setState(() {
                          isButtonDisabled = true;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit Mobile Number',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  TextFormField(
                    controller: _whatsapp,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    onChanged: (val) {
                      if (_formKey.currentState!.validate())
                        setState(() {
                          isButtonDisabled = false;
                        });
                      else
                        setState(() {
                          isButtonDisabled = true;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit Whatsapp Number',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                  TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
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
                    onChanged: (val) {
                      if (_formKey.currentState!.validate())
                        setState(() {
                          isButtonDisabled = false;
                        });
                      else
                        setState(() {
                          isButtonDisabled = true;
                        });
                    },
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Edit Email',
                        floatingLabelBehavior: FloatingLabelBehavior.always),
                  ),
                  SizedBox(
                    height: 70.h,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
