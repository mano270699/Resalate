// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalizationModelAdapter extends TypeAdapter<LocalizationModel> {
  @override
  final int typeId = 1;

  @override
  LocalizationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalizationModel(
      languageCode: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LocalizationModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.languageCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalizationModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
