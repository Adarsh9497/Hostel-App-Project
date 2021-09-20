import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/constants.dart';
import 'package:hostel_app/models/hiveRooms_model.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/hiveoffers_model.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/owner_app/owner_navigationbar.dart';
import 'package:hostel_app/owner_form/data_provider.dart';
import 'package:hostel_app/pages/asktologin.dart';
import 'package:hostel_app/pages/username.dart';
import 'package:hostel_app/user_app/user_navigator.dart';
import 'package:provider/provider.dart';

const String offersbox = "owneroffersbox";
const String roomsbox = 'ownerRoomsbox';
dynamic isowner;
dynamic asktologin;
dynamic mobilenumber;
dynamic name;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  //
  //
  await HiveVariablesDB.init();
  Hive.registerAdapter(OwnerOffersAdapter());
  await Hive.openBox<OwnerOffers>(offersbox);
  Hive.registerAdapter(RoomDataAdapter());
  await Hive.openBox<RoomData>(roomsbox);
  //
  //
  await MySharedPref.init();
  isowner = MySharedPref.IsOwner();
  name = HiveVariablesDB.getUserName();
  mobilenumber = MySharedPref.getMobilenumber();
  asktologin = MySharedPref.getAskToLogin();
  //
  //
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080, 1920),
      builder: () => ChangeNotifierProvider(
        create: (_) => DataProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light().copyWith(
            backgroundColor: kBackgroundColor,
          ),
          title: 'Hostel App',
          home: goToPage(),
        ),
      ),
    );
  }
}

Widget goToPage() {
  if (isowner == true) return OwnerNavigator();

  if (mobilenumber != null && name == null) return UserName();

  if (asktologin == true) return AskToLogin();

  return UserNavigator();
}
