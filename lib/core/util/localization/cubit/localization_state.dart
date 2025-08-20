part of 'localization_cubit.dart';

@immutable
abstract class LocalizationState {}

class LocalizationInitial extends LocalizationState {}

class ChangeLanguageState extends LocalizationState {
  final Locale locale;
  ChangeLanguageState({
    required this.locale,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangeLanguageState && other.locale == locale;
  }

  @override
  int get hashCode => locale.hashCode;
}
