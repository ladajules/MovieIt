// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scheduled_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ScheduledEventAdapter extends TypeAdapter<ScheduledEvent> {
  @override
  final int typeId = 3;

  @override
  ScheduledEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ScheduledEvent(
      id: fields[0] as String,
      movieId: fields[1] as String,
      movieTitle: fields[2] as String,
      posterUrl: fields[3] as String,
      scheduledDate: fields[4] as DateTime,
      platform: fields[5] as String,
      runtime: fields[6] as int,
      genres: (fields[7] as List).cast<String>(),
      isReviewed: fields[8] as bool,
      rating: fields[9] as double?,
      note: fields[10] as String?,
      isWatched: fields[11] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, ScheduledEvent obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.movieId)
      ..writeByte(2)
      ..write(obj.movieTitle)
      ..writeByte(3)
      ..write(obj.posterUrl)
      ..writeByte(4)
      ..write(obj.scheduledDate)
      ..writeByte(5)
      ..write(obj.platform)
      ..writeByte(6)
      ..write(obj.runtime)
      ..writeByte(7)
      ..write(obj.genres)
      ..writeByte(8)
      ..write(obj.isReviewed)
      ..writeByte(9)
      ..write(obj.rating)
      ..writeByte(10)
      ..write(obj.note)
      ..writeByte(11)
      ..write(obj.isWatched);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ScheduledEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
