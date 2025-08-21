class Validation {
  //-----------------------------------
  ///  Return KEYS FOR LOCALIZATION
  //-----------------------------------
  static String userEmailValidation(String? input) {
    if (input == null || input.isEmpty) {
      return 'field_cannot_be_empty';
    }
    if (!input.contains('@')) {
      return 'email_must_contain_at';
    }
    if (!input.contains('.')) {
      return 'email_must_contain_dot';
    }

    if (!RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+$")
        .hasMatch(input)) {
      return 'email_is_invalid';
    }
    return "";
  }

  static String passwordValidation(String? input) {
    if (input == null || input.isEmpty) {
      return 'password_validation';
    }
    return "";
  }

  static String passwordConfirmationValidation(String? input,
      {required String passWord}) {
    if (input == null || input.isEmpty) {
      return 'field_cannot_be_empty';
    }
    if (input != passWord) {
      return 'passwords_must_match';
    }

    return "";
  }

  static String fieldRequiredValidation(String? input) {
    if (input == null || input.isEmpty) {
      return 'field_cannot_be_empty';
    }
    return "";
  }

  static String nationalNumberValidation(String? input) {
    if (input == null || input.isEmpty) {
      return 'field_cannot_be_empty';
    }
    if (input.length < 14) {
      return 'national_number_must_be';
    }
    return "";
  }

  static String phoneNumberValidation(String? input) {
    if (input == null || input.isEmpty) {
      return 'field_cannot_be_empty';
    }
    if (!RegExp(r'^(?:\+20|0)?(10|11|12|15)\d{8}$').hasMatch(input)) {
      return 'phone_is_invalid';
    }
    if (input.length < 11) {
      return 'phone_is_invalid';
    }

    return "";
  }
}
