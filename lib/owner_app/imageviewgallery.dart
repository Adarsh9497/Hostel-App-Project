import 'package:flutter/material.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:photo_view/photo_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:io';
import 'owner_profileview_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageViewGallery extends StatelessWidget {
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    var imagelist = MySharedPref.getImages()!;
    return SafeArea(
      child: Container(
        child: Stack(
          children: [
            ScrollConfiguration(
              behavior: MyBehavior(),
              child: PageView.builder(
                  controller: _controller,
                  itemCount: (imagelist.length > 0) ? imagelist.length : 3,
                  itemBuilder: (BuildContext context, index) {
                    return Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: (imagelist.length > 0)
                            ? PhotoView(
                                imageProvider:
                                    FileImage(File(imagelist[index])))
                            : Center(
                                child: Text(
                                    "Something went wrong, couldn't load Image")),
                      ),
                    );
                  }),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: SmoothPageIndicator(
                  controller: _controller, // PageController
                  count: (imagelist.length > 0) ? imagelist.length : 3,
                  effect: WormEffect(
                      dotHeight: 10.0,
                      activeDotColor: Colors.blue,
                      dotWidth: 10.0), // your preferred effect
                  onDotClicked: (index) {
                    _controller.jumpToPage(index);
                  },
                ),
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: EdgeInsets.all(20.0),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
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
