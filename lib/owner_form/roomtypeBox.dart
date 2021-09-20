import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'widgets/custom_widgets.dart';
import 'data_provider.dart';
import 'package:provider/provider.dart';

List<String> facilites = [
  'Attached Balcony',
  'Attached Bathroom',
  'AC',
  'Almirah/Cupboard',
  'Chair',
  'Cooler',
  'Fridge',
  'Table',
  'TV',
];

class RoomTypeBox extends StatefulWidget {
  int index;
  Function onDelete;
  RoomTypeBox({Key? key, required this.index, required this.onDelete})
      : super(key: key);

  @override
  _RoomTypeBoxState createState() => _RoomTypeBoxState();
}

class _RoomTypeBoxState extends State<RoomTypeBox> {
  TextEditingController _rent = TextEditingController();
  TextEditingController _securitydeposit = TextEditingController();

  String roomType = "";
  @override
  void initState() {
    super.initState();
    initialize();
  }

  void initialize() async {
    var data = Provider.of<DataProvider>(context, listen: false);
    roomType = data.roomData[widget.index].roomType;
    _rent.text = data.roomData[widget.index].rent;
    _securitydeposit.text = data.roomData[widget.index].securityDeposit;
  }

  Widget fieldRequired(DataProvider data) {
    if (data.getshowrtError() &&
        (data.roomData[widget.index].roomType == "" ||
            _securitydeposit.text == "" ||
            !RegExp(r'^[0-9]*$').hasMatch(_securitydeposit.text) ||
            _rent.text == "" ||
            !RegExp(r'^[0-9]*$').hasMatch(_rent.text)))
      return Text(
        'Fields Required',
        style: kSubTitleText.copyWith(color: Colors.red),
      );

    return SizedBox();
  }

