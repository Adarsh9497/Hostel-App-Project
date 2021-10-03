import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hostel_app/aminities.dart';
import 'package:hostel_app/main.dart';
import 'package:hostel_app/models/hivedb.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hostel_app/models/sharedpref.dart';
import 'package:hostel_app/models/hiveRooms_model.dart';

class DataProvider extends ChangeNotifier {
  String mobileNumber = "";

  //Hostel Data .............................
  bool hostelDataUpdated = false;
  String availableBeds = "";
  String hostelName = ""; //TODO change name to ""
  String numberBeds = "";
  bool hostel = false;
  bool boy = false;
  bool girl = false;
  bool food = false;
  String hostelDetails = "";
  List<bool> foodtimes = [false, false, false];
  bool landLoard = false; //true means landlord false means caretaker
  bool managerStaysAtHostel = false;
  List<String> rulesAnswers = ['#', '#', '#', '#', '#'];
  List<String> commonFacilities = [];

  void deleteProviderData({bool deletelocation = true}) async {
    if (deletelocation) await HiveVariablesDB.setIsLocationGiven('false');

    mobileNumber = "";
    hostelDataUpdated = false;
    availableBeds = "";
    hostelName = "";
    numberBeds = "";
    hostel = false;
    boy = false;
    girl = false;
    food = false;
    hostelDetails = "";
    foodtimes = [false, false, false];
    landLoard = false;
    managerStaysAtHostel = false;
    rulesAnswers = ['#', '#', '#', '#', '#'];
    commonFacilities = [];

//owner data..........................
    ownerDataUpdated = false;
    ownerName = "";
    updatedMobileNumber = "";
    whatsappNumber = "";
    email = "";

    //Address Data...............................
    addressDataUpdated = false;
    state = 'Madhya Pradesh';
    city = "";
    postalCode = "";
    address = "";
    mapURL = '';
    areaName = "";

    //room data.........
    roomData = [RoomData(facilities: [])];
    showRTError = false;

    //image data
    imagelist = [];
  }

  void addCommonFacility({required String s}) {
    for (var i in commonFacilities) {
      if (i == s) return;
    }
    commonFacilities.add(s);
    notifyListeners();
  }

  bool searchCommonFacility(String f) {
    int c = commonFacilities.indexOf(f);
    if (c == -1)
      return false;
    else
      return true;
  }

  void deleteCommonFacility({required String s}) {
    commonFacilities.remove(s);
    notifyListeners();
  }

  //Owner Data........................
  bool ownerDataUpdated = false;
  String ownerName = ""; //TODO change name to ""
  String updatedMobileNumber = "";
  String whatsappNumber = "";
  String email = "";

  //Address Data...............................
  bool addressDataUpdated = false;
  String state = 'Madhya Pradesh';
  String city = "";
  String postalCode = "";
  String address = "";
  String mapURL = '';
  String areaName = "";

  //Rooms Data Rent Data..........................
  List<RoomData> roomData = [RoomData(facilities: [])];
  bool showRTError = false;

  void showrtError(bool s) {
    showRTError = s;
    notifyListeners();
  }

  bool getshowrtError() {
    return showRTError;
  }

  printRoom() {
    for (RoomData i in roomData) {
      i.printdata();
    }
  }

  void addFacility({required String s, required int index}) {
    for (String i in roomData[index].facilities) {
      if (s == i) return;
    }
    roomData[index].facilities.add(s);
    notifyListeners();
  }

  bool searchRoomFacility(String s, int index) {
    int c = roomData[index].facilities.indexOf(s);
    if (c == -1)
      return false;
    else
      return true;
  }

  void deleteFacility({required String s, required int index}) {
    roomData[index].facilities.remove(s);
    notifyListeners();
  }

  void addRoom() {
    roomData.add(RoomData(facilities: []));
    notifyListeners();
  }

  void updateRoomRent({required int index, required String rent}) {
    roomData[index].rent = rent;
    notifyListeners();
  }

  void updateRoomType({required int index, required String roomtype}) {
    roomData[index].roomType = roomtype;
    notifyListeners();
  }

  void updateSecurityDeposit({required int index, required String sec}) {
    roomData[index].securityDeposit = sec;
    notifyListeners();
  }

  void deleteRoom(RoomData roomdata) {
    roomData.remove(roomdata);
    notifyListeners();
  }

  //Image Data.....................................
  List<File?> imagelist = [];

  void addImages(List<File?> list) {
    imagelist = list.reversed.toList();
  }

  // Functions........................Functions.........................Functions....................

  void updateHostelData({
    required String hostelName,
    required String numberBeds,
    required bool hostel,
    required bool boy,
    required bool girl,
    required bool food,
    required bool landLoard, //true means landlord false means caretaker
    required bool managerStaysAtHostel,
    required List<String> rulesAnswers,
    required List<bool> foodtimes,
    required String hosteldetails,
  }) {
    this.hostelName = hostelName;
    this.numberBeds = numberBeds;
    this.boy = boy;
    this.girl = girl;
    this.hostel = hostel;
    this.food = food;
    this.foodtimes = foodtimes;
    this.landLoard = landLoard;
    this.managerStaysAtHostel = managerStaysAtHostel;
    this.rulesAnswers = rulesAnswers;
    this.hostelDetails = hosteldetails;
    hostelDataUpdated = true;

    //printHostelData();

    notifyListeners();
  }

