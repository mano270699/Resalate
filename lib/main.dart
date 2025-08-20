import 'package:flutter/material.dart';

import 'core/base/dependency_injection.dart' as di;
import 'core/base/main_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MainApp());
}
