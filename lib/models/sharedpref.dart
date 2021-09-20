import 'dart:io';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySharedPref {
  static late SharedPreferences _preferences;
  static const _keyMobilenumber = "mobilenumber";
  //static const _keyEmail = "emailaddress";
  static const _keyIsOwner = "isowner";
  //static const _keyUserName = "username";
  //static const _keyOwnerName = "ownername";
  static const _keyHostelName = "hostelname";
  static const _keyBedsNumber = "bedsnumber";
  static const _keyPropertyIsHostel = "ishostel";
  static const _keyHostelGender = "hostelisfor";
  static const _keyFoodAvailable = "foodavailable";
  static const _keyFoodTimes = "foodtimes";
  static const _keyManagedBy = "managedby";
  static const _keyStaysAtHostel = "staysathostel";
  static const _keyCommonFacilites = "commonfacilites";
  static const _keyAboutHostel = "aboutHostel";
  static const _keyHostelRules = "hostelrules";
  static const _keyWhatsappMobile = "whatsappmobile";
  static const _keyState = "state";
  static const _keyCity = "city";
  static const _keyPostalCode = "postalcode";
  static const _keyAddress = "address";
  static const _keyAreaName = "areaname";
  static const _keyAvailableBeds = "availablebeds";
  static const _keyTimeCreated = "hosteltimecreated";
  static const _keyLatitude = 'hostellatitude';
  static const _keyLongitude = 'hostellongitude';
  static const _keyMapURL = 'ownermapurl';
  static const _keyAvatar = 'selectedavatar';
  static const _keyAskToLogin = 'asktologin';
  static const _keyUserID = 'userid';
  static const _keyOwnerID = 'ownerid';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future deleteAll() async {
    await _preferences.clear();
  }

  static Future setUserID(String id) async =>
      await _preferences.setString(_keyUserID, id);

  static String? getUserID() => _preferences.getString(_keyUserID);

  static Future setOwnerID(String id) async =>
      await _preferences.setString(_keyOwnerID, id);

  static String? getOwnerID() => _preferences.getString(_keyOwnerID);

  static Future setMobilenumber(String mn) async =>
      await _preferences.setString(_keyMobilenumber, mn);

  static String? getMobilenumber() => _preferences.getString(_keyMobilenumber);
  //
  // static Future setEmail(String mn) async =>
  //     await _preferences.setString(_keyEmail, mn);
  //
  // static String? getEmail() => _preferences.getString(_keyEmail);

  static Future setOwner(bool ans) async =>
      await _preferences.setBool(_keyIsOwner, ans);

  static bool? IsOwner() => _preferences.getBool(_keyIsOwner);

  // static Future setUserName(String name) async =>
  //     await _preferences.setString(_keyUserName, name);
  //
  // static String? getUserName() => _preferences.getString(_keyUserName);
  //
  // static Future setOwnerName(String name) async =>
  //     await _preferences.setString(_keyOwnerName, name);
  //
  // static String? getOwnerName() => _preferences.getString(_keyOwnerName);

  static Future setHostelName(String name) async =>
      await _preferences.setString(_keyHostelName, name);

  static String? getHostelName() => _preferences.getString(_keyHostelName);

  static Future setNoOfBeds(String name) async =>
      await _preferences.setString(_keyBedsNumber, name);

  static String? getNoOfBeds() => _preferences.getString(_keyBedsNumber);

  static Future setPropertyTypeIsHostel(bool ans) async =>
      await _preferences.setBool(_keyPropertyIsHostel, ans);

  static String? getPropertyType() {
    bool? type = _preferences.getBool(_keyPropertyIsHostel);
    if (type == true) //i.e. property is Hostel
      return 'Hostel';

    if (type == false) //i.e. property is PG
      return 'PG';

    return null;
  }

  static Future setHostelGender(String ans) async =>
      await _preferences.setString(_keyHostelGender, ans);

  static String? getHostelGender() => _preferences.getString(_keyHostelGender);

  static Future setFoodAvailable(bool ans) async =>
      await _preferences.setBool(_keyFoodAvailable, ans);

  static bool? getFoodAvailable() => _preferences.getBool(_keyFoodAvailable);

  static Future setFoodTimes(List<String> ans) async =>
      await _preferences.setStringList(_keyFoodTimes, ans);

  static List<String>? getFoodTimes() =>
      _preferences.getStringList(_keyFoodTimes);

  static Future setPropertyManagedByLandlord(bool ans) async =>
      await _preferences.setBool(_keyManagedBy, ans);

  static String? getPropertyManagedBy() {
    bool? type = _preferences.getBool(_keyManagedBy);
    if (type == true) //i.e. property is Hostel
      return 'Landlord';

    if (type == false) //i.e. property is PG
      return 'Caretaker';

    return null;
  }

  static Future setManagerStaysAtHostel(bool ans) async =>
      await _preferences.setBool(_keyStaysAtHostel, ans);

  static bool? getManagerStaysAtHostel() =>
      _preferences.getBool(_keyStaysAtHostel);

  static Future setCommonFacilities(List<String> ans) async =>
      await _preferences.setStringList(_keyCommonFacilites, ans);

  static List<int>? getCommonFacilities() {
    List<String>? savedStrList =
        _preferences.getStringList(_keyCommonFacilites);
    List<int>? commonFaci = savedStrList!.map((i) => int.parse(i)).toList();
    return commonFaci;
  }

  static Future setAboutHostel(String ans) async =>
      await _preferences.setString(_keyAboutHostel, ans);

  static String? getAboutHostel() => _preferences.getString(_keyAboutHostel);

  static Future setHostelRules(List<String> ans) async =>
      await _preferences.setStringList(_keyHostelRules, ans);

  static List<String>? getHostelRules() =>
      _preferences.getStringList(_keyHostelRules);

  static Future setWhatsappMobile(String ans) async =>
      await _preferences.setString(_keyWhatsappMobile, ans);

  static String? getWhatsappMobile() =>
      _preferences.getString(_keyWhatsappMobile);

  static Future setStateHostel(String ans) async =>
      await _preferences.setString(_keyState, ans);

  static String? getState() => _preferences.getString(_keyState);

  static Future setCity(String ans) async =>
      await _preferences.setString(_keyCity, ans);

  static String? getCity() => _preferences.getString(_keyCity);

  static Future setAddress(String ans) async =>
      await _preferences.setString(_keyAddress, ans);

  static String? getAddress() => _preferences.getString(_keyAddress);

  static Future setPostalCode(String ans) async =>
      await _preferences.setString(_keyPostalCode, ans);

  static String? getPostalCode() => _preferences.getString(_keyPostalCode);

  static Future setAreaName(String ans) async =>
      await _preferences.setString(_keyAreaName, ans);

  static String? getAreaName() => _preferences.getString(_keyAreaName);

  static Future setAvailableBeds(String ans) async =>
      await _preferences.setString(_keyAvailableBeds, ans);

  static String? getAvailableBeds() =>
      _preferences.getString(_keyAvailableBeds);

  static Future setTimeCreated(int ans) async =>
      await _preferences.setInt(_keyTimeCreated, ans);

  static int getTimeCreated() {
    int timestamp = _preferences.getInt(_keyTimeCreated) ??
        DateTime.now().millisecondsSinceEpoch;
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp);

    return DateTime.now().difference(dateTime).inHours;
  }

  static Future setImages(List<File?> files) async {
    Directory document = await getApplicationDocumentsDirectory();
    final String path = document.path;
    List<String> s = [];
    int j = 0;
    for (int i = 0; i < files.length; i++) {
      if (files[i] != null) {
        File newImage = await files[i]!.copy('$path/image$j.png');
        s.add(newImage.path);
        j++;
      }
    }

    _preferences.setStringList('ImagesKey', s);
  }

  static List<String>? getImages() => _preferences.getStringList('ImagesKey');

  static Future setLatitude(double ans) async =>
      await _preferences.setDouble(_keyLatitude, ans);

  static Future setLongitude(double ans) async =>
      await _preferences.setDouble(_keyLongitude, ans);

  static LatLng? getLocation() {
    LatLng location = LatLng(_preferences.getDouble(_keyLatitude) ?? 23.259933,
        _preferences.getDouble(_keyLongitude) ?? 77.412613);
    return location;
  }

  static Future setGoogleMapURL(String url) async =>
      await _preferences.setString(_keyMapURL, url);

  static String? getGoogleMapURL() => _preferences.getString(_keyMapURL);

  static Future setAvatar(int index) async =>
      await _preferences.setInt(_keyAvatar, index);

  static int getAvatar() => _preferences.getInt(_keyAvatar) ?? 1;

  static Future setAskToLogin(bool ans) async =>
      await _preferences.setBool(_keyAskToLogin, ans);

  static bool getAskToLogin() => _preferences.getBool(_keyAskToLogin) ?? true;
}
