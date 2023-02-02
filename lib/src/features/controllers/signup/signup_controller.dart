import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/features/Entities/User.dart' as U;
import 'package:my_party/src/repository/user_repository/user_repository.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  final username = TextEditingController();

  final _userRepo = Get.put(UserRepository());

  Rx<bool> isPasswordNotVisible = true.obs;
  Rx<String> usernameError = ''.obs;
  Rx<String> mailError = ''.obs;

  void registerUser(String email, String password) async {
    AuthenticationRepository.instance.createUserWithEmailandPassword(email, password, username.text);
  }

  String? validateEmail(String email) {
    if (email.isEmpty) {
      return AppLocalizations.of(Get.context!)!.mailValidationNull;
    } else if(EmailValidator.validate(email) == false){
      return AppLocalizations.of(Get.context!)!.mailValidationInvalid;
    }
    return null;
  }

  String? validatePassword(String password) {
    if (password.length < 8) {
      return AppLocalizations.of(Get.context!)!.passwordAtLeast8Characters;
    }
    return null;
  }

  Future<void> isUsernameAvailable() async {
    if (!(await _userRepo.isUserNameAvailable(username.text))) {
      usernameError.value = AppLocalizations.of(Get.context!)!.usernameNotAvailable;
    } else {
      usernameError.value = '';
    }
  }

  Future<void> isMailAvailable() async {
    if (!(await _userRepo.isMailAvailable(email.text))) {
      mailError.value = AppLocalizations.of(Get.context!)!.mailNotAvailable;
    } else {
      mailError.value = '';
    }
  }

  void changePasswordVisibility(){
    isPasswordNotVisible.value = !isPasswordNotVisible.value;
  }

}