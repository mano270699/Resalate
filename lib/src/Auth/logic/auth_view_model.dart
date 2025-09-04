// import 'package:dartz/dartz.dart';
import 'dart:async';
import 'dart:convert';
import 'package:crypto/crypto.dart';

import 'package:dartz/dartz.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/error_model.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/util/token_util.dart';
import '../../../core/util/validation.dart';
import '../../layout/screens/user_bottom_navigation_screen.dart';
import '../data/models/login_model.dart';
import '../data/models/register_model.dart';
import '../data/models/reset_password_model.dart';
import '../data/repository/auth_repository.dart';

class AuthViewModel {
  AuthViewModel({required this.authRepositoryImpl});

  final AuthRepositoryImpl authRepositoryImpl;

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmPassword = TextEditingController();

  GenericCubit<String> emailValidation = GenericCubit('');
  GenericCubit<String> emailFogetPasswordValidation = GenericCubit('');
  GenericCubit<String> resetPasswordValidation = GenericCubit('');
  GenericCubit<String> confirmResetPasswordValidation = GenericCubit('');

  GenericCubit<String> nameValidation = GenericCubit('');
  GenericCubit<String> phoneNumberValidation = GenericCubit('');
  GenericCubit<String> userNameValidation = GenericCubit('');
  GenericCubit<String> passwordValidation = GenericCubit('');
  GenericCubit<String> confirmValidation = GenericCubit('');

  TextEditingController emailForgetPassword = TextEditingController();
  TextEditingController resetPassword = TextEditingController();
  TextEditingController confirmRestPassword = TextEditingController();

  TextEditingController userNameEmail = TextEditingController();
  TextEditingController loginPassword = TextEditingController();

  GenericCubit<String> userNameEmailValidation = GenericCubit('');
  GenericCubit<String> loginPasswordValidation = GenericCubit('');

  GenericCubit<RegisterModel> registerResponse = GenericCubit(RegisterModel());
  GenericCubit<LoginResponse> loginResponse = GenericCubit(LoginResponse());
  GenericCubit<LoginResponse> socialLoginResponse =
      GenericCubit(LoginResponse());

  GenericCubit<DefaultModel> forgetPasswordRes = GenericCubit(DefaultModel());
  GenericCubit<ResetPasswordResponse> resetPasswordRes =
      GenericCubit(ResetPasswordResponse());
  GenericCubit<DefaultModel> resendOtpRes = GenericCubit(DefaultModel());
  TextEditingController controller = TextEditingController();

  StreamController<ErrorAnimationType>? errorController;
  final formKey = GlobalKey<FormState>();

  GenericCubit<DefaultModel> sendOtpResponse = GenericCubit(DefaultModel());
  GenericCubit<DefaultModel> confirmOtpResponse = GenericCubit(DefaultModel());

