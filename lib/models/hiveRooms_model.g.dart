// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveRooms_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RoomDataAdapter extends TypeAdapter<RoomData> {
  @override
  final int typeId = 1;

  @override
  RoomData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RoomData(
      roomType: fields[0] as String,
      rent: fields[1] as String,
      securityDeposit: fields[2] as String,
      facilities: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, RoomData obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.roomType)
      ..writeByte(1)
      ..write(obj.rent)
      ..writeByte(2)
      ..write(obj.securityDeposit)
      ..writeByte(3)
      ..write(obj.facilities);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RoomDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
