import 'package:hive_flutter/adapters.dart';

part 'localization_model.g.dart';

@HiveType(typeId: 1)
class LocalizationModel {
  @HiveField(0)
  String languageCode;
  LocalizationModel({
    required this.languageCode,
  });
}
