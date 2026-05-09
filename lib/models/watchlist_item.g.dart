// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WatchlistItemAdapter extends TypeAdapter<WatchlistItem> {
  @override
  final int typeId = 5;

  @override
  WatchlistItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return WatchlistItem(
      tmdbId: fields[0] as int,
      title: fields[1] as String,
      posterPath: fields[2] as String,
      runtimeMinutes: fields[3] as int,
      genreIds: (fields[4] as List).cast<int>(),
      cachedAt: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, WatchlistItem obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.tmdbId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.posterPath)
      ..writeByte(3)
      ..write(obj.runtimeMinutes)
      ..writeByte(4)
      ..write(obj.genreIds)
      ..writeByte(5)
      ..write(obj.cachedAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WatchlistItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
