import 'package:flutter/material.dart';

class Environment {
  static const googleMapsApiKey = String.fromEnvironment('GOOGLE_MAPS_API_KEY');
  static String token = '';
  static const String mode = String.fromEnvironment('MODE');
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
}
