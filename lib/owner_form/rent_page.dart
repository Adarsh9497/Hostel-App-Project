import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/owner_form/photos_page.dart';
import 'roomList_maker.dart';
import 'address_page.dart';
import 'widgets/custom_widgets.dart';
import 'data_provider.dart';
import 'package:provider/provider.dart';
import 'package:hostel_app/models/hiveRooms_model.dart';

class RentPage extends StatefulWidget {
  const RentPage({Key? key}) : super(key: key);
  static const String id = "rent_page";
  @override
  _RentPageState createState() => _RentPageState();
}

class _RentPageState extends State<RentPage> {
  final ScrollController _scrollController = ScrollController();
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: Scaffold(
          floatingActionButton: FloatingActionButton(
            tooltip: 'Add Room type',
            backgroundColor: Colors.blue,
            onPressed: () async {
              if (data.roomData.length < 5) {
                data.addRoom();
                await Future.delayed(Duration(milliseconds: 100));
                setState(() {
                  _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 700),
                      curve: Curves.fastOutSlowIn);
                });
                FocusScope.of(context).unfocus();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Rooms Limit reached"),
                ));
              }
            },
            child: Icon(Icons.add),
          ),
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
                                AddressPage(),
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
                              style:
                                  kTitleText.copyWith(color: kBackgroundColor),
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
                        bool error = false;
                        for (RoomData i in data.roomData) {
                          if (i.roomType == "") {
                            error = true;
                            break;
                          }

                          final number = RegExp(r'^[0-9]*$');
                          if (!number.hasMatch(i.rent) ||
                              !number.hasMatch(i.securityDeposit) ||
                              i.securityDeposit == "" ||
                              i.rent == "") {
                            error = true;
                          }
                        }

                        if (!error) {
                          data.printRoom();
                          data.showrtError(false);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  PhotosPage(),
                              transitionDuration: Duration(seconds: 0),
                            ),
                            //  (Route<dynamic> route) => false,
                          );
                        } else {
                          setState(() {
                            _scrollController.animateTo(
                                _scrollController.position.minScrollExtent,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.fastOutSlowIn);

                            if (error) {
                              data.showrtError(true);
                            }
                          });
                        }
                      },
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Next',
                              style:
                                  kTitleText.copyWith(color: kBackgroundColor),
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
                    AppbarBottom(text: 'Address'),
                    AppbarBottom(text: 'Rent', isUnderlined: true),
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
                      Column(
                        children: [
                          Padding(
                            padding:
                                EdgeInsets.fromLTRB(50.w, 60.h, 50.w, 50.h),
                            child: Text(
                              'Room Details',
                              style: kTitleText,
                            ),
                          ),
                          RoomsList(
                            data: data,
                          ),
                          SizedBox(height: 200.h),
                        ],
                        crossAxisAlignment: CrossAxisAlignment.start,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
