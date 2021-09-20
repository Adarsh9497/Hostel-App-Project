import 'package:hive/hive.dart';
import 'package:hostel_app/main.dart';
import 'package:hostel_app/models/hiveoffers_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class HiveVariablesDB {
  static late Box<String> variablesDB;
  static const _variableBox = 'varialbes';
  static const keyMobilenumber = "mobilenumber";
  static const keyEmail = "emailaddress";
  static const keyUserName = "username";
  static const keyOwnerName = "ownername";
  static const keyHostelName = "hostelname";
  static const keyLocationGiven = "loationgiven";

  static Future init() async {
    Directory document = await getApplicationDocumentsDirectory();
    Hive.init(document.path);
    await Hive.openBox<String>(_variableBox);
    variablesDB = Hive.box<String>(_variableBox);
  }

  // static Future openBox() async {
  //   await Hive.openLazyBox<String>(_variableBox);
  //   await Hive.openLazyBox<OwnerOffers>(offersbox);
  //   variablesDB = Hive.box<String>(_variableBox);
  // }

  static Future deleteAll() async {
    await variablesDB.clear();
  }

  static Future setMobilenumber(String mn) async =>
      await variablesDB.put(keyMobilenumber, mn);

  static String? getMobilenumber() => variablesDB.get(keyMobilenumber);

  static Future setEmail(String mn) async =>
      await variablesDB.put(keyEmail, mn);

  static String? getEmail() => variablesDB.get(keyEmail);

  static Future setUserName(String name) async =>
      await variablesDB.put(keyUserName, name);

  static String? getUserName() => variablesDB.get(keyUserName);

  static Future setOwnerName(String name) async =>
      await variablesDB.put(keyOwnerName, name);

  static String? getOwnerName() => variablesDB.get(keyOwnerName);

  static Future setIsLocationGiven(String ans) async =>
      await variablesDB.put(keyLocationGiven, ans);

  static String? getLocation() => variablesDB.get(keyLocationGiven);
}
