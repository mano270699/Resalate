import 'dart:convert';

import 'package:flutter/services.dart';

Future<Map<String, dynamic>> load() async {
  String jsonString = await rootBundle.loadString('assets/json/routes.json');
  Map<String, dynamic> jsonMap = json.decode(jsonString);
  return jsonMap;
}
