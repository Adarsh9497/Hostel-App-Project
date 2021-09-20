import 'package:hostel_app/models/hivedb.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/models/url.dart';
import 'package:hostel_app/models/userdatabase.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

var header = <String, String>{
  'Content-Type': 'application/json; charset=UTF-8',
};

class UserModel {
  Future<int> createUser(
      {required String name, required String mobilenumber}) async {
    try {
      var response = await http.post(Uri.parse(Url().saveUser),
          headers: header,
          body: jsonEncode({
            'mobileNumber': mobilenumber,
            'name': name,
          }));
      if (response.statusCode == 200) {
        final userDb = userDbFromJson(response.body);
        MySharedPref.setMobilenumber(userDb.user.mobileNumber);
        HiveVariablesDB.setUserName(userDb.user.name);
        MySharedPref.setUserID(userDb.user.id);
        return 200;
      }
      await MySharedPref.deleteAll();
      await HiveVariablesDB.deleteAll();
      return 424;
    } catch (e) {
      print(e);
      await MySharedPref.deleteAll();
      await HiveVariablesDB.deleteAll();
      return 424;
    }
  }

  Future<int> isMobileRegistered(
      {required String mobilenumber, bool checkDuplicate = false}) async {
    try {
      var response = await http.post(Uri.parse(Url().userByNumber),
          headers: header,
          body: jsonEncode({
            'mobileNumber': mobilenumber,
          }));
      print(response.statusCode);
      if (response.statusCode == 200) {
        if (response.body == 'not Found')
          return 0;
        else {
          if (checkDuplicate == true) return 1;

          final userbynumber = userByNumberFromJson(response.body);
          MySharedPref.setMobilenumber(userbynumber.result.mobileNumber);
          HiveVariablesDB.setMobilenumber(userbynumber.result.mobileNumber);
          HiveVariablesDB.setUserName(userbynumber.result.name);
          MySharedPref.setUserID(userbynumber.result.id);
          if (userbynumber.result.email != null) {
            HiveVariablesDB.setEmail(userbynumber.result.email);
          }
          MySharedPref.setOwner(userbynumber.result.isOwner);

          return 1;
        }
      }
      return -1;
    } catch (e) {
      print(e);
      return -1;
    }
  }

  Future<int> updateUserDetails(
      {required String id,
      String? name,
      String? mobile,
      String? email,
      bool? isOwner}) async {
    try {
      var response = await http.post(Uri.parse(Url().updateUser),
          headers: header,
          body: jsonEncode({
            '_id': id,
            if (mobile != null) 'mobileNumber': mobile,
            if (name != null) 'name': name,
            if (email != null) 'email': email,
            if (isOwner != null) 'isOwner': isOwner,
          }));
      print(response.body);
      var data = jsonDecode(response.body);
      if (data["nModified"] == 1)
        return response.statusCode;
      else
        return 424;
    } catch (e) {
      print(e);
      return 424;
    }
  }
}
