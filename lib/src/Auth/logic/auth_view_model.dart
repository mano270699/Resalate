// import 'package:dartz/dartz.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:dartz/dartz.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/error_model.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/util/token_util.dart';
import '../../../core/util/validation.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
import '../data/models/drop_down_list_model.dart';
// import '../data/models/error_model.dart';
import '../data/models/login_model.dart';
import '../data/models/register_model.dart';
import '../data/repository/auth_repository.dart';
import '../login/view/login_screen.dart';

// import '../../../core/blocs/generic_cubit/generic_cubit.dart';

class AuthViewModel {
  AuthViewModel({required this.authRepositoryImpl});

  final AuthRepositoryImpl authRepositoryImpl;

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController userName = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();
  TextEditingController dateOfBirth = TextEditingController();

  GenericCubit<String> emailValidation = GenericCubit('');
  GenericCubit<String> emailFogetPasswordValidation = GenericCubit('');
  GenericCubit<String> dateOfBirthValidation = GenericCubit('');
  GenericCubit<String> nameValidation = GenericCubit('');
  GenericCubit<String> phoneNumberValidation = GenericCubit('');
  GenericCubit<String> userNameValidation = GenericCubit('');
  GenericCubit<String> passwordValidation = GenericCubit('');
  GenericCubit<String> confirmValidation = GenericCubit('');

  TextEditingController emailForgetPassword = TextEditingController();

  TextEditingController userNameEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  GenericCubit<String> userNameEmailValidation = GenericCubit('');
  GenericCubit<String> loginPasswordValidation = GenericCubit('');

  GenericCubit<RegisterModel> registerResponse = GenericCubit(RegisterModel());
  GenericCubit<LoginResponse> loginResponse = GenericCubit(LoginResponse());
  GenericCubit<SocialLoginResponse> socialLoginResponse =
      GenericCubit(SocialLoginResponse());

  GenericCubit<DropDownListValuesModel> dropDownListRes =
      GenericCubit(DropDownListValuesModel());

  GenericCubit<DefaultModel> forgetPasswordRes = GenericCubit(DefaultModel());

  GenericCubit<String> selectedSelectedProvinceState = GenericCubit('');
  String selectedProvince = '';
  GenericCubit<String> selectedSelectedUniverstyState = GenericCubit('');
  String selectedUniversty = '';