  Future<void> register({
    required BuildContext context,
  }) async {
    nameValidation.onUpdateData(Validation.fieldRequiredValidation(name.text));
    phoneNumberValidation
        .onUpdateData(Validation.fieldRequiredValidation(phone.text));
    emailValidation
        .onUpdateData(Validation.fieldRequiredValidation(email.text));

    confirmValidation.onUpdateData(Validation.passwordConfirmationValidation(
        confirmPassword.text,
        passWord: password.text));
    passwordValidation
        .onUpdateData(Validation.passwordValidation(password.text));

    if ((emailValidation.state.data.isEmpty) &&
        (confirmValidation.state.data.isEmpty) &&
        (phoneNumberValidation.state.data.isEmpty) &&
        (nameValidation.state.data.isEmpty) &&
        (passwordValidation.state.data.isEmpty)) {
      try {
        registerResponse.onLoadingState();
        Either<String, RegisterModel> response =
            await authRepositoryImpl.register(
                email: email.text,
                phone: phone.text,
                name: name.text,
                password: password.text,
                confirmPassword: confirmPassword.text);

        response.fold(
          (failure) {
            debugPrint("failure::$failure");
            registerResponse.onErrorState(Failure(failure));
          },
          (user) async {
            await authRepositoryImpl.updateFCMToken();
            TokenUtil.saveToken(user.token ?? "");
            UserIdUtil.saveUserId(user.user!.id.toString());
            registerResponse.onUpdateData(user);

            password.clear();
            confirmPassword.clear();
            email.clear();
            name.clear();
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        registerResponse.onErrorState(Failure('$e'));
      }
    } else {
      debugPrint("in Loading state");

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
            await authRepositoryImpl.updateFCMToken();
            TokenUtil.saveToken(user.token ?? "");
            UserIdUtil.saveUserId(user.user!.id.toString());
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
      debugPrint("in Loading state");

      return;
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
      Either<ErrorModel, LoginResponse> response =
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
          TokenUtil.saveToken(user.token ?? "");
          UserIdUtil.saveUserId(user.user!.id.toString());

          debugPrint(
              "UserID::${await UserIdUtil.getUserIdFromMemory()} token::${await TokenUtil.getTokenFromMemory()}");

          // Sign out *after* successful backend login and token storage
          await _googleSignIn.signOut();

          // Use mounted check for safety with async gaps
          if (!context.mounted) return;
          Navigator.pushNamedAndRemoveUntil(
            context,
            MainBottomNavigationScreen.routeName,
            arguments: {"index": 0},
            (route) => false,
          );
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

  // signInWithApple(BuildContext context) async {
  //   final rawNonce = generateNonce();
  //   final nonce = sha256ofString(rawNonce);
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //     webAuthenticationOptions: WebAuthenticationOptions(
  //       clientId: 'de.lunaone.flutter.signinwithappleexample.service',
  //       redirectUri: kIsWeb
  //           ? Uri.parse("https://dentopia.app")
  //           : Uri.parse(
  //               'https://dentopia.app',
  //             ),
  //     ),
  //     nonce: nonce,
  //   );

  //   debugPrint("$credential");
  //   socialLoginResponse.onLoadingState();
  //   Either<ErrorModel, SocialLoginResponse> response =
  //       await authRepositoryImpl.appleLogin(
  //           appleToken: credential.identityToken ??
  //               ""); // Use ! because we checked for null

  //   response.fold(
  //     (failure) {
  //       debugPrint("failure.message ${failure.message}");
  //       socialLoginResponse.onErrorState(Failure(failure.message));
  //       // Maybe sign out on backend failure too? Depends on desired UX.
  //       // await _googleSignIn.signOut();
  //     },
  //     (user) async {
  //       socialLoginResponse.onUpdateData(user);
  //       TokenUtil.saveToken(user.data!.token.toString());
  //       UserIdUtil.saveUserId(user.data!.userId.toString());

  //       debugPrint(
  //           "UserID::${await UserIdUtil.getUserIdFromMemory()} token::${await TokenUtil.getTokenFromMemory()}");

  //       await _googleSignIn.signOut();

  //       if (!context.mounted) return;
  //       Navigator.pushNamedAndRemoveUntil(
  //         context,
  //         MainBottomNavigationScreen.routeName,
  //         arguments: {"index": 0},
  //         (route) => false,
  //       );
  //     },
  //   );

  //   // if (context.mounted) {
  //   //   socialLogin(
  //   //       context,
  //   //       "apple",
  //   //       "${credential.givenName ?? ""} ${credential.familyName ?? ""}",
  //   //       credential.email ?? "",
  //   //       credential.userIdentifier ?? "",
  //   //       accessToken: credential.identityToken ?? "");
  //   // }
  // }

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

  resendOtp({required String email}) async {
    try {
      resendOtpRes.onLoadingState();
      Either<String, DefaultModel> response =
          await authRepositoryImpl.forgetPassword(email: email);
      debugPrint("Response::$response");
      response.fold(
        (failure) {
          resendOtpRes.onErrorState(Failure(failure));
        },
        (res) async {
          startTimer();
          resendOtpRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      resendOtpRes.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<String> timerCubit = GenericCubit("2:00");
  GenericCubit<bool> showTimer = GenericCubit(false);

  Timer? timer;
  int _start = 120; // 2 minutes in seconds
  String get timerText {
    final minutes = (_start ~/ 60).toString().padLeft(1, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void startTimer() {
    _start = 120;
    timerCubit.onUpdateData(timerText);
    showTimer.onUpdateData(true); // Show the timer

    timer?.cancel();
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_start == 0) {
        timer.cancel();
        showTimer.onUpdateData(false); // Hide the timer when finished
      } else {
        _start--;
        timerCubit.onUpdateData(timerText);
      }
    });
  }

  Future<void> confirmOtp({
    required BuildContext context,
    required String email,
  }) async {
    confirmOtpResponse.onLoadingState();
    try {
      Either<String, DefaultModel> response = await authRepositoryImpl
          .verifyOtp(code: controller.text, email: email);

      response.fold(
        (failure) {
          confirmOtpResponse.onErrorState(Failure(failure));
        },
        (user) async {
          confirmOtpResponse.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      confirmOtpResponse.onErrorState(Failure('$e'));
    }
  }

  Future<void> resetUserPassword({
    required BuildContext context,
    required String email,
    required String code,
  }) async {
    confirmResetPasswordValidation.onUpdateData(
        Validation.passwordConfirmationValidation(confirmRestPassword.text,
            passWord: resetPassword.text));
    resetPasswordValidation
        .onUpdateData(Validation.passwordValidation(resetPassword.text));

    if ((confirmResetPasswordValidation.state.data.isEmpty) &&
        (resetPasswordValidation.state.data.isEmpty)) {
      try {
        resetPasswordRes.onLoadingState();
        Either<String, ResetPasswordResponse> response =
            await authRepositoryImpl.resetPassword(
                email: email,
                code: code,
                password: resetPassword.text,
                confirmPassword: confirmRestPassword.text);

        response.fold(
          (failure) {
            debugPrint("failure::$failure");
            resetPasswordRes.onErrorState(Failure(failure));
          },
          (user) async {
            resetPasswordRes.onUpdateData(user);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        resetPasswordRes.onErrorState(Failure('$e'));
      }
    } else {
      debugPrint("in Loading state");

      return;
    }
  }
}
