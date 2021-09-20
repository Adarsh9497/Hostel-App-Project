// To parse this JSON data, do
//
//     final userDb = userDbFromJson(jsonString);

import 'dart:convert';

//=---------------------------------------------------------------------------------------
//-------This is saveUser response json serialization
//---------------------------------------------------------------------------------------
UserDb userDbFromJson(String str) => UserDb.fromJson(json.decode(str));

String userDbToJson(UserDb data) => json.encode(data.toJson());

class UserDb {
  UserDb({
    required this.token,
    required this.user,
  });

  String token;
  User user;

  factory UserDb.fromJson(Map<String, dynamic> json) => UserDb(
        token: json["token"],
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.hostelresident,
    required this.bookmarks,
    required this.offers,
    required this.id,
    required this.mobileNumber,
    required this.name,
    required this.v,
  });

  List<dynamic> hostelresident;
  List<dynamic> bookmarks;
  List<dynamic> offers;
  String id;
  String mobileNumber;
  String name;
  int v;

  factory User.fromJson(Map<String, dynamic> json) => User(
        hostelresident:
            List<dynamic>.from(json["hostelresident"].map((x) => x)),
        bookmarks: List<dynamic>.from(json["bookmarks"].map((x) => x)),
        offers: List<dynamic>.from(json["offers"].map((x) => x)),
        id: json["_id"],
        mobileNumber: json["mobileNumber"],
        name: json["name"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "hostelresident": List<dynamic>.from(hostelresident.map((x) => x)),
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
        "offers": List<dynamic>.from(offers.map((x) => x)),
        "_id": id,
        "mobileNumber": mobileNumber,
        "name": name,
        "__v": v,
      };
}

//=---------------------------------------------------------------------------------------
//-------This is getUserByNumber response json serialization
//---------------------------------------------------------------------------------------
// To parse this JSON data, do
//
//     final userByNumber = userByNumberFromJson(jsonString);

UserByNumber userByNumberFromJson(String str) =>
    UserByNumber.fromJson(json.decode(str));

String userByNumberToJson(UserByNumber data) => json.encode(data.toJson());

class UserByNumber {
  UserByNumber({
    required this.token,
    required this.result,
  });

  String token;
  Result result;

  factory UserByNumber.fromJson(Map<String, dynamic> json) => UserByNumber(
        token: json["token"],
        result: Result.fromJson(json["result"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "result": result.toJson(),
      };
}

class Result {
  Result({
    this.email,
    required this.name,
    required this.isOwner,
    required this.hostelresident,
    required this.bookmarks,
    required this.offers,
    required this.id,
    required this.hostelId,
    required this.mobileNumber,
    required this.v,
  });

  dynamic email;
  String name;
  bool isOwner;
  List<dynamic> hostelresident;
  List<dynamic> bookmarks;
  List<dynamic> offers;
  String id;
  List<dynamic> hostelId;
  String mobileNumber;
  int v;

  factory Result.fromJson(Map<String, dynamic> json) => Result(
        email: json["email"] ?? '',
        name: json["name"],
        isOwner: json["isOwner"],
        hostelresident: json["hostelresident"] != null
            ? List<dynamic>.from(json["hostelresident"].map((x) => x))
            : [],
        bookmarks: json["bookmarks"] != null
            ? List<dynamic>.from(json["bookmarks"].map((x) => x))
            : [],
        offers: json["offers"] != null
            ? List<dynamic>.from(json["offers"].map((x) => x))
            : [],
        id: json["_id"],
        hostelId: json["hostelId"] != null
            ? List<dynamic>.from(json["hostelId"].map((x) => x))
            : [],
        mobileNumber: json["mobileNumber"],
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "email": email ?? null,
        "name": name,
        "isOwner": isOwner,
        "hostelresident": List<dynamic>.from(hostelresident.map((x) => x)),
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
        "offers": List<dynamic>.from(offers.map((x) => x)),
        "_id": id,
        "hostelId": List<dynamic>.from(hostelId.map((x) => x)),
        "mobileNumber": mobileNumber,
        "__v": v,
      };
}
