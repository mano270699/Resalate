import 'package:flutter/services.dart';

class MobileNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length < oldValue.text.length) {
      return newValue;
    } else {
      if (newValue.text.replaceAll(' ', '').length > 9) {
        return oldValue;
      }

      if (newValue.text.replaceAll('-', '').length == 1) {
        return TextEditingValue(
          text: '5${newValue.text}',
          selection: TextSelection.collapsed(offset: newValue.text.length + 1),
        );
      }
    }
    return newValue;
  }
}
