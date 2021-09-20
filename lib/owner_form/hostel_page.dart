import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/aminities.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/owner_form/data_provider.dart';
import 'package:hostel_app/owner_form/owner_page.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:provider/provider.dart';
import 'widgets/custom_widgets.dart';

// List<String> facilites = [
//   "24X7 Female Caretaker",
//   "24X7 Male Caretaker",
//   '24X7 Security Guards',
//   'AC Study Room',
//   'Biometric Entry/Exit Gate',
//   'CCTV',
//   'Clean Common Washrooms',
//   'Common Room TV',
//   'Food from Centralised Kitchen',
//   'Fridge',
//   'Free Hi-Speed WiFi',
//   'Lift',
//   'Low-cost Laundry Service',
//   'Power Backup',
//   'Professional Housekeeping',
//   'RO Water',
//   'Unlimited Free of Charge Doctor Consultation',
//   'Water Cooler',
//   "",
// ];

enum Gender { boy, girl, none }

class HostelPage extends StatefulWidget {
  static const String id = "owner_basic1_page";

  @override
  _HostelPageState createState() => _HostelPageState();
}

class _HostelPageState extends State<HostelPage> {
  Gender selectedgender = Gender.none;
  late String hostelName = "";
  late String numberBeds = "";
  late bool hostel = false;
  late bool hostel_deactivated = true;
  late bool boy = false;
  late bool girl = false;
  late bool food = false;
  List<bool> foodtime = [false, false, false];
  late bool meals_deactivated = true;
  late bool landloard = false;
  late bool landloard_deactivated = true;
  late bool manager_stays_at_hotel = false;
  late bool manager_stays_at_hotel_deactivated = true;
  List<String> rulesForm = ['#', '#', '#', '#', '#'];

  bool showRequired = false;

  final ScrollController _scrollController = ScrollController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _hostelname = TextEditingController();
  TextEditingController _hostelDetails = TextEditingController();
  TextEditingController _beds = TextEditingController();

