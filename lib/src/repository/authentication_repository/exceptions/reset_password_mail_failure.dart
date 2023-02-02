import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class ResetPasswordEmailFailure {
  final String message;

  const ResetPasswordEmailFailure([this.message = "An Unknown Error Occurred"]);

  factory ResetPasswordEmailFailure.code(String code){
    switch(code){
      case 'invalid-email':
        return ResetPasswordEmailFailure(AppLocalizations.of(Get.context!)!.invalidEmailException);
      case 'user-not-found':
        return ResetPasswordEmailFailure(AppLocalizations.of(Get.context!)!.userNotFoundException);
      default:
        return ResetPasswordEmailFailure(AppLocalizations.of(Get.context!)!.somethingWentWrong);
    }
  }
}