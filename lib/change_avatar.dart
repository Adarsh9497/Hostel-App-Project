import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/sharedpref.dart';

String imageAvators = 'images_avators/Asset ';

class ChangeAvatar extends StatefulWidget {
  const ChangeAvatar({Key? key}) : super(key: key);

  @override
  _ChangeAvatarState createState() => _ChangeAvatarState();
}

class _ChangeAvatarState extends State<ChangeAvatar> {
  late int selectedIndex;
  @override
  void initState() {
    super.initState();
    selectedIndex = MySharedPref.getAvatar();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Avatar',
          style: TextStyle(color: kLightBlackColor),
        ),
        backgroundColor: kBackgroundColor,
        leading: BackButton(
          color: kLightBlackColor,
        ),
      ),
      backgroundColor: kBackgroundColor,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 20.h),
        child: GridView.builder(
            itemCount: 10,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    MySharedPref.setAvatar(index);
                  });
                },
                child: Container(
                  decoration: (selectedIndex == index)
                      ? BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.blue, width: 2))
                      : null,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(5),
                  child: Tab(
                    icon: Image.asset(
                      imageAvators + '${index + 1}.png',
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}

// CircleAvatar(
// radius: 100.w,
// backgroundColor: Colors.transparent,
// child: Image.asset(
// imageAvators + '${index + 1}.png',
// )),
