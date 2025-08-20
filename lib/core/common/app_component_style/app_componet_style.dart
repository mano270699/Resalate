import 'package:flutter/material.dart';

import '../../shared_components/app_bottom_sheet/models/app_bottom_sheet_model.dart';
import 'dark_component_style.dart';

class AppComponentStyle {
  static InputDecoration getInputDecortation(Locale locale) {
    return DarkComponentStyle.inputDecoration(locale);
  }

  static AppBottomSheetModel getAppBottomSheetModel() {
    return DarkComponentStyle.appBottomSheetModel;
  }
}
