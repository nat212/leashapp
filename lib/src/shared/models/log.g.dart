// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'log.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LogAdapter extends TypeAdapter<Log> {
  @override
  final int typeId = 1;

  @override
  Log read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Log(
      label: fields[1] as String,
      amount: fields[2] as double,
    );
  }

  @override
  void write(BinaryWriter writer, Log obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.created)
      ..writeByte(1)
      ..write(obj.label)
      ..writeByte(2)
      ..write(obj.amount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