  List<Widget> showFacilites(DataProvider data) {
    List<Widget> fac = [];
    for (String i in data.roomData[widget.index].facilities) {
      fac.add(Material(
        color: kBackgroundColor,
        child: InkWell(
          onTap: () {
            data.deleteFacility(s: i, index: widget.index);
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

  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    roomType = data.roomData[widget.index].roomType;
    // _rent.text = data.roomData[widget.index].rent;
    // _securitydeposit.text = data.roomData[widget.index].securityDeposit;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        margin: EdgeInsets.fromLTRB(40.w, 0, 40.w, 50.h),
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade400),
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 30.h),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Room Type',
                    style: kSubTitleText.copyWith(fontWeight: FontWeight.bold),
                  ),
                  fieldRequired(data),
                  if (data.roomData.length > 1)
                    GestureDetector(
                      onTap: () async {
                        await widget.onDelete();

                        _rent.text = data.roomData[widget.index].rent;
                        _securitydeposit.text =
                            data.roomData[widget.index].securityDeposit;
                      },
                      child: Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                    )
                ],
              ),
            ),
            SizedBox(
              height: 10.h,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioButtonBox(
                            bordercolour: (roomType == 'p')
                                ? Colors.blue
                                : ((data.showRTError &&
                                        data.roomData[widget.index].roomType ==
                                            "")
                                    ? Colors.red
                                    : Colors.grey.shade400),
                            backgroundcolour: (roomType == 'p')
                                ? Colors.blue
                                : kBackgroundColor,
                            textcolour: (roomType == 'p')
                                ? Colors.white
                                : kLightBlackColor,
                            text: 'Private Room',
                            onPressed: () {
                              setState(() {
                                roomType = 'p';
                                data.updateRoomType(
                                    index: widget.index, roomtype: 'p');
                              });
                            }),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Expanded(
                        child: RadioButtonBox(
                            bordercolour: (roomType == 'd')
                                ? Colors.blue
                                : ((data.showRTError &&
                                        data.roomData[widget.index].roomType ==
                                            "")
                                    ? Colors.red
                                    : Colors.grey.shade400),
                            backgroundcolour: (roomType == 'd')
                                ? Colors.blue
                                : kBackgroundColor,
                            textcolour: (roomType == 'd')
                                ? Colors.white
                                : kLightBlackColor,
                            text: 'Double Sharing',
                            onPressed: () {
                              setState(() {
                                roomType = 'd';
                                data.updateRoomType(
                                    index: widget.index, roomtype: 'd');
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: RadioButtonBox(
                            bordercolour: (roomType == 't')
                                ? Colors.blue
                                : ((data.showRTError &&
                                        data.roomData[widget.index].roomType ==
                                            "")
                                    ? Colors.red
                                    : Colors.grey.shade400),
                            backgroundcolour: (roomType == 't')
                                ? Colors.blue
                                : kBackgroundColor,
                            textcolour: (roomType == 't')
                                ? Colors.white
                                : kLightBlackColor,
                            text: 'Triple Sharing',
                            onPressed: () {
                              setState(() {
                                roomType = 't';
                                data.updateRoomType(
                                    index: widget.index, roomtype: 't');
                              });
                            }),
                      ),
                      SizedBox(
                        width: 50.w,
                      ),
                      Expanded(
                        child: RadioButtonBox(
                            bordercolour: (roomType == 'm')
                                ? Colors.blue
                                : ((data.showRTError &&
                                        data.roomData[widget.index].roomType ==
                                            "")
                                    ? Colors.red
                                    : Colors.grey.shade400),
                            backgroundcolour: (roomType == 'm')
                                ? Colors.blue
                                : kBackgroundColor,
                            textcolour: (roomType == 'm')
                                ? Colors.white
                                : kLightBlackColor,
                            text: 'Multi Sharing',
                            onPressed: () {
                              setState(() {
                                roomType = 'm';
                                data.updateRoomType(
                                    index: widget.index, roomtype: 'm');
                              });
                            }),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          controller: _rent,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            prefix: Text('₹'),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Rent/month',
                            labelStyle: (data.showRTError && _rent.text == "" ||
                                    !RegExp(r'^[0-9]*$').hasMatch(_rent.text))
                                ? TextStyle(color: Colors.red)
                                : null,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: '0',
                          ),
                          style: TextStyle(fontSize: 50.sp),
                          onChanged: (val) {
                            data.updateRoomRent(
                                index: widget.index, rent: _rent.text);
                          },
                        ),
                      ),
                      SizedBox(
                        width: 100.w,
                      ),
                      Flexible(
                        child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _securitydeposit,
                          decoration: InputDecoration(
                            prefix: Text('₹'),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            labelText: 'Security Deposit',
                            labelStyle: (data.showRTError &&
                                        _securitydeposit.text == "" ||
                                    !RegExp(r'^[0-9]*$')
                                        .hasMatch(_securitydeposit.text))
                                ? TextStyle(color: Colors.red)
                                : null,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            hintText: '0',
                          ),
                          style: TextStyle(fontSize: 50.sp),
                          onChanged: (val) {
                            data.updateSecurityDeposit(
                                index: widget.index,
                                sec: _securitydeposit.text);
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 40.h,
                  ),
                  Text(
                    'Facilities Offered',
                    style: kSubTitleText.copyWith(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Wrap(
                    spacing: 30.w,
                    runSpacing: 20.h,
                    children: showFacilites(data),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Material(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            builder: (context) => BottomSheet(context, data),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ));
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 7.h),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
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
                  // RadioButtonBox(
                  //   text: '+Add',
                  //   onPressed: () {
                  //     FocusScope.of(context).unfocus();
                  //     showModalBottomSheet(
                  //         context: context,
                  //         backgroundColor: Colors.transparent,
                  //         builder: (context) => BottomSheet(context, data),
                  //         isScrollControlled: true,
                  //         shape: RoundedRectangleBorder(
                  //           borderRadius: BorderRadius.circular(10.0),
                  //         ));
                  //   },
                  //   bordercolour: Colors.blue.shade300,
                  // ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget BottomSheet(BuildContext context, DataProvider data) {
    return DraggableScrollableSheet(
      minChildSize: 0.2,
      initialChildSize: 0.7,
      maxChildSize: 0.9,
      builder: (_, controller) => Container(
        decoration: BoxDecoration(
            color: kBackgroundColor,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(10), topLeft: Radius.circular(10))),
        child: Column(
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
            Expanded(
              child: Container(
                child: ListView.builder(
                  controller: controller,
                  shrinkWrap: true,
                  itemCount: facilites.length,
                  itemBuilder: (context, index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Material(
                        color: kBackgroundColor,
                        child: InkWell(
                          onTap: () {
                            data.addFacility(
                                s: facilites[index], index: widget.index);
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: EdgeInsets.fromLTRB(50.w, 30.h, 50.w, 30.h),
                            child: Text(
                              facilites[index],
                              style: kSubTitleText,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Color(0xffDBDBDB),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
