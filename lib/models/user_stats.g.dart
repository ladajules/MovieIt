// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatsAdapter extends TypeAdapter<UserStats> {
  @override
  final int typeId = 2;

  @override
  UserStats read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStats(
      nightsPlanned: fields[0] as int,
      totalRuntimeMinutes: fields[1] as int,
      totalRatingSum: fields[2] as double,
      totalMoviesRated: fields[3] as int,
      genreCounts: (fields[4] as Map?)?.cast<String, int>(),
    );
  }

  @override
  void write(BinaryWriter writer, UserStats obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.nightsPlanned)
      ..writeByte(1)
      ..write(obj.totalRuntimeMinutes)
      ..writeByte(2)
      ..write(obj.totalRatingSum)
      ..writeByte(3)
      ..write(obj.totalMoviesRated)
      ..writeByte(4)
      ..write(obj.genreCounts);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