  void printHostelData() {
    print(hostelName);
    print(numberBeds);
    print('boy $boy and girl $girl');
    print('hostelDetails $hostelDetails');
    print('hostel $hostel');
    print('food available $food');
    print('food time: $foodtimes');
    print('manager landloard $landLoard');
    print('Manger stays at hostel $managerStaysAtHostel');
    print(rulesAnswers);
  }

  void updataMobileNumber(String mobileNumber) {
    this.mobileNumber = mobileNumber;
  }

  void updataOwnerData({
    required String ownerName,
    required String updatedMobileNumber,
    required String whatsappNumber,
    required String email,
  }) {
    this.ownerName = ownerName;
    this.updatedMobileNumber = updatedMobileNumber;
    if (whatsappNumber == "") {
      this.whatsappNumber = updatedMobileNumber;
    } else
      this.whatsappNumber = whatsappNumber;

    this.email = email;

    ownerDataUpdated = true;

    //printOwnerData();
    notifyListeners();
  }

  void printOwnerData() {
    print(ownerName);
    print('owner mobile number $updatedMobileNumber');
    print('owner whatsapp number $whatsappNumber');
    print('email address $email');
  }

  void updateAddressData({
    required String state,
    required String city,
    required String postalCode,
    required String address,
    required String areaName,
    required String mapurl,
  }) {
    this.state = state;
    this.city = city;
    this.postalCode = postalCode;
    this.address = address;
    this.areaName = areaName;
    this.mapURL = mapurl;
    addressDataUpdated = true;

    //printAddressData();
    notifyListeners();
  }

  void printAddressData() {
    print('state $state');
    print('city $city');
    print('postal $postalCode');
    print('address $address');
    print('area $areaName');
  }

  Future<void> addDataToLocal() async {
    addHostelDetails();
    addOwnerDetails();
    addAddressDetails();
    await MySharedPref.setAvailableBeds('0');
    int time = DateTime.now().millisecondsSinceEpoch;
    await MySharedPref.setTimeCreated(time);

    await MySharedPref.setImages(imagelist);

    addRoomsDetails();
  }

  void addHostelDetails() async {
    String HostelName = (hostelName == ""
        ? '${hostel ? 'Hostel' : 'PG'} #${DateTime.now().day}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().millisecond}'
        : hostelName);
    await MySharedPref.setHostelName(HostelName);
    await MySharedPref.setNoOfBeds(numberBeds);
    await MySharedPref.setPropertyTypeIsHostel(hostel);
    await MySharedPref.setHostelGender((boy && girl)
        ? 'both'
        : (boy)
            ? 'boy'
            : 'girl');
    await MySharedPref.setFoodAvailable(food);
    List<String> FoodTimes = [
      if (foodtimes[0]) 'Breakfast',
      if (foodtimes[1]) 'Lunch',
      if (foodtimes[2]) 'Dinner',
    ];
    await MySharedPref.setFoodTimes(FoodTimes);
    await MySharedPref.setPropertyManagedByLandlord(landLoard);
    await MySharedPref.setManagerStaysAtHostel(managerStaysAtHostel);
    await MySharedPref.setAboutHostel(hostelDetails);
    await MySharedPref.setHostelRules(rulesAnswers);

    List<int> amenities = [];
    for (String i in commonFacilities) {
      amenities.add(Amenities().facilities.indexOf(i));
    }
    List<String> strList = amenities.map((i) => i.toString()).toList();
    await MySharedPref.setCommonFacilities(strList);
  }

  void addOwnerDetails() async {
    await HiveVariablesDB.setOwnerName(ownerName);
    await HiveVariablesDB.setMobilenumber(updatedMobileNumber);
    await MySharedPref.setMobilenumber(updatedMobileNumber);
    await MySharedPref.setWhatsappMobile(whatsappNumber);
    if (email != "") await HiveVariablesDB.setEmail(email);
  }

  void addAddressDetails() async {
    await MySharedPref.setStateHostel(state);
    await MySharedPref.setCity(city);
    await MySharedPref.setPostalCode(postalCode);
    await MySharedPref.setAddress(address);
    await MySharedPref.setAreaName(areaName);
    await MySharedPref.setGoogleMapURL(mapURL);
  }

  void addRoomsDetails() async {
    Box<RoomData> roomsBox = Hive.box<RoomData>(roomsbox);
    for (RoomData i in roomData) {
      roomsBox.add(i);
    }
  }
}

// class RoomData {
//   String roomType;
//   String rent;
//   String securityDeposit;
//   List<String> facilities;
//   RoomData(
//       {this.roomType = "",
//       this.rent = "",
//       this.securityDeposit = "",
//       required this.facilities});
//
//   void printdata() {
//     print(roomType);
//     print(rent);
//     print(securityDeposit);
//     print(facilities);
//   }
// }
