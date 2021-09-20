import 'dart:async';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:geocoding/geocoding.dart';

class LocateMap extends StatefulWidget {
  @override
  _LocateMapState createState() => _LocateMapState();
}

class _LocateMapState extends State<LocateMap> {
  //Set<Marker> _markers = {};
  String? address;
  LatLng finalPostion = LatLng(23.259933, 77.412613);
  final List<Marker> _markers = [];
  LatLng currentPostion =
      MySharedPref.getLocation() ?? LatLng(23.259933, 77.412613);
  CameraPosition? findthisAddress;
  Completer<GoogleMapController> _controller = Completer();

  void _getAddress(LatLng position) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placeMark = placemarks[0];
    String? name = placeMark.name;
    String? subLocality = placeMark.subLocality;
    String? locality = placeMark.locality;
    String? administrativeArea = placeMark.administrativeArea;
    String addres =
        "${name}, ${subLocality}, ${locality}, ${administrativeArea}";

    address = addres;
  }

  @override
  Widget build(BuildContext context) {
    Future _getUserLocation() async {
      var position = await GeolocatorPlatform.instance
          .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      currentPostion = LatLng(position.latitude, position.longitude);
    }

    return SafeArea(
      child: Scaffold(
          bottomNavigationBar: Material(
            elevation: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 40.w, vertical: 30.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Select Location',
                    style: kTitleText,
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () {
                      _getAddress(finalPostion);
                      setState(() {});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Text(
                              'Your Location',
                              style: kSubTitleText.copyWith(
                                  color: Colors.grey.shade700),
                            ),
                            Text(
                              '  - Tap to get Address',
                              style: kSubTitleText.copyWith(color: Colors.blue),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              color: Colors.blue,
                              size: 50.sp,
                            ),
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                              child: Text(
                                address ?? '....',
                                style: TextStyle(
                                    fontSize: 52.sp,
                                    fontWeight: FontWeight.w600,
                                    color: (address == null)
                                        ? Colors.blue
                                        : kLightBlackColor),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                  ),
                  Divider(),
                  GestureDetector(
                    onTap: () async {
                      await MySharedPref.setLatitude(finalPostion.latitude);
                      await MySharedPref.setLongitude(finalPostion.longitude);
                      await HiveVariablesDB.setIsLocationGiven('true');
                      Navigator.pop(context);
                    },
                    child: Container(
                      margin: EdgeInsets.all(8),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      width: double.infinity,
                      padding: EdgeInsets.symmetric(
                          horizontal: 50.w, vertical: 30.h),
                      child: Text(
                        'Confirm Location',
                        style: kTitleText.copyWith(color: Colors.white),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await _getUserLocation();
              setState(() async {
                final GoogleMapController controller = await _controller.future;
                controller.animateCamera(
                  CameraUpdate.newCameraPosition(
                    CameraPosition(target: currentPostion, zoom: 15),
                  ),
                );
              });
            },
            child: Icon(Icons.my_location),
          ),
          body: Stack(
            alignment: Alignment.center,
            children: [
              GoogleMap(
                zoomControlsEnabled: false,
                initialCameraPosition:
                    CameraPosition(target: currentPostion, zoom: 18),
                markers: _markers.toSet(),
                onMapCreated: (controller) async {
                  setState(() {
                    _controller.complete(controller);
                    final marker = Marker(
                      visible: false,
                      markerId: MarkerId('0'),
                      position: currentPostion,
                    );
                    _markers.add(marker);
                  });
                },
                onCameraMove: (position) {
                  setState(() {
                    _markers.first =
                        _markers.first.copyWith(positionParam: position.target);
                    finalPostion = position.target;
                  });
                },
              ),
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    )),
              ),
              Image.asset(
                'images/pin.png',
                scale: 10,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  return Transform.translate(
                    offset: Offset(8, -37),
                    child: child,
                  );
                },
              )
            ],
          )),
    );
  }
}

// GoogleMap(
// zoomControlsEnabled: false,
// onMapCreated: (GoogleMapController controller) {
// setState(() {
// _controller.complete(controller);
// _markers.add(Marker(
// markerId: MarkerId('id-1'),
// position: currentPostion,
// ));
// });
// },
// mapType: MapType.normal,
// markers: _markers,
// onTap: (cor) {
// setState(() {
// _markers.add(Marker(
// markerId: MarkerId('id-1'),
// position: LatLng(cor.latitude, cor.longitude),
// ));
// });
// },
// initialCameraPosition: CameraPosition(target: currentPostion, zoom: 12),
// ),
