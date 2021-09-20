// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiveoffers_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OwnerOffersAdapter extends TypeAdapter<OwnerOffers> {
  @override
  final int typeId = 0;

  @override
  OwnerOffers read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OwnerOffers(
      title: fields[0] as String,
      details: fields[1] as String,
      timeCreated: fields[3] as DateTime,
      timePeriod: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OwnerOffers obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.details)
      ..writeByte(2)
      ..write(obj.timePeriod)
      ..writeByte(3)
      ..write(obj.timeCreated);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OwnerOffersAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
