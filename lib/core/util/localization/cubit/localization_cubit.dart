import '../localization_cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'localization_state.dart';

class LocalizationCubit extends Cubit<LocalizationState> {
  LocalizationCasheHelper localizationCasheHelper;
  LocalizationCubit(this.localizationCasheHelper)
      : super(LocalizationInitial());

  Future<void> getSavedLanguage() async {
    final languageCode = localizationCasheHelper.getLanguageCode();
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }

  Future<void> changeLanguage(String languageCode) async {
    localizationCasheHelper.setLanguageCode(languageCode);
    emit(ChangeLanguageState(locale: Locale(languageCode)));
  }
}
