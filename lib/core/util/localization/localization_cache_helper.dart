import 'dart:io';

import 'package:hive_flutter/adapters.dart';

import '../../base/dependency_injection.dart';
import 'models/localization_model.dart';

class LocalizationCasheHelper {
  String getLanguageCode() {
    final box = sl<Box>();
    LocalizationModel x = box.get(
      'localization',
      defaultValue:
          LocalizationModel(languageCode: Platform.localeName.split('_').first),
    );
    return x.languageCode;
  }

  void setLanguageCode(String languageCode) {
    final box = sl<Box>();

    box.put('localization', LocalizationModel(languageCode: languageCode));
  }
}
