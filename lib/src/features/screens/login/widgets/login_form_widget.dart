import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_party/src/features/controllers/login/login_controller.dart';
import 'package:my_party/src/features/screens/forget_password/forget_password_options/forget_password_modal_bottom_sheet.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;
    final controller = Get.put(LoginController());
    final _formKey = GlobalKey<FormState>();

    return Form(
      key: _formKey,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: controller.email,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person_outline_outlined),
                labelText: AppLocalizations.of(context)!.email,
                hintText: AppLocalizations.of(context)!.email,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => TextFormField(
                controller: controller.password,
                obscureText: controller.isPasswordNotVisible.value,
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.fingerprint),
                    labelText: AppLocalizations.of(context)!.password,
                    hintText: AppLocalizations.of(context)!.password,
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => controller.changePasswordVisibility(),
                      icon: const Icon(Icons.remove_red_eye_outlined),
                    )),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    ForgetPasswordScreen.buildShowModalBottomSheet(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.forgetPassword,
                    style: GoogleFonts.poppins(
                      color: platformBrightness == Brightness.light
                          ? Colors.black
                          : Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                      decoration: TextDecoration.underline,
                    ),
                  )),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  AuthenticationRepository.instance
                      .signInWithEmailandPassword(controller.email.text, controller.password.text);
                },
                child: Text(AppLocalizations.of(context)!.login.toUpperCase()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
