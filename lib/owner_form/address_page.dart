import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/maps.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/owner_form/rent_page.dart';
import 'owner_page.dart';
import 'package:csc_picker/csc_picker.dart';
import 'widgets/custom_widgets.dart';
import 'package:provider/provider.dart';
import 'data_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({Key? key}) : super(key: key);
  static const String id = "address_page";

  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _state = TextEditingController();
  TextEditingController _city = TextEditingController();
  TextEditingController _postalCode = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _areaName = TextEditingController();
  TextEditingController _mapURL = TextEditingController();

  bool showDummyCSC = false;
  bool showCSCError = false;
  bool showMapError = false;

  void updateData() {
    var data = Provider.of<DataProvider>(context, listen: false);
    data.updateAddressData(
        state: _state.text,
        city: _city.text,
        postalCode: _postalCode.text,
        address: _address.text,
        mapurl: _mapURL.text,
        areaName: _areaName.text);
  }

  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    var data = Provider.of<DataProvider>(context, listen: false);
    if (data.addressDataUpdated) {
      _state.text = data.state;
      _city.text = data.city;
      _postalCode.text = data.postalCode;
      _address.text = data.address;
      _areaName.text = data.areaName;
      showDummyCSC = true;
      _mapURL.text = data.mapURL;
    } else {
      _state.text = "";
      _city.text = "";
      _postalCode.text = "";
      _address.text = "";
      _mapURL.text = '';
      _areaName.text = "";
      showDummyCSC = false;
      showCSCError = false;
    }

    print(showCSCError);
    print(_state.text);
    print(_city.text);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            //FocusScope.of(context).unfocus();
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
                                  OwnerPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                            // (Route<dynamic> route) => false,
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
                          if (_formKey.currentState!.validate() &&
                              (_state.text != "" &&
                                  _city.text != "" &&
                                  (HiveVariablesDB.getLocation() == 'true' ||
                                      _mapURL.text != ''))) {
                            updateData();
                            Navigator.pushReplacement(
                              context,
                              PageRouteBuilder(
                                pageBuilder:
                                    (context, animation1, animation2) =>
                                        RentPage(),
                                transitionDuration: Duration(milliseconds: 0),
                              ),
                              //(Route<dynamic> route) => false,
                            );
                          }
                          if (_state.text == "" || _city.text == "") {
                            setState(() {
                              showCSCError = true;
                            });
                          }
                          if (HiveVariablesDB.getLocation() != 'true' ||
                              _mapURL.text == '') {
                            setState(() {
                              showMapError = true;
                            });
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
                style: TextStyle(color: kBackgroundColor),
              ),
              bottom: PreferredSize(
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      AppbarBottom(text: 'Hostel'),
                      AppbarBottom(text: 'Owner'),
                      AppbarBottom(text: 'Address', isUnderlined: true),
                      AppbarBottom(text: 'Rent'),
                      AppbarBottom(text: 'Photos'),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(40),
              ),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Container(
                          margin: EdgeInsets.fromLTRB(50.w, 60.h, 70.w, 50.h),
                          child: Column(
                            children: [
                              Text(
                                'Address Details',
                                style: kTitleText,
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                              (showDummyCSC)
                                  ? GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          showDummyCSC = false;
                                          _state.text = "";
                                          _city.text = "";
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          TextFormField(
                                            enabled: false,
                                            controller: _state,
                                            decoration: InputDecoration(
                                                labelText: 'State',
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                  horizontal: 10,
                                                ),
                                                disabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Colors.grey.shade500,
                                                ))),
                                          ),
                                          SizedBox(height: 50.h),
                                          TextFormField(
                                            enabled: false,
                                            controller: _city,
                                            decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                    color: Colors.blue),
                                                labelText: 'City',
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior
                                                        .always,
                                                contentPadding:
                                                    EdgeInsets.symmetric(
                                                        horizontal: 10),
                                                disabledBorder:
                                                    UnderlineInputBorder(
                                                        borderSide: BorderSide(
                                                  color: Colors.grey.shade500,
                                                ))),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        if (_state.text == "" && showCSCError)
                                          Text(
                                            'Required',
                                            style: TextStyle(
                                                fontSize: 40.sp,
                                                color: Colors.red[900]),
                                          ),
                                        CSCPicker(
                                          showStates: true,
                                          showCities: true,
                                          layout: Layout.vertical,
                                          dropdownDecoration: BoxDecoration(
                                              color: kBackgroundColor,
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color:
                                                          (_state.text == "" &&
                                                                  showCSCError)
                                                              ? Colors.red
                                                              : Colors.grey
                                                                  .shade500,
                                                      width: 1))),
                                          disabledDropdownDecoration:
                                              BoxDecoration(
                                                  color:
                                                      (_state.text ==
                                                                  "" &&
                                                              showCSCError)
                                                          ? Colors.red.shade200
                                                          : Colors
                                                              .grey.shade300,
                                                  border: Border(
                                                      bottom: BorderSide(
                                                          color: Colors
                                                              .grey.shade300,
                                                          width: 1))),
                                          selectedItemStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 45.sp,
                                          ),
                                          dropdownHeadingStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 50.sp,
                                              fontWeight: FontWeight.bold),
                                          dropdownItemStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 40.sp,
                                          ),
                                          dropdownDialogRadius: 10.0,
                                          searchBarRadius: 10.0,
                                          defaultCountry: DefaultCountry.India,
                                          onCountryChanged: (value) {
                                            setState(() {});
                                          },
                                          onStateChanged: (value) {
                                            if (value != null)
                                              _state.text = value;

                                            if (value == null) _state.text = "";
                                          },
                                          onCityChanged: (value) {
                                            if (value != null)
                                              _city.text = value;

                                            if (value == null) _city.text = "";
                                          },
                                        ),
                                        if (_city.text == "" && showCSCError)
                                          Text(
                                            'Required',
                                            style: TextStyle(
                                                fontSize: 40.sp,
                                                color: Colors.red[900]),
                                          ),
                                      ],
                                    ),
                              SizedBox(
                                height: 50.h,
                              ),
                              TextFormField(
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
                                keyboardType: TextInputType.number,
                                controller: _postalCode,
                                decoration: InputDecoration(
                                  labelText: 'Postal Code',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {},
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                              TextFormField(
                                keyboardType: TextInputType.multiline,
                                controller: _address,
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return 'Address cannot be blank';

                                  return null;
                                },
                                minLines: 1,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {},
                              ),
                              SizedBox(
                                height: 50.h,
                              ),
                              TextFormField(
                                controller: _areaName,
                                validator: (val) {
                                  if (val == null || val.isEmpty)
                                    return 'area cannot be blank';

                                  return null;
                                },
                                decoration: InputDecoration(
                                  labelText: 'Area Name',
                                  hintText: 'Locality',
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                ),
                                style: TextStyle(fontSize: 50.sp),
                                onChanged: (val) {},
                              ),
                              SizedBox(
                                height: 100.h,
                              ),
                              Text(
                                'Locate Hostel on Map',
                                style: kTitleText,
                              ),
                              if (showMapError)
                                Text(
                                  'Please Provide any one of the below',
                                  style: TextStyle(color: Colors.red.shade700),
                                ),
                              SizedBox(
                                height: 50.h,
                              ),
                              TextFormField(
                                maxLines: 3,
                                minLines: 1,
                                controller: _mapURL,
                                validator: (val) {
                                  if (!Uri.parse(val!).isAbsolute &&
                                      val.isEmpty == false) {
                                    return 'Invalid Link';
                                  }

                                  return null;
                                },
                                decoration: InputDecoration(
                                    hintText: 'Google Map Link',
                                    helperMaxLines: 3,
                                    isDense: true,
                                    helperText:
                                        'If your Hostel/PG is listed on Google Maps please paste the link to it here.'),
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              Row(
                                children: [
                                  Expanded(child: Divider()),
                                  Text('    OR    '),
                                  Expanded(child: Divider())
                                ],
                              ),
                              SizedBox(
                                height: 40.h,
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(color: Colors.blue)),
                                    child: Material(
                                      borderRadius: BorderRadius.circular(20),
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(20),
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) => LocateMap()));
                                        },
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: Colors.blue,
                                              ),
                                              SizedBox(width: 10.w),
                                              Text(
                                                'Select on Map',
                                                style: kSubTitleText.copyWith(
                                                    color: Colors.blue),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30.w,
                                  ),
                                  ValueListenableBuilder(
                                      valueListenable: HiveVariablesDB
                                          .variablesDB
                                          .listenable(),
                                      builder: (context, Box<String> v, _) {
                                        if (v.get(HiveVariablesDB
                                                .keyLocationGiven) ==
                                            'true')
                                          return Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          );
                                        return SizedBox();
                                      })
                                ],
                              ),
                              SizedBox(
                                height: 50.h,
                              )
                            ],
                            crossAxisAlignment: CrossAxisAlignment.start,
                          ),
                        ),
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
}
