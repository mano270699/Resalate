import 'dart:convert';

import 'package:dartz/dartz.dart';

import 'package:flutter/foundation.dart';
import 'package:resalate/src/Auth/data/models/login_model.dart';

import '../../../../core/common/error/error_handler.dart';
import '../../../../core/common/models/error_model.dart';
import '../../../../core/util/localization/localization_cache_helper.dart';
import '../../../../core/util/network_service.dart';
import '../../../../core/util/token_util.dart';
import '../models/complete_regester_model.dart';
import '../models/drop_down_list_model.dart';
import '../models/register_model.dart';

abstract class AuthRepository {
  Future<Either<String, RegisterModel>> register({
    required String name,
    required String userName,
    required String email,
    required String phone,
    required String dateOfBirth,
    required String university,
    required String province,
    required String password,
    required String confirmPassword,
  });
  Future<Either<String, LoginResponse>> login({
    required String userNameEmail,
    required String password,
  });
  Future<Either<ErrorModel, SocialLoginResponse>> googleLogin({
    required String googleToken,
  });
  Future<Either<ErrorModel, SocialLoginResponse>> appleLogin({
    required String appleToken,
  });
  Future<Either<String, DefaultModel>> forgetPassword({required String email});
  Future<Either<String, CompleteRegisterModel>> completeRegisteration({
    required String phoneNumber,
    required String dateOfBirth,
    required String university,
    required String province,
  });
  Future<Either<String, DropDownListValuesModel>> getDropDownListValues();
}

class AuthRepositoryImpl extends AuthRepository {
  final NetworkService _networkService;

  AuthRepositoryImpl(this._networkService);

  @override
  Future<Either<String, RegisterModel>> register({
    required String name,
    required String userName,
    required String email,
    required String phone,
    required String password,
    required String dateOfBirth,
    required String university,
    required String province,
    required String confirmPassword,
  }) async {
    // Validate Password (Client-Side) -  Moved here for clarity
    if (password.length < 8) {
      return Left("Password must be at least 8 characters long.");
    }
    if (!password.contains(RegExp(r'[A-Z]'))) {
      return Left("Password must contain at least one uppercase letter.");
    }
    if (!password.contains(RegExp(r'[a-z]'))) {
      return Left("Password must contain at least one lowercase letter.");
    }
    if (!password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return Left(
          "Password must contain at least one special character (e.g., @, #, \$, %, &, etc.).");
    }
    if (password != confirmPassword) {
      return Left("Passwords do not match.");
    }

    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "register-student?lang=${localizationCacheHelper.getLanguageCode()}",
          jsonEncode({
            // Use jsonEncode instead of json.encode
            "name": name,
            "username": userName,
            "email": email,
            "phone_number": phone,
            "date_of_birth": dateOfBirth,
            "university": university,
            "province": province,
            "password": password,
            "confirm_password":
                confirmPassword // Use confirmPassword here!  Important fix!
          }));

      if (kDebugMode) {
        // Use kDebugMode for debugPrint checks.
        print("statusCode::${response.statusCode} ");
      }

