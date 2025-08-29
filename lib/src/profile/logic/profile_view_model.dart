import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:resalate/core/util/token_util.dart';
import 'package:resalate/src/home/data/models/home_data_model.dart';
import 'package:resalate/src/profile/data/models/profile_model.dart';
import 'package:resalate/src/profile/data/models/sponser_model.dart';

import '../../../core/blocs/generic_cubit/generic_cubit.dart';
import '../../../core/common/models/error_model.dart';
import '../../../core/common/models/failure.dart';
import '../../../core/util/validation.dart';
import '../data/models/update_user_data.dart' hide User;
import '../data/repository/profile_repository.dart';

class ProfileViewModel {
  final ProfileRepositoryImpl profileRepositoryImpl;

  ProfileViewModel(this.profileRepositoryImpl);

  GenericCubit<ProfileModelResponse> profileRes =
      GenericCubit(ProfileModelResponse());

  GenericCubit<bool> isUserLoggedin = GenericCubit(true);

  checkLogin() async {
    final token = await TokenUtil.getTokenFromMemory();

    if (token.isNotEmpty) {
      await getProfileData();

      isUserLoggedin.onUpdateData(true);
    } else {
      isUserLoggedin.onUpdateData(false);
    }
  }

  Future<void> getProfileData() async {
    profileRes.onLoadingState();
    try {
      Either<String, ProfileModelResponse> response =
          await profileRepositoryImpl.getProfileData();

      response.fold(
        (failure) {
          profileRes.onErrorState(Failure(failure));
        },
        (user) async {
          setProfileData(user.user ?? User());
          profileRes.onUpdateData(user);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      profileRes.onErrorState(Failure('$e'));
    }
  }

  GenericCubit<File> imageFile = GenericCubit(File(""));

  TextEditingController email = TextEditingController();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();

  GenericCubit<String> emailValidation = GenericCubit('');
  GenericCubit<String> phoneNumberValidation = GenericCubit('');
  GenericCubit<String> nameValidation = GenericCubit('');

  TextEditingController sponserEmail = TextEditingController();
  TextEditingController sponserName = TextEditingController();
  TextEditingController sponserPhone = TextEditingController();
  TextEditingController sponserMessage = TextEditingController();

  GenericCubit<String> sponserEmailValidation = GenericCubit('');
  GenericCubit<String> sponserNameValidation = GenericCubit('');
  GenericCubit<String> sponserPhoneValidation = GenericCubit('');
  GenericCubit<String> sponserMessageValidation = GenericCubit('');

  TextEditingController contactEmail = TextEditingController();
  TextEditingController contactName = TextEditingController();
  TextEditingController contactPhone = TextEditingController();
  TextEditingController contactSubject = TextEditingController();
  TextEditingController contactMessage = TextEditingController();

  GenericCubit<String> contactEmailValidation = GenericCubit('');
  GenericCubit<String> contactNameValidation = GenericCubit('');
  GenericCubit<String> contactPhoneValidation = GenericCubit('');
  GenericCubit<String> contactSubjectValidation = GenericCubit('');
  GenericCubit<String> contactMessageValidation = GenericCubit('');
  setProfileData(User user) {
    name.text = user.name ?? "";
    phone.text = user.phone ?? "";
    email.text = user.email ?? "";
  }

  Future<void> pickImage({
    required ImageSource source,
  }) async {
    final ImagePicker picker = ImagePicker();

    try {
      XFile? pickedFile = await picker.pickImage(
        source: source,
        imageQuality: 50,
        maxHeight: 500,
        maxWidth: 500,
      );

      if (pickedFile != null) {
        File file = File(pickedFile.path);
        imageFile.onUpdateData(file);
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error picking image: $e");
      }
    }
  }

  GenericCubit<UpdateUserResponse> updateProfileRes =
      GenericCubit(UpdateUserResponse());
  GenericCubit<SponserModel> sponserRes = GenericCubit(SponserModel());
  Future updateProfile(
    BuildContext context,
  ) async {
    updateProfileRes.onLoadingState();

    try {
      Either<String, UpdateUserResponse> response =
          await profileRepositoryImpl.updateProfile(
        filePath: imageFile.state.data,
        email: email.text,
        name: name.text,
        phone: phone.text,
      );

      response.fold(
        (failure) {
          updateProfileRes.onErrorState(Failure(failure));
        },
        (user) async {
          updateProfileRes.onUpdateData(user);
          await getProfileData();
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      updateProfileRes.onErrorState(Failure('$e'));
    }
  }

  Future<void> addSponser({
    required BuildContext context,
  }) async {
    sponserNameValidation
        .onUpdateData(Validation.fieldRequiredValidation(sponserName.text));
    sponserPhoneValidation
        .onUpdateData(Validation.fieldRequiredValidation(sponserPhone.text));
    sponserEmailValidation
        .onUpdateData(Validation.fieldRequiredValidation(sponserEmail.text));
    sponserMessageValidation
        .onUpdateData(Validation.fieldRequiredValidation(sponserMessage.text));

    if ((sponserNameValidation.state.data.isEmpty) &&
        (sponserPhoneValidation.state.data.isEmpty) &&
        (sponserMessageValidation.state.data.isEmpty) &&
        (sponserEmailValidation.state.data.isEmpty)) {
      try {
        sponserRes.onLoadingState();
        Either<String, SponserModel> response =
            await profileRepositoryImpl.addSponser(
          email: sponserEmail.text,
          phone: sponserPhone.text,
          name: sponserName.text,
          message: sponserMessage.text,
        );

        response.fold(
          (failure) {
            debugPrint("failure::$failure");
            Navigator.pop(context);
            sponserRes.onErrorState(Failure(failure));
          },
          (res) async {
            sponserRes.onUpdateData(res);

            sponserEmail.clear();
            sponserName.clear();
            sponserPhone.clear();
            sponserMessage.clear();

            Navigator.pop(context);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        sponserRes.onErrorState(Failure('$e'));
      }
    } else {
      if (kDebugMode) {
        print("in Loading state");
      }

      return;
    }
  }

  Future<void> contactUs({
    required BuildContext context,
  }) async {
    contactNameValidation
        .onUpdateData(Validation.fieldRequiredValidation(contactName.text));
    contactPhoneValidation
        .onUpdateData(Validation.fieldRequiredValidation(contactPhone.text));
    contactEmailValidation
        .onUpdateData(Validation.fieldRequiredValidation(contactEmail.text));
    contactSubjectValidation
        .onUpdateData(Validation.fieldRequiredValidation(contactSubject.text));
    contactMessageValidation
        .onUpdateData(Validation.fieldRequiredValidation(contactMessage.text));

    if ((contactNameValidation.state.data.isEmpty) &&
        (contactPhoneValidation.state.data.isEmpty) &&
        (contactMessageValidation.state.data.isEmpty) &&
        (contactSubjectValidation.state.data.isEmpty) &&
        (contactEmailValidation.state.data.isEmpty)) {
      try {
        contactRes.onLoadingState();
        Either<String, DefaultModel> response =
            await profileRepositoryImpl.contactUs(
          subject: contactSubject.text,
          email: contactEmail.text,
          phone: contactPhone.text,
          name: contactName.text,
          message: contactMessage.text,
        );

        response.fold(
          (failure) {
            debugPrint("failure::$failure");
            Navigator.pop(context);
            contactRes.onErrorState(Failure(failure));
          },
          (res) async {
            contactRes.onUpdateData(res);

            contactEmail.clear();
            contactName.clear();
            contactPhone.clear();
            contactSubject.clear();
            contactMessage.clear();

            Navigator.pop(context);
          },
        );
      } on Failure catch (e, s) {
        debugPrint("lllllllllllll:$s");
        contactRes.onErrorState(Failure('$e'));
      }
    } else {
      if (kDebugMode) {
        print("in Loading state");
      }

      return;
    }
  }

  GenericCubit<HomeDataModel> appOptionRes = GenericCubit(HomeDataModel());
  GenericCubit<DefaultModel> contactRes = GenericCubit(DefaultModel());
  GenericCubit<DefaultModel> profileAction = GenericCubit(DefaultModel());

  Future<void> getAppOption() async {
    try {
      appOptionRes.onLoadingState();
      Either<String, HomeDataModel> response =
          await profileRepositoryImpl.getAppOption();

      response.fold(
        (failure) {
          appOptionRes.onErrorState(Failure(failure));
        },
        (res) async {
          appOptionRes.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      appOptionRes.onErrorState(Failure('$e'));
    }
  }

  Future<void> logout() async {
    try {
      profileAction.onLoadingState();
      Either<String, DefaultModel> response =
          await profileRepositoryImpl.logout();

      response.fold(
        (failure) {
          profileAction.onErrorState(Failure(failure));
        },
        (res) async {
          TokenUtil.clearToken();
          UserIdUtil.clearUserId();
          checkLogin();
          profileAction.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      profileAction.onErrorState(Failure('$e'));
    }
  }

  Future<void> deleteAccount() async {
    try {
      profileAction.onLoadingState();
      Either<String, DefaultModel> response =
          await profileRepositoryImpl.deleteAccount();

      response.fold(
        (failure) {
          profileAction.onErrorState(Failure(failure));
        },
        (res) async {
          TokenUtil.clearToken();
          UserIdUtil.clearUserId();
          checkLogin();
          profileAction.onUpdateData(res);
        },
      );
    } on Failure catch (e, s) {
      debugPrint("lllllllllllll:$s");
      profileAction.onErrorState(Failure('$e'));
    }
  }
}
