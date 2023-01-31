import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForgetPassordMailController extends GetxController{
  static ForgetPassordMailController get instance => Get.find();

  final email = TextEditingController();
  final _authRepo = Get.put(AuthenticationRepository());

  void sendResetPasswordMail(){
    _authRepo.sendResetPasswordMail(email.text);
  }

  String? validateEmail(String email, BuildContext context) {
    if (email.isEmpty) {
      return AppLocalizations.of(context)!.mailValidationNull;
    } else if(EmailValidator.validate(email) == false){
      return AppLocalizations.of(context)!.mailValidationInvalid;
    }
    return null;
  }

}