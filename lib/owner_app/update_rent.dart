import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hiveRooms_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/main.dart';

class OwnerUpdateRent extends StatefulWidget {
  @override
  _OwnerUpdateRentState createState() => _OwnerUpdateRentState();
}

class _OwnerUpdateRentState extends State<OwnerUpdateRent> {
  late Box<RoomData> roomsBox;

  @override
  void initState() {
    super.initState();
    roomsBox = Hive.box<RoomData>(roomsbox);
  }

  String getRoomType(String roomtype) {
    if (roomtype == 'p')
      return 'Private Room';
    else if (roomtype == 'd')
      return 'Double Sharing';
    else if (roomtype == 't')
      return 'Triple Sharing';
    else
      return 'Multi Sharing';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kBackgroundColor,
        title: Text(
          'Update Rent',
          style: TextStyle(color: kLightBlackColor),
        ),
        leading: BackButton(
          color: kLightBlackColor,
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30.h, right: 50.w, left: 50.w),
        child: ValueListenableBuilder(
            valueListenable: roomsBox.listenable(),
            builder: (context, Box<RoomData> v, _) {
              List<int> keys = v.keys.cast<int>().toList();
              return ListView.separated(
                  separatorBuilder: (_, index) => SizedBox(height: 10.h),
                  itemBuilder: (_, index) {
                    final int key = keys[index];
                    final RoomData? room = v.get(key);
                    final GlobalKey<FormState> _formKey =
                        GlobalKey<FormState>();
                    TextEditingController _rent = TextEditingController();
                    TextEditingController _secdep = TextEditingController();
                    _rent.text = room!.rent;
                    _secdep.text = room.securityDeposit;
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 20.h),
                      child: Material(
                        color: kBackgroundColor,
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10.0),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (_) => Form(
                                      key: _formKey,
                                      child: AlertDialog(
                                        title: Text(
                                          'Enter New Rent',
                                          style: kSubTitleText,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            TextFormField(
                                              controller: _rent,
                                              validator: (val) {
                                                if (val == null || val.isEmpty)
                                                  return 'Rent cannot be Empty';

                                                RegExp r = RegExp(r'^[0-9]*$');
                                                if (!r.hasMatch(val))
                                                  return 'Invalid rent';

                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: InputDecoration(
                                                  prefixText: '₹',
                                                  isDense: true,
                                                  hintText: 'Rent'),
                                              style: TextStyle(
                                                fontSize: 40.h,
                                                letterSpacing: 0.5,
                                                height: 1.2,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 50.h,
                                            ),
                                            TextFormField(
                                              controller: _secdep,
                                              validator: (val) {
                                                if (val == null || val.isEmpty)
                                                  return 'Cannot be Empty';

                                                RegExp r = RegExp(r'^[0-9]*$');
                                                if (!r.hasMatch(val))
                                                  return 'Invalid rent';

                                                return null;
                                              },
                                              keyboardType:
                                                  TextInputType.number,
                                              autovalidateMode: AutovalidateMode
                                                  .onUserInteraction,
                                              decoration: InputDecoration(
                                                  prefixText: '₹',
                                                  isDense: true,
                                                  floatingLabelBehavior:
                                                      FloatingLabelBehavior
                                                          .always,
                                                  labelText:
                                                      'Security Deposit'),
                                              style: TextStyle(
                                                fontSize: 40.h,
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
                                                    style:
                                                        kSubTitleText.copyWith(
                                                            color: Colors
                                                                .redAccent),
                                                  )),
                                              TextButton(
                                                  onPressed: () async {
                                                    if (_formKey.currentState!
                                                        .validate()) {
                                                      room.rent = _rent.text;
                                                      room.securityDeposit =
                                                          _secdep.text;

                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    }
                                                  },
                                                  child: Text(
                                                    'Submit',
                                                    style:
                                                        kSubTitleText.copyWith(
                                                            color: Colors.blue),
                                                  )),
                                            ],
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                          )
                                        ],
                                      ),
                                    ));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 50.w, vertical: 30.h),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border:
                                    Border.all(color: Colors.grey.shade400)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      getRoomType(room.roomType),
                                      style: kSubTitleText.copyWith(
                                          fontWeight: FontWeight.bold),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                        text: '₹ ${room.rent}',
                                        style: kSubTitleText.copyWith(
                                            fontWeight: FontWeight.bold),
                                        children: <TextSpan>[
                                          TextSpan(
                                              text: '/bed',
                                              style: TextStyle(
                                                fontSize: 40.sp,
                                                color: Colors.grey.shade600,
                                              )),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'One time security deposite',
                                      style: kSubTitleText.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade700),
                                    ),
                                    Text(
                                      '₹ ${room.securityDeposit}',
                                      style: kSubTitleText.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey.shade800),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  itemCount: keys.length);
            }),
      ),
    );
  }
}