      // Assuming response has a status code and data field
      if (response.statusCode == 200) {
        RegisterModel registerModel = RegisterModel.fromJson(response.data);
        return Right(registerModel);
      } else {
        if (kDebugMode) {
          print("error::${response.data} ");
        }

        if (response.data != null &&
            response.data
                is Map<String, dynamic> && // Check that response.data is a Map
            response.data.containsKey("errors") &&
            response.data["errors"] is List &&
            response.data["errors"].isNotEmpty) {
          // Handle the error messages as a list.  Return a concatenated string, or just the first error.
          // Option 1: Return the first error:
          // return Left(response.data["errors"][0].toString());

          // Option 2: Concatenate all errors:
          final errors = (response.data["errors"] as List<dynamic>)
              .cast<String>()
              .join(". ");
          return Left(errors);
        } else {
          return Left(
              "Registration failed: Unknown error. Status Code: ${response.statusCode}"); // Handle unexpected error structure
        }
      }
    } catch (e, t) {
      if (kDebugMode) {
        print("catch::${e.toString()} ,,, trace $t");
      }

      // Catch any exception and return it as ErrorModel
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, LoginResponse>> login(
      {required String userNameEmail, required String password}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "login-student?lang=${localizationCacheHelper.getLanguageCode()}",
          jsonEncode({
            "username": userNameEmail,
            "password": password,
          }));

      debugPrint("response.statusCode::${response.statusCode}");
      if (response.statusCode == 200) {
        LoginResponse loginResponse = LoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        print("Data::${response.data}");

        // Check if response.data is already an ErrorModel or needs to be converted
        ErrorModel errorModel;
        if (response.data is Map<String, dynamic>) {
          // Response data is a map, parse as ErrorModel
          errorModel = ErrorModel.fromJson(response.data);
        } else {
          // Response data is not a map, create an ErrorModel with a default message
          errorModel =
              ErrorModel(message: response.data.toString(), status: 'Error');
        }

        return Left(errorModel.message);
      }
    } catch (e, t) {
      debugPrint("Error::${e}--- trace::$t}");

      // Catch any exception and return it as ErrorModel
      return Left(e.toString());
      // return Left(
      //     ErrorModel(message: ResponseError.getMessage(e), status: "Error"));
    }
  }

  @override
  Future<Either<ErrorModel, SocialLoginResponse>> googleLogin(
      {required String googleToken}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();

      final response = await _networkService.post(
          "google-login-register?lang=${localizationCacheHelper.getLanguageCode()}",
          {
            "google_token": googleToken,
          });
      // Assuming response has a status code and data field
      if (response.statusCode == 200) {
        SocialLoginResponse loginResponse =
            SocialLoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        // Convert error response to ErrorModel if status is not 200
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        return Left(ResponseError.getMessage(errorModel.message));
      }
    } catch (e) {
      debugPrint("error::$e");
      // Catch any exception and return it as ErrorModel
      return Left(ErrorModel(message: e.toString(), status: "Error"));
    }
  }

  @override
  Future<Either<String, DropDownListValuesModel>>
      getDropDownListValues() async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.get(
        "additional-information?lang=${localizationCacheHelper.getLanguageCode()}",
      );
      DropDownListValuesModel res =
          DropDownListValuesModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(ResponseError.getMessage(e));
    }
  }

  @override
  Future<Either<String, CompleteRegisterModel>> completeRegisteration(
      {required String phoneNumber,
      required String dateOfBirth,
      required String university,
      required String province}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "additional-form?lang=${localizationCacheHelper.getLanguageCode()}", {
        "phone_number": phoneNumber,
        "date_of_birth": dateOfBirth,
        "university": university,
        "province": province
      },
          headers: {
            "Authorization": "Bearer ${await TokenUtil.getTokenFromMemory()}"
          });
      // Assuming response has a status code and data field

      debugPrint("response.statusCode::${response.statusCode}");
      if (response.statusCode == 200) {
        CompleteRegisterModel loginResponse =
            CompleteRegisterModel.fromJson(response.data);
        return Right(loginResponse);
      } else {
        print("Data::${response.data}");
        // Convert error response to ErrorModel if status is not 200

        return Left(response.data["error"]);
      }
    } catch (e) {
      debugPrint("response.statusCode::${e.toString()}");

      // Catch any exception and return it as ErrorModel
      return Left(e.toString());
      // return Left(
      //     ErrorModel(message: ResponseError.getMessage(e), status: "Error"));
    }
  }

  @override
  Future<Either<String, DefaultModel>> forgetPassword(
      {required String email}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();
      final response = await _networkService.post(
          "forgot-password?lang=${localizationCacheHelper.getLanguageCode()}",
          {"user_identifier": email});
      DefaultModel res = DefaultModel.fromJson(response.data);
      return Right(res);
    } catch (e, t) {
      debugPrint("error:$e-- trace $t");
      return Left(ResponseError.getMessage(e));
    }
  }

  @override
  Future<Either<ErrorModel, SocialLoginResponse>> appleLogin(
      {required String appleToken}) async {
    try {
      LocalizationCacheHelper localizationCacheHelper =
          LocalizationCacheHelper();

      final response = await _networkService.post(
          "apple-login-register?lang=${localizationCacheHelper.getLanguageCode()}",
          {
            "apple_token": appleToken,
          });
      // Assuming response has a status code and data field
      if (response.statusCode == 200) {
        SocialLoginResponse loginResponse =
            SocialLoginResponse.fromJson(response.data);
        return Right(loginResponse);
      } else {
        // Convert error response to ErrorModel if status is not 200
        ErrorModel errorModel = ErrorModel.fromJson(response.data);
        return Left(ResponseError.getMessage(errorModel.message));
      }
    } catch (e) {
      debugPrint("error::$e");
      // Catch any exception and return it as ErrorModel
      return Left(ErrorModel(message: e.toString(), status: "Error"));
    }
  }
}
