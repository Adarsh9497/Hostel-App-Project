import 'package:http/http.dart';
import 'dart:convert';

var apiKey = "8a366a3c-cb9b-11eb-8089-0200cd936042";
var url = "https://2factor.in/API/V1/" + apiKey + "/SMS/";

class SendOTP {
  dynamic data;
  Future<dynamic> sendotp(String mobilenumber) async {
    try {
      Response response =
          await get(Uri.parse(url + mobilenumber + "/AUTOGEN/" + "ABCDEF"));
      data = await jsonDecode(response.body);
      print(data);
      print(data["Status"]);
      return data;
    } catch (e) {
      print(e);
    }
    return data;
  }

  Future<dynamic> verifyotp(String id, String otp) async {
    try {
      Response response =
          await get(Uri.parse(url + "VERIFY/" + id + "/" + otp));
      data = await jsonDecode(response.body);
      print(data);
      print(data["Status"]);
      return data;
    } catch (e) {
      print(e);
    }
    return data;
  }
}
