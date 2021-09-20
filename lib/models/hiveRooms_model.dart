import 'package:hive/hive.dart';

part 'hiveRooms_model.g.dart';

@HiveType(typeId: 1)
class RoomData {
  @HiveField(0)
  String roomType;

  @HiveField(1)
  String rent;

  @HiveField(2)
  String securityDeposit;

  @HiveField(3)
  List<String> facilities;
  RoomData(
      {this.roomType = "",
      this.rent = "",
      this.securityDeposit = "",
      required this.facilities});

  void printdata() {
    print(roomType);
    print(rent);
    print(securityDeposit);
    print(facilities);
  }
}
