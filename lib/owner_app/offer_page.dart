import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/main.dart';
import 'package:hostel_app/models/hiveoffers_model.dart';
import 'package:hive_flutter/hive_flutter.dart';

late Box<OwnerOffers> offersBox;

class OfferPage extends StatefulWidget {
  const OfferPage({Key? key}) : super(key: key);

  @override
  _OfferPageState createState() => _OfferPageState();
}

class _OfferPageState extends State<OfferPage> {
  @override
  void initState() {
    super.initState();
    offersBox = Hive.box<OwnerOffers>(offersbox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: Container(
        margin: EdgeInsets.only(bottom: 10),
        child: FloatingActionButton(
          heroTag: null,
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) => AddOfferDialog(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            );
          },
          child: Icon(Icons.add),
        ),
      ),
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: kLightBlackColor, //change your color here
        ),
        backgroundColor: kBackgroundColor,
        title: Text(
          'Offers',
          style: TextStyle(color: kLightBlackColor),
        ),
      ),
      body: ListView(
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 30.h, right: 20.w, left: 20.w),
            child: Text(
              'Offer can only be deleted within 24 hours of its creation, after that it will be deleted only when its time period is over.',
              textAlign: TextAlign.center,
              style: kSubSubTitleText.copyWith(color: Colors.grey.shade700),
            ),
          ),
          SizedBox(
            height: 50.h,
          ),
          ValueListenableBuilder(
              valueListenable: offersBox.listenable(),
              builder: (context, Box<OwnerOffers> v, _) {
                List<int> keys = v.keys.cast<int>().toList();
                return (keys.length > 0)
                    ? ListView.separated(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        separatorBuilder: (_, index) => SizedBox(height: 30.h),
                        itemBuilder: (_, index) {
                          final int key = keys[index];
                          final OwnerOffers? offer = v.get(key);
                          return Container(
                              margin: EdgeInsets.symmetric(horizontal: 30.w),
                              padding: EdgeInsets.only(
                                  left: 30.w,
                                  top: 35.h,
                                  bottom: 35.h,
                                  right: 10.w),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey.shade400),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          offer!.title,
                                          style: TextStyle(
                                              fontSize: 55.sp,
                                              fontWeight: FontWeight.w500,
                                              color: kLightBlackColor),
                                        ),
                                        SizedBox(
                                          height: 10.h,
                                        ),
                                        Text(
                                          offer.details,
                                          style: TextStyle(
                                              fontSize: 48.sp,
                                              color: Colors.grey.shade700),
                                        ),
                                        SizedBox(
                                          height: 30.h,
                                        ),
                                        Text(
                                          'Time Period : ${offer.timePeriod}',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Column(
                                    children: [
                                      if (DateTime.now()
                                              .difference(offer.timeCreated)
                                              .inHours <=
                                          24)
                                        PopupMenuButton(
                                          onSelected: (val) {
                                            v.delete(key);
                                          },
                                          itemBuilder: (_) => [
                                            PopupMenuItem(
                                              height: 30,
                                              value: 1,
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Icon(
                                                    Icons.delete,
                                                    color: Colors.red.shade700,
                                                  ),
                                                  Text("  Delete Offer"),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Text(
                                          getTimeCreated(offer.timeCreated),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                        itemCount: keys.length)
                    : Container(
                        height: 0.5.sh,
                        child: Center(
                          child: Text(
                            "No offers added yet.\n\nTap '+' to add",
                            textAlign: TextAlign.center,
                            style: kSubTitleText,
                          ),
                        ),
                      );
              }),
          SizedBox(
            height: 200.h,
          ),
        ],
      ),
    );
  }
}

String getTimeCreated(DateTime createdOn) {
  Duration ans = DateTime.now().difference(createdOn);
  if (ans.inSeconds < 60)
    return 'now';
  else if (ans.inMinutes < 60)
    return '${ans.inMinutes} min';
  else if (ans.inHours < 24)
    return '${ans.inHours} H';
  else if (ans.inDays < 7)
    return '${ans.inDays} D';
  else if (ans.inDays < 30)
    return '${ans.inDays ~/ 7} W';
  else
    return '${ans.inDays ~/ 30} M';
}

var titlestyle = TextStyle(
    fontWeight: FontWeight.w500, fontSize: 53.sp, color: kLightBlackColor);

class AddOfferDialog extends StatefulWidget {
  @override
  _AddOfferDialogState createState() => _AddOfferDialogState();
}

class _AddOfferDialogState extends State<AddOfferDialog> {
  String? _chosenValue;
  bool error = false;
  TextEditingController _title = TextEditingController();
  TextEditingController _details = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        maxChildSize: 0.92,
        minChildSize: 0.1,
        builder: (_, controller) => Container(
          decoration: BoxDecoration(
              color: kBackgroundColor,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10), topLeft: Radius.circular(10))),
          child: Form(
            key: _formKey,
            child: ListView(
              controller: controller,
              children: [
                Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close)),
                    Text(
                      'Add Offer',
                      style: kTitleText.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.h,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 50.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Offer Title', style: titlestyle),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: _title,
                        maxLines: 2,
                        minLines: 1,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Title cannot be empty';
                          }

                          return null;
                        },
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextStyle(fontSize: 53.sp),
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Title here..',
                          helperText:
                              'Example - \n❁ 10% OFF this month\n❁ Festival offer flat ₹500 OFF',
                        ),
                        onChanged: (val) {},
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                      Text(
                        'Offer Details',
                        style: titlestyle,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      TextFormField(
                        controller: _details,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (val) {
                          if (val == null || val.isEmpty) {
                            return 'Details cannot be empty';
                          }

                          return null;
                        },
                        style: TextStyle(fontSize: 53.sp),
                        minLines: 1,
                        maxLines: 5,
                        decoration: InputDecoration(
                          isDense: true,
                          hintText: 'Details here..',
                          helperText:
                              'Example - \n❁ Applicable on only one month rent\n❁ Only for new customers',
                        ),
                        onChanged: (val) {},
                      ),
                      SizedBox(
                        height: 100.h,
                      ),
                      DropdownButton<String>(
                        focusColor: Colors.white,
                        value: _chosenValue,
                        style: TextStyle(color: Colors.white),
                        iconEnabledColor: Colors.black,
                        items: <String>[
                          '7 Days',
                          '15 Days',
                          '1 Month',
                          '2 Month',
                          '3 Month',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: TextStyle(
                                  color: Colors.black, fontSize: 47.sp),
                            ),
                          );
                        }).toList(),
                        hint: Text("Select Time Period", style: titlestyle),
                        onChanged: (value) {
                          setState(() {
                            _chosenValue = value;
                          });
                        },
                      ),
                      if (_chosenValue == null && error == true)
                        Text(
                          'Required',
                          style: TextStyle(color: Colors.red.shade700),
                        ),
                      SizedBox(
                        height: 100.h,
                      ),
                      Align(
                          alignment: Alignment.bottomCenter,
                          child: ElevatedButton(
                            child: Text("ADD OFFER"),
                            onPressed: () {
                              if (_formKey.currentState!.validate() &&
                                  _chosenValue != null) {
                                error = false;
                                OwnerOffers addoffer = OwnerOffers(
                                    title: _title.text,
                                    details: _details.text,
                                    timeCreated: DateTime.now(),
                                    timePeriod: _chosenValue ?? '');
                                offersBox.add(addoffer);
                                Navigator.pop(context);
                              } else {
                                setState(() {
                                  error = true;
                                });
                              }
                            },
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
