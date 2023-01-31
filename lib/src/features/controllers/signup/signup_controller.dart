import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SignUpController extends GetxController{
  static SignUpController get instance => Get.find();

  final email = TextEditingController();
  final password = TextEditingController();
  Rx<bool> isPasswordNotVisible = true.obs;

  void registerUser(String email, String password, BuildContext context){
    AuthenticationRepository.instance.createUserWithEmailandPassword(email, password);
  }

  String? validateEmail(String email, BuildContext context) {
    if (email.isEmpty) {
      return AppLocalizations.of(context)!.mailValidationNull;
    } else if(EmailValidator.validate(email) == false){
      return AppLocalizations.of(context)!.mailValidationInvalid;
    }
    return null;
  }

  String? validatePassword(String password, BuildContext context) {
    if (password.length < 8) {
      return AppLocalizations.of(context)!.passwordAtLeast8Characters;
    }
    return null;
  }

  void changePasswordVisibility(){
    isPasswordNotVisible.value = !isPasswordNotVisible.value;
  }

}