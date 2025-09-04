import 'package:flutter/services.dart';

class LengthLimitingTextFieldFormatterFixed
    extends LengthLimitingTextInputFormatter {
  LengthLimitingTextFieldFormatterFixed(int super.maxLength);

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (maxLength != null && newValue.text.codeUnits.length > maxLength!) {
      return oldValue;
    }

    return newValue;
  }
}
