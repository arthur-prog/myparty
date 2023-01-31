import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/form/form_header_widget.dart';
import 'package:my_party/src/features/controllers/forget_password/forget_password_mail/forget_password_mail_controller.dart';
import 'package:my_party/src/features/screens/forget_password/forget_password_otp/opt_screen.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPassordMailController());
    final _formKey = GlobalKey<FormState>();

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(30),
              child: Column(
                children: [
                  FormHeaderWidget(
                    iconData: Icons.mark_email_read_outlined,
                    iconSize: 150,
                    heightBetween: 20,
                    title: AppLocalizations.of(context)!.forgetPassword,
                    subTitle: AppLocalizations.of(context)!.forgetMailSubTitle,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          validator: (value) => controller.validateEmail(value!, context),
                          controller: controller.email,
                          decoration: InputDecoration(
                            label: Text(AppLocalizations.of(context)!.email),
                            hintText: AppLocalizations.of(context)!.email,
                            prefixIcon: const Icon(Icons.mail_outline_rounded),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  controller.sendResetPasswordMail();
                                }
                              },
                              child: Text(AppLocalizations.of(context)!.next)),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
