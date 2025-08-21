import '../util/environment/environment.dart';

class Config {
  static String baseUrl = baseUrlSetter(Environment.mode);
  static const headers = {
    "Content-Type": "application/json",
    "Accept": "application/json",
  };
}

String baseUrlSetter(String mode) {
  switch (mode) {
    case "DEV":
      return 'https://masjid.super-coding.com/wp-json/collections/';
    case "SIT":
      return 'https://masjid.super-coding.com/wp-json/collections/';
    case "PREPRD":
      return 'https://masjid.super-coding.com/wp-json/collections/';
    default:
      return 'https://masjid.super-coding.com/wp-json/collections/';
  }
}