  Future<void> register({
    required BuildContext context,
  }) async {
    nameValidation.onUpdateData(Validation.fieldRequiredValidation(name.text));
    phoneNumberValidation
        .onUpdateData(Validation.fieldRequiredValidation(phone.text));
    userNameValidation
        .onUpdateData(Validation.fieldRequiredValidation(userName.text));
    emailValidation
        .onUpdateData(Validation.fieldRequiredValidation(email.text));
    dateOfBirthValidation
        .onUpdateData(Validation.fieldRequiredValidation(dateOfBirth.text));
    confirmValidation.onUpdateData(Validation.passwordConfirmationValidation(
        confirmPassword.text,
        passWord: password.text));
    passwordValidation
        .onUpdateData(Validation.passwordValidation(password.text));
    selectedSelectedProvinceState
        .onUpdateData(Validation.fieldRequiredValidation(selectedProvince));
    selectedSelectedUniverstyState
        .onUpdateData(Validation.fieldRequiredValidation(selectedUniversty));

    print(selectedProvince);
    print(selectedUniversty);

    if ((emailValidation.state.data.isEmpty) &&
        (confirmValidation.state.data.isEmpty) &&
        (userNameValidation.state.data.isEmpty) &&
        (phoneNumberValidation.state.data.isEmpty) &&
        (selectedSelectedProvinceState.state.data.isEmpty) &&
        (selectedSelectedUniverstyState.state.data.isEmpty) &&
        (nameValidation.state.data.isEmpty) &&
        (dateOfBirthValidation.state.data.isEmpty) &&
        (passwordValidation.state.data.isEmpty)) {
      try {
        registerResponse.onLoadingState();
        Either<String, RegisterModel> response =
            await authRepositoryImpl.register(
                province: selectedProvince,
                university: selectedUniversty,
                dateOfBirth: dateOfBirth.text,
                email: email.text,
                phone: phone.text,
                name: name.text,
                userName: userName.text,
                password: password.text,
                confirmPassword: confirmPassword.text);

        response.fold(
          (failure) {
            debugPrint("failure::${failure}");
            registerResponse.onErrorState(Failure(failure));
          },
          (user) async {
            registerResponse.onUpdateData(user);

            password.clear();
            confirmPassword.clear();
            email.clear();
            name.clear();
            userName.clear();
            await Future.delayed(const Duration(seconds: 0))
                .whenComplete(() => Navigator.pushNamed(
                      context,
                      LoginScreen.routeName,
                    ));
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        registerResponse.onErrorState(Failure('$e'));
      }
    } else {
      print(" province: ${selectedSelectedProvinceState.state.data}");
      print(" university: ${selectedSelectedUniverstyState.state.data}");
      print(" dateOfBirth: ${dateOfBirth.text}");
      print(" email: ${email.text}");

      print("in Loading state");

      return;
    }
  }

  Future<void> login({
    required BuildContext context,
  }) async {
    userNameEmailValidation
        .onUpdateData(Validation.fieldRequiredValidation(userNameEmail.text));

    loginPasswordValidation
        .onUpdateData(Validation.passwordValidation(loginPassword.text));

    if ((userNameEmailValidation.state.data.isEmpty) &&
        (loginPasswordValidation.state.data.isEmpty)) {
      try {
        loginResponse.onLoadingState();

        Either<String, LoginResponse> response = await authRepositoryImpl.login(
          userNameEmail: userNameEmail.text,
          password: loginPassword.text,
        );

        response.fold(
          (failure) {
            debugPrint("error:$failure");
            loginResponse.onErrorState(Failure(failure));
          },
          (user) async {
            TokenUtil.saveToken(user.token ?? "");
            UserIdUtil.saveUserId(user.userId.toString());
            userNameEmail.clear();
            loginPassword.clear();
            loginResponse.onUpdateData(user);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        loginResponse.onErrorState(Failure('$e'));
      }
    } else {
      print("in Loading state");
      passwordValidation
          .onUpdateData(Validation.passwordValidation(password.text));
      return;
    }
  }

  Future<void> selectDate(BuildContext context) async {
    DateTime currentDate = DateTime.now();
    DateTime firstDate = DateTime(1900);
    DateTime lastDate = DateTime(currentDate.year - 5); // Min age: 10 years

    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: lastDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: "Select Date of Birth",
    );

    if (pickedDate != null) {
      // setState(() {
      dateOfBirth.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      // });
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  GenericCubit<LoginResponse> googleLogin = GenericCubit(LoginResponse());
  Future<GoogleSignInAccount?> signInWithGoogle(BuildContext context) async {
    socialLoginResponse.onLoadingState();
    try {
      // Use try-catch around the signIn call itself for better error handling
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account == null) {
        // User cancelled the sign-in
        socialLoginResponse
            .onErrorState(Failure("Google Sign-In cancelled by user."));
        debugPrint("Google Sign-In cancelled by user.");
        return null;
      }

      debugPrint(
          "GoogleSignInAccount received: ${account.displayName}, ${account.email}");

      // Now get authentication details
      final GoogleSignInAuthentication googleAuth =
          await account.authentication;

      debugPrint(
          "GoogleSignInAuthentication received. idToken present: ${googleAuth.idToken != null}, accessToken present: ${googleAuth.accessToken != null}");
      debugPrint(
          "googleAuth.idToken: ${googleAuth.idToken}"); // Log the token itself (or null)
      // debugPrint("googleAuth.accessToken: ${googleAuth.accessToken}"); // Log access token for comparison

      if (googleAuth.idToken == null) {
        debugPrint(
            "idToken is NULL. Check GoogleSignIn configuration (scopes, serverClientId) and platform setup (SHA1, Bundle ID, Google Cloud Console).");
        socialLoginResponse.onErrorState(Failure(
            "Failed to retrieve Google ID Token. Please check app configuration."));
        // Optionally sign out if the flow can't continue
        await _googleSignIn.signOut();
        return null;
      }

      // --- Continue with your existing logic ---
      Either<ErrorModel, SocialLoginResponse> response =
          await authRepositoryImpl.googleLogin(
              googleToken:
                  googleAuth.idToken!); // Use ! because we checked for null

      response.fold(
        (failure) {
          debugPrint("failure.message ${failure.message}");
          socialLoginResponse.onErrorState(Failure(failure.message));
          // Maybe sign out on backend failure too? Depends on desired UX.
          // await _googleSignIn.signOut();
        },
        (user) async {
          socialLoginResponse.onUpdateData(user);
          TokenUtil.saveToken(user.data!.token.toString());
          UserIdUtil.saveUserId(user.data!.userId.toString());

          debugPrint(
              "UserID::${await UserIdUtil.getUserIdFromMemory()} token::${await TokenUtil.getTokenFromMemory()}");

          // Sign out *after* successful backend login and token storage
          await _googleSignIn.signOut();

          if ((user.data!.dateOfBirth!.isNotEmpty &&
              user.data!.phoneNumber!.isNotEmpty &&
              user.data!.university!.isNotEmpty &&
              user.data!.province!.isNotEmpty)) {
            // Use mounted check for safety with async gaps
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              MainBottomNavigationScreen.routeName,
              arguments: {"index": 0},
              (route) => false,
            );
          } else {
            if (!context.mounted) return;
            Navigator.pop(context);
          }
        },
      );

      return null;
    } on PlatformException catch (e) {
      debugPrint(
          "PlatformException during Google Sign-In: ${e.code} - ${e.message}");
      String errorMessage = "Google Sign-In failed.";
      if (e.code == 'sign_in_failed') {
        errorMessage = "Google Sign-In failed. Please try again.";
      } else if (e.code == 'network_error') {
        errorMessage =
            "Network error during Google Sign-In. Please check your connection.";
      } else {
        errorMessage = "Google Sign-In error: ${e.message ?? e.code}";
      }
      socialLoginResponse.onErrorState(Failure(errorMessage));
      return null;
    } catch (e, s) {
      debugPrint("Unexpected error during Google Sign-In: $e\nStackTrace: $s");

      socialLoginResponse.onErrorState(
          Failure("An unexpected error occurred during Google Sign-In."));
      return null;
    }
  }

  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  signInWithApple(BuildContext context) async {
    final rawNonce = generateNonce();
    final nonce = sha256ofString(rawNonce);
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        clientId: 'de.lunaone.flutter.signinwithappleexample.service',
        redirectUri: kIsWeb
            ? Uri.parse("https://dentopia.app")
            : Uri.parse(
                'https://dentopia.app',
              ),
      ),
      nonce: nonce,
    );

    debugPrint("$credential");
    socialLoginResponse.onLoadingState();
    Either<ErrorModel, SocialLoginResponse> response =
        await authRepositoryImpl.appleLogin(
            appleToken: credential.identityToken ??
                ""); // Use ! because we checked for null

    response.fold(
      (failure) {
        debugPrint("failure.message ${failure.message}");
        socialLoginResponse.onErrorState(Failure(failure.message));
        // Maybe sign out on backend failure too? Depends on desired UX.
        // await _googleSignIn.signOut();
      },
      (user) async {
        socialLoginResponse.onUpdateData(user);
        TokenUtil.saveToken(user.data!.token.toString());
        UserIdUtil.saveUserId(user.data!.userId.toString());

        debugPrint(
            "UserID::${await UserIdUtil.getUserIdFromMemory()} token::${await TokenUtil.getTokenFromMemory()}");

        await _googleSignIn.signOut();

        if (!context.mounted) return;
        Navigator.pushNamedAndRemoveUntil(
          context,
          MainBottomNavigationScreen.routeName,
          arguments: {"index": 0},
          (route) => false,
        );
      },
    );

    // if (context.mounted) {
    //   socialLogin(
    //       context,
    //       "apple",
    //       "${credential.givenName ?? ""} ${credential.familyName ?? ""}",
    //       credential.email ?? "",
    //       credential.userIdentifier ?? "",
    //       accessToken: credential.identityToken ?? "");
    // }
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
  }

  forgetPassword() async {
    emailFogetPasswordValidation.onUpdateData(
        Validation.fieldRequiredValidation(emailForgetPassword.text));

    if ((emailFogetPasswordValidation.state.data.isEmpty)) {
      try {
        forgetPasswordRes.onLoadingState();
        Either<String, DefaultModel> response = await authRepositoryImpl
            .forgetPassword(email: emailForgetPassword.text);
        debugPrint("Response::$response");
        response.fold(
          (failure) {
            forgetPasswordRes.onErrorState(Failure(failure));
          },
          (res) async {
            forgetPasswordRes.onUpdateData(res);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        forgetPasswordRes.onErrorState(Failure('$e'));
      }
    }
  }

  getAllDropDownList() async {
    dropDownListRes.onLoadingState();

    try {
      Either<String, DropDownListValuesModel> response =
          await authRepositoryImpl.getDropDownListValues();
      debugPrint("Response::$response");
      response.fold(
        (failure) {
          dropDownListRes.onErrorState(Failure(failure));
        },
        (res) async {
          dropDownListRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      dropDownListRes.onErrorState(Failure('$e'));
    }
  }
}
