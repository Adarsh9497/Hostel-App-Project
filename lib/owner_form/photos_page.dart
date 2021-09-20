import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hostel_app/constants.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/owner_app/owner_navigationbar.dart';
import 'package:hostel_app/owner_form/data_provider.dart';
import 'package:hostel_app/owner_form/rent_page.dart';
import 'package:provider/provider.dart';
import 'widgets/custom_widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

List<File?> imagefile = [null, null, null, null, null, null];
File file = File("hostelimage.png");

class PhotosPage extends StatefulWidget {
  static const String id = "photos_page";

  @override
  _PhotosPageState createState() => _PhotosPageState();
}

class _PhotosPageState extends State<PhotosPage> {
  bool showerror = false;
  @override
  Widget build(BuildContext context) {
    var data = Provider.of<DataProvider>(context);
    return WillPopScope(
      onWillPop: () => onWillPop(context),
      child: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
            print(imagefile.length);
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
                          data.addImages(imagefile);
                          Navigator.pushReplacement(
                            context,
                            PageRouteBuilder(
                              pageBuilder: (context, animation1, animation2) =>
                                  RentPage(),
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
                          if (imagefile.length >= 2) {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 20),
                                    title: Text(
                                      'Submit my form',
                                      style: kTitleText.copyWith(
                                          fontWeight: FontWeight.w500),
                                    ),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            data.addImages(imagefile);
                                            MySharedPref.setOwner(true);
                                            await data.addDataToLocal();
                                            Navigator.pushAndRemoveUntil(
                                              context,
                                              PageRouteBuilder(
                                                pageBuilder: (context,
                                                        animation1,
                                                        animation2) =>
                                                    OwnerNavigator(),
                                                transitionDuration:
                                                    Duration(seconds: 0),
                                              ),
                                              (Route<dynamic> route) => false,
                                            );
                                          },
                                          child: Text(
                                            'OK',
                                            style: kTitleText.copyWith(
                                                fontWeight: FontWeight.w500,
                                                color: Colors.blue),
                                          ))
                                    ],
                                  );
                                });
                          } else {
                            showerror = true;
                            setState(() {});
                          }
                        },
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Submit',
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
                      AppbarBottom(text: 'Owner'),
                      AppbarBottom(text: 'Address'),
                      AppbarBottom(text: 'Rent'),
                      AppbarBottom(text: 'Photos', isUnderlined: true),
                    ],
                  ),
                ),
                preferredSize: Size.fromHeight(40),
              ),
            ),
            body: SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.fromLTRB(50.w, 60.h, 50.w, 0),
                alignment: Alignment.center,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Upload Photos',
                      style: kTitleText,
                    ),
                    SizedBox(
                      height: 150.h,
                    ),
                    Center(
                      child: Wrap(
                        children: [
                          ImageBox(
                            index: 5,
                          ),
                          ImageBox(
                            index: 4,
                          ),
                          ImageBox(
                            index: 3,
                          ),
                          ImageBox(
                            index: 2,
                          ),
                          ImageBox(
                            index: 1,
                          ),
                          ImageBox(
                            index: 0,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.w),
                      child: (showerror)
                          ? ShakeWidget(
                              key: Key(Random().nextInt(100).toString()),
                              child: Text(
                                  'To proceed further you must provide a minimum of two images.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 44.sp, color: Colors.red[900])),
                            )
                          : Text(
                              'To proceed further you must provide a minimum of two images.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 44.sp, color: Colors.blue)),
                    ),
                    SizedBox(
                      height: 200.h,
                    ),
                    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: kLightBlackColor,
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Text(
                            'Image size should be less than 5 MB',
                            style: kSubTitleText,
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageBox extends StatefulWidget {
  ImageBox({required this.index});
  int index;
  @override
  _ImageBoxState createState() => _ImageBoxState();
}

class _ImageBoxState extends State<ImageBox> {
  File? imageFile;

  _getFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    File? temp = imageFile;
    if (pickedFile != null) {
      imagefile.remove(temp);
      imageFile = File(pickedFile.path);
      imagefile.add(imageFile);
      setState(() {});
    }
  }

  _getFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    File? temp = imageFile;
    if (pickedFile != null) {
      imagefile.remove(temp);
      imageFile = File(pickedFile.path);
      imagefile.add(imageFile);
      setState(() {});
    }
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _getFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text('Camera'),
                    onTap: () {
                      _getFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  @override
  void initState() {
    super.initState();
    imageFile = imagefile[widget.index];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      child: DottedBorder(
        dashPattern: [3],
        borderType: BorderType.RRect,
        radius: Radius.circular(4),
        padding: EdgeInsets.all(6),
        color: Colors.blue.shade500,
        child: Material(
          child: InkWell(
            onTap: () {
              _showPicker(context);
              setState(() {});
            },
            child: Container(
              height: 200.w,
              width: 200.w,
              child: (imageFile == null)
                  ? Center(
                      child: Icon(Icons.add),
                    )
                  : Image.file(imageFile ?? file),
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class ShakeWidget extends StatelessWidget {
  final Duration duration;
  final double deltaX;
  final Widget child;
  final Curve curve;

  const ShakeWidget({
    Key? key,
    this.duration = const Duration(milliseconds: 500),
    this.deltaX = 20,
    this.curve = Curves.bounceOut,
    required this.child,
  }) : super(key: key);

  /// convert 0-1 to 0-1-0
  double shake(double animation) =>
      2 * (0.5 - (0.5 - curve.transform(animation)).abs());

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: key,
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration,
      builder: (context, animation, child) => Transform.translate(
        offset: Offset(deltaX * shake(animation), 0),
        child: child,
      ),
      child: child,
    );
  }
}