  List<Widget> showFacilites(DataProvider data) {
    List<Widget> fac = [];
    for (String i in data.commonFacilities) {
      fac.add(Material(
        color: kBackgroundColor,
        child: InkWell(
          onTap: () {
            data.deleteCommonFacility(s: i);
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 10.h),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  i,
                  style: TextStyle(color: kLightBlackColor, fontSize: 45.sp),
                ),
                SizedBox(
                  width: 10.w,
                ),
                Icon(
                  Icons.close,
                  size: 60.sp,
                ),
              ],
            ),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blue.shade300),
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
        ),
      ));
    }

    return fac;
  }

  void updataData() {
    var data = Provider.of<DataProvider>(context, listen: false);
    data.updateHostelData(
        hostelName: _hostelname.text,
        numberBeds: _beds.text,
        hostel: hostel,
        boy: boy,
        girl: girl,
        food: food,
        hosteldetails: _hostelDetails.text,
        foodtimes: foodtime,
        landLoard: landloard,
        managerStaysAtHostel: manager_stays_at_hotel,
        rulesAnswers: rulesForm);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    var data = Provider.of<DataProvider>(context, listen: false);
    if (data.hostelDataUpdated) {
      _hostelname.text = data.hostelName;
      _beds.text = data.numberBeds;
      _hostelDetails.text = data.hostelDetails;
      hostel = data.hostel;
      boy = data.boy;
      girl = data.girl;
      food = data.food;
      foodtime = data.foodtimes;
      landloard = data.landLoard;
      manager_stays_at_hotel = data.managerStaysAtHostel;
      rulesForm = data.rulesAnswers;
      hostel_deactivated = false;
      meals_deactivated = false;
      landloard_deactivated = false;
      manager_stays_at_hotel_deactivated = false;
    } else {
      hostel = false;
      boy = false;
      girl = false;
      food = false;
      landloard = false;
      manager_stays_at_hotel = false;
      foodtime = [false, false, false];
      rulesForm = ['#', '#', '#', '#', '#'];
      hostel_deactivated = true;
      meals_deactivated = true;
      landloard_deactivated = true;
      manager_stays_at_hotel_deactivated = true;
    }
  }

  bool validateform() {
    if (_beds.text.length == 0) return false;
    RegExp reg = RegExp(r'(^[0-9]*$)');
    if (!reg.hasMatch(_beds.text)) return false;

    return true;
  }

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            if (_formKey.currentState!.validate()) {}
          },
          child: Form(
            key: _formKey,
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              appBar: AppBar(
                backgroundColor: Colors.blue,
                elevation: 4,
                title: Text(
                  "Add your Hostel/PG",
                  style: TextStyle(color: kBackgroundColor),
                ),
                bottom: PreferredSize(
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        AppbarBottom(text: 'Hostel', isUnderlined: true),
                        AppbarBottom(text: 'Owner'),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: ListView(
                        controller: _scrollController,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(50.w, 40.h, 50.w, 10.h),
                            child: RequiredText(
                              asterisksize: 60,
                              text: ' marked fields are required',
                              textcolour: Colors.blue,
                              textsize: 40,
                              required: false,
                              error: false,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(50.w, 20.h, 50.w, 50.h),
                            child: Column(
                              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hostel/PG Details',
                                  style: kTitleText,
                                ),
                                Container(
                                  margin:
                                      EdgeInsets.only(top: 40.h, bottom: 10.h),
                                  child: TextFormField(
                                    controller: _hostelname,
                                    onChanged: (val) {
                                      hostelName = val;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle: TextStyle(
                                          fontSize: 15, color: Colors.red[900]),
                                      contentPadding:
                                          EdgeInsets.symmetric(horizontal: 10),
                                      labelText: 'Hostel Name',
                                    ),
                                    style: TextStyle(fontSize: 50.sp),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.fromLTRB(0, 20.h, 0, 35.h),
                                  child: TextFormField(
                                    controller: _beds,
                                    autovalidateMode:
                                        AutovalidateMode.onUserInteraction,
                                    validator: (val) {
                                      if (val == null || val.isEmpty) {
                                        return 'Required';
                                      }

                                      final number = int.tryParse(val);
                                      if (number == null) {
                                        return 'Should be a number';
                                      }

                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      errorStyle:
                                          TextStyle(color: Colors.red[900]),
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      labelText: 'Total number of Beds',
                                    ),
                                    keyboardType: TextInputType.number,
                                    style: TextStyle(fontSize: 50.sp),
                                    onChanged: (val) {
                                      numberBeds = val;
                                    },
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 30.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                          child: RequiredText(
                                        text: 'Property Type:',
                                        required: true,
                                        error: (showRequired &&
                                            hostel_deactivated),
                                      )),
                                      SizedBox(
                                        height: 30.w,
                                      ),
                                      Row(
                                        children: [
                                          RadioButtonBox(
                                            bordercolour: (hostel &&
                                                    hostel_deactivated == false)
                                                ? Colors.blue
                                                : (showRequired &&
                                                        hostel_deactivated)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'Hostel',
                                            onPressed: () {
                                              setState(() {
                                                hostel = true;
                                                hostel_deactivated = false;
                                              });
                                            },
                                            backgroundcolour: (hostel &&
                                                    hostel_deactivated == false)
                                                ? Colors.blue
                                                : kBackgroundColor,
                                            textcolour: (hostel &&
                                                    hostel_deactivated == false)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          RadioButtonBox(
                                            bordercolour: (!hostel &&
                                                    hostel_deactivated == false)
                                                ? Colors.blue
                                                : (showRequired &&
                                                        hostel_deactivated)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'PG',
                                            onPressed: () {
                                              setState(() {
                                                hostel = false;
                                                hostel_deactivated = false;
                                              });
                                            },
                                            backgroundcolour: (!hostel &&
                                                    hostel_deactivated == false)
                                                ? Colors.blue
                                                : kBackgroundColor,
                                            textcolour: (!hostel &&
                                                    hostel_deactivated == false)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 30.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Flexible(
                                        child: RequiredText(
                                            text: 'Hostel/PG is for:',
                                            required: true,
                                            error: (showRequired &&
                                                !boy &&
                                                !girl)),
                                      ),
                                      SizedBox(
                                        height: 30.w,
                                      ),
                                      Row(
                                        children: [
                                          RadioButtonBox(
                                            bordercolour: (boy)
                                                ? Colors.blue
                                                : (showRequired &&
                                                        !girl &&
                                                        !boy)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'Boys',
                                            onPressed: () {
                                              setState(() {
                                                selectedgender = Gender.boy;
                                                boy = !boy;
                                              });
                                            },
                                            backgroundcolour: (boy)
                                                ? Colors.blue
                                                : kBackgroundColor,
                                            textcolour: (boy)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          RadioButtonBox(
                                            bordercolour: (girl)
                                                ? Colors.purple
                                                : (showRequired &&
                                                        !girl &&
                                                        !boy)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'Girls',
                                            onPressed: () {
                                              setState(() {
                                                selectedgender = Gender.girl;
                                                girl = !girl;
                                              });
                                            },
                                            backgroundcolour: (girl)
                                                ? Colors.purple
                                                : kBackgroundColor,
                                            textcolour: (girl)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                    margin:
                                        EdgeInsets.symmetric(vertical: 30.h),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        RequiredText(
                                          text: 'Food Available:',
                                          required: true,
                                          error: (showRequired &&
                                              meals_deactivated),
                                        ),
                                        SizedBox(
                                          height: 30.w,
                                        ),
                                        Row(
                                          children: [
                                            RadioButtonBox(
                                              bordercolour: (food &&
                                                      meals_deactivated ==
                                                          false)
                                                  ? kBorderGreenColor
                                                  : (showRequired &&
                                                          meals_deactivated)
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade400,
                                              text: 'YES',
                                              onPressed: () {
                                                setState(() {
                                                  food = true;
                                                  meals_deactivated = false;
                                                });
                                              },
                                              backgroundcolour: (food &&
                                                      meals_deactivated ==
                                                          false)
                                                  ? kBackgroundLigntGreenColor
                                                  : kBackgroundColor,
                                              textcolour: (food &&
                                                      meals_deactivated ==
                                                          false)
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                            SizedBox(
                                              width: 30.w,
                                            ),
                                            RadioButtonBox(
                                              bordercolour: (!food &&
                                                      meals_deactivated ==
                                                          false)
                                                  ? kBorderRedColor
                                                  : (showRequired &&
                                                          meals_deactivated)
                                                      ? Colors.red.shade300
                                                      : Colors.grey.shade400,
                                              text: 'NO',
                                              onPressed: () {
                                                setState(() {
                                                  food = false;
                                                  meals_deactivated = false;
                                                });
                                              },
                                              backgroundcolour: (!food &&
                                                      meals_deactivated ==
                                                          false)
                                                  ? kBackgroundLigntRedColor
                                                  : kBackgroundColor,
                                              textcolour: (!food &&
                                                      meals_deactivated ==
                                                          false)
                                                  ? Colors.white
                                                  : Colors.black87,
                                            ),
                                          ],
                                        ),
                                        if (food && !meals_deactivated)
                                          Padding(
                                            padding: EdgeInsets.only(top: 50.h),
                                            child: Row(
                                              children: [
                                                RadioButtonBox(
                                                  onPressed: () {
                                                    setState(() {
                                                      foodtime[0] =
                                                          !foodtime[0];
                                                    });
                                                  },
                                                  text: 'Breakfast',
                                                  bordercolour: (foodtime[0])
                                                      ? Colors.blue
                                                      : Colors.grey.shade400,
                                                  backgroundcolour:
                                                      (foodtime[0])
                                                          ? Colors.blue
                                                          : kBackgroundColor,
                                                  textcolour: (foodtime[0])
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                                SizedBox(
                                                  width: 30.w,
                                                ),
                                                RadioButtonBox(
                                                  onPressed: () {
                                                    setState(() {
                                                      foodtime[1] =
                                                          !foodtime[1];
                                                    });
                                                  },
                                                  text: 'Lunch',
                                                  bordercolour: (foodtime[1])
                                                      ? Colors.blue
                                                      : Colors.grey.shade400,
                                                  backgroundcolour:
                                                      (foodtime[1])
                                                          ? Colors.blue
                                                          : kBackgroundColor,
                                                  textcolour: (foodtime[1])
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                                SizedBox(
                                                  width: 30.w,
                                                ),
                                                RadioButtonBox(
                                                  onPressed: () {
                                                    setState(() {
                                                      foodtime[2] =
                                                          !foodtime[2];
                                                    });
                                                  },
                                                  text: 'Dinner',
                                                  bordercolour: (foodtime[2])
                                                      ? Colors.blue
                                                      : Colors.grey.shade400,
                                                  backgroundcolour:
                                                      (foodtime[2])
                                                          ? Colors.blue
                                                          : kBackgroundColor,
                                                  textcolour: (foodtime[2])
                                                      ? Colors.white
                                                      : Colors.black87,
                                                ),
                                              ],
                                            ),
                                          ),
                                      ],
                                    )),
                              ],
                            ),
                          ),
                          kdividerLine,
                          Container(
                            margin: EdgeInsets.fromLTRB(50.w, 50.h, 50.w, 70.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Owner/Caretaker Details',
                                  style: kTitleText,
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 50.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RequiredText(
                                        text: 'Hostel/PG managed by:',
                                        required: true,
                                        error: (showRequired &&
                                            landloard_deactivated),
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      Row(
                                        children: [
                                          RadioButtonBox(
                                            bordercolour: (landloard &&
                                                    landloard_deactivated ==
                                                        false)
                                                ? Colors.blue
                                                : (showRequired &&
                                                        landloard_deactivated)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'Landlord',
                                            onPressed: () {
                                              setState(() {
                                                landloard = true;
                                                landloard_deactivated = false;
                                              });
                                            },
                                            backgroundcolour: (landloard &&
                                                    landloard_deactivated ==
                                                        false)
                                                ? Colors.blue
                                                : kBackgroundColor,
                                            textcolour: (landloard &&
                                                    landloard_deactivated ==
                                                        false)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          RadioButtonBox(
                                            bordercolour: (!landloard &&
                                                    landloard_deactivated ==
                                                        false)
                                                ? Colors.blue
                                                : (showRequired &&
                                                        landloard_deactivated)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'Caretaker',
                                            onPressed: () {
                                              setState(() {
                                                landloard = false;
                                                landloard_deactivated = false;
                                              });
                                            },
                                            backgroundcolour: (!landloard &&
                                                    landloard_deactivated ==
                                                        false)
                                                ? Colors.blue
                                                : kBackgroundColor,
                                            textcolour: (!landloard &&
                                                    landloard_deactivated ==
                                                        false)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 50.h),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RequiredText(
                                        text:
                                            'Hostel/PG manager stays at hotel:',
                                        required: true,
                                        error: (showRequired &&
                                            manager_stays_at_hotel_deactivated),
                                      ),
                                      SizedBox(
                                        height: 30.h,
                                      ),
                                      Row(
                                        children: [
                                          RadioButtonBox(
                                            bordercolour: (manager_stays_at_hotel &&
                                                    manager_stays_at_hotel_deactivated ==
                                                        false)
                                                ? kBorderGreenColor
                                                : (showRequired &&
                                                        manager_stays_at_hotel_deactivated)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'YES',
                                            onPressed: () {
                                              setState(() {
                                                manager_stays_at_hotel = true;
                                                manager_stays_at_hotel_deactivated =
                                                    false;
                                              });
                                            },
                                            backgroundcolour:
                                                (manager_stays_at_hotel &&
                                                        manager_stays_at_hotel_deactivated ==
                                                            false)
                                                    ? kBackgroundLigntGreenColor
                                                    : kBackgroundColor,
                                            textcolour: (manager_stays_at_hotel &&
                                                    manager_stays_at_hotel_deactivated ==
                                                        false)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                          SizedBox(
                                            width: 30.w,
                                          ),
                                          RadioButtonBox(
                                            bordercolour: (!manager_stays_at_hotel &&
                                                    manager_stays_at_hotel_deactivated ==
                                                        false)
                                                ? kBorderRedColor
                                                : (showRequired &&
                                                        manager_stays_at_hotel_deactivated)
                                                    ? Colors.red.shade300
                                                    : Colors.grey.shade400,
                                            text: 'NO',
                                            onPressed: () {
                                              setState(() {
                                                manager_stays_at_hotel = false;
                                                manager_stays_at_hotel_deactivated =
                                                    false;
                                              });
                                            },
                                            backgroundcolour:
                                                (!manager_stays_at_hotel &&
                                                        manager_stays_at_hotel_deactivated ==
                                                            false)
                                                    ? kBackgroundLigntRedColor
                                                    : kBackgroundColor,
                                            textcolour: (!manager_stays_at_hotel &&
                                                    manager_stays_at_hotel_deactivated ==
                                                        false)
                                                ? Colors.white
                                                : Colors.black87,
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kdividerLine,
                          Container(
                            margin: EdgeInsets.fromLTRB(50.w, 50.h, 50.w, 70.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Common Hostel Facilities',
                                  style: kTitleText,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                                Text(
                                  'Amenities/Facilities provided by your Hostel/Pg',
                                  style: kSubSubTitleText,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                                Wrap(
                                  spacing: 30.w,
                                  runSpacing: 20.h,
                                  children: showFacilites(data),
                                ),
                                SizedBox(
                                  height: 40.h,
                                ),
                                Material(
                                  child: InkWell(
                                    onTap: () {
                                      showModalBottomSheet(
                                          context: context,
                                          backgroundColor: Colors.transparent,
                                          builder: (context) =>
                                              BottomSheet(context, data),
                                          isScrollControlled: true,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(20)),
                                          ));
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.symmetric(vertical: 7.h),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(color: Colors.blue),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add),
                                          Text(
                                            'ADD',
                                            style: kSubTitleText,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kdividerLine,
                          Container(
                            margin: EdgeInsets.fromLTRB(50.w, 50.h, 50.w, 70.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'About Hostel',
                                  style: kTitleText,
                                ),
                                SizedBox(
                                  height: 50.h,
                                ),
                                TextFormField(
                                  controller: _hostelDetails,
                                  onChanged: (val) {},
                                  minLines: 2,
                                  maxLines: 10,
                                  decoration: InputDecoration(
                                    hintText:
                                        'write something about your hostel',
                                    border: OutlineInputBorder(),
                                    isDense: true,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          kdividerLine,
                          Container(
                            margin: EdgeInsets.fromLTRB(50.w, 50.h, 50.w, 70.h),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hostel/PG Rules',
                                  style: kTitleText,
                                ),
                                Hostelrule(0),
                                Hostelrule(1),
                                Hostelrule(2),
                                Hostelrule(3),
                                Hostelrule(4),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          ButtonTheme(
                            height: 150.h,
                            child: RaisedButton(
                              onPressed: () {
                                if (!hostel_deactivated &&
                                    (boy || girl) &&
                                    !meals_deactivated &&
                                    !landloard_deactivated &&
                                    !manager_stays_at_hotel_deactivated &&
                                    validateform()) {
                                  setState(() {
                                    showRequired = false;
                                  });
                                  updataData();

                                  Navigator.pushReplacement(
                                    context,
                                    PageRouteBuilder(
                                      pageBuilder:
                                          (context, animation1, animation2) =>
                                              OwnerPage(),
                                      transitionDuration: Duration(seconds: 0),
                                    ),
                                    // (Route<dynamic> route) => false,
                                  );
                                } else {
                                  setState(() {
                                    _scrollController.animateTo(
                                        _scrollController
                                            .position.minScrollExtent,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.fastOutSlowIn);
                                    showRequired = true;
                                  });
                                }
                              },
                              color: Colors.blue,
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
                                      size: 60.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget BottomSheet(BuildContext context, DataProvider data) {
    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      minChildSize: 0.2,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(Icons.close)),
                Text(
                  'Select Facility',
                  style: kTitleText.copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
            SizedBox(
              height: 20.h,
            ),
            Expanded(
              child: Container(
                child: ListView.builder(
                    controller: controller,
                    shrinkWrap: true,
                    itemCount: Amenities().facilities.length,
                    itemBuilder: (context, index) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Material(
                            color: kBackgroundColor,
                            child: InkWell(
                                onTap: () {
                                  data.addCommonFacility(
                                      s: Amenities().facilities[index]);
                                  Navigator.pop(context);
                                  setState(() {});
                                },
                                child: CheckboxListTile(
                                  title: Container(
                                    margin: EdgeInsets.fromLTRB(
                                        50.w, 30.h, 50.w, 30.h),
                                    child: Text(
                                      Amenities().facilities[index],
                                      style: kSubTitleText,
                                    ),
                                  ),
                                  value: false,
                                  onChanged: (newValue) {},
                                  controlAffinity: ListTileControlAffinity
                                      .leading, //  <-- leading Checkbox
                                )),
                          ),
                          Container(
                            width: double.infinity,
                            height: 1,
                            color: Color(0xffDBDBDB),
                          ),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container Hostelrule(int index) {
    return Container(
      margin: EdgeInsets.only(top: 50.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            HostelRules[index],
            style: kSubTitleText,
          ),
          SizedBox(
            height: 30.h,
          ),
          Row(
            children: [
              RadioButtonBox(
                bordercolour: (rulesForm[index] == '1')
                    ? kBorderGreenColor
                    : Colors.grey.shade400,
                text: 'YES',
                onPressed: () {
                  setState(() {
                    if (rulesForm[index] == "1")
                      rulesForm[index] = '#';
                    else
                      rulesForm[index] = "1";
                  });
                },
                backgroundcolour: (rulesForm[index] == '1')
                    ? kBackgroundLigntGreenColor
                    : kBackgroundColor,
                textcolour:
                    (rulesForm[index] == '1') ? Colors.white : Colors.black87,
              ),
              SizedBox(
                width: 30.w,
              ),
              RadioButtonBox(
                bordercolour: (rulesForm[index] == '0')
                    ? kBorderRedColor
                    : Colors.grey.shade400,
                text: 'NO',
                onPressed: () {
                  setState(() {
                    if (rulesForm[index] == "0")
                      rulesForm[index] = '#';
                    else
                      rulesForm[index] = "0";
                  });
                },
                backgroundcolour: (rulesForm[index] == '0')
                    ? kBackgroundLigntRedColor
                    : kBackgroundColor,
                textcolour:
                    (rulesForm[index] == '0') ? Colors.white : Colors.black87,
              ),
            ],
          )
        ],
      ),
    );
  }
}

class RequiredText extends StatelessWidget {
  final String text;
  final bool required;
  final bool error;
  final int asterisksize;
  final int textsize;
  final Color textcolour;
  RequiredText(
      {required this.text,
      this.required = false,
      this.error = false,
      this.asterisksize = 48,
      this.textsize = 48,
      this.textcolour = kLightBlackColor});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '* ',
              style: TextStyle(
                fontSize: asterisksize.sp,
                color: Colors.red[900],
              ),
            ),
            Text(
              text,
              style: TextStyle(
                fontSize: textsize.sp,
                color: textcolour,
              ),
            ),
          ],
        ),
        if (required && error)
          Text(
            'Required',
            style: TextStyle(fontSize: 40.sp, color: Colors.red[900]),
          )
      ],
    );
  }
}

// Container(
// margin: EdgeInsets.fromLTRB(
// 50.w, 30.h, 50.w, 30.h),
// child: Text(
// Amenities().facilities[index],
// style: kSubTitleText,
// ),
// ),
