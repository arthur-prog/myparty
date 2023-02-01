import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:my_party/src/features/controllers/signup/signup_controller.dart';

class SignUpFormWidget extends StatelessWidget {
  const SignUpFormWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SignUpController());
    final _formKey = GlobalKey<FormState>();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.username,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.username,
                ),
                prefixIcon: const Icon(LineAwesomeIcons.user),
              ),
              onChanged: (content) async {
                await controller.validateUsername();
              },
            ),
            Obx(() => controller.isUsernameAvailable.value || controller.username.text.isEmpty
                ? const SizedBox(height: 10,)
                : SizedBox(
                  height: 25,
                  child: Center(
                    child: Text(
                        AppLocalizations.of(context)!.usernameNotAvailable,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ),
                )),
            TextFormField(
              validator: (value) => controller.validateEmail(value!),
              controller: controller.email,
              decoration: InputDecoration(
                label: Text(
                  AppLocalizations.of(context)!.email,
                ),
                prefixIcon: const Icon(Icons.email_outlined),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Obx(
              () => TextFormField(
                validator: (value) =>
                    controller.validatePassword(value!),
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
              height: 30,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate() && controller.username.text.isNotEmpty) {
                    SignUpController.instance.registerUser(
                        controller.email.text.trim(),
                        controller.password.text.trim());
                  }
                },
                child: Text(AppLocalizations.of(context)!.signUp.toUpperCase()),
              ),
            )
          ],
        ),
      ),
    );
  }
}
