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
      return 'https://student.valuxapps.com/api/';
    case "SIT":
      return 'https://student.valuxapps.com/api/';
    case "PREPRD":
      return 'https://student.valuxapps.com/api/';
    default:
      return 'https://student.valuxapps.com/api/';
  }
}
