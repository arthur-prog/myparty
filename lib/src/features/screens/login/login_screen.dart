import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/common_widgets/form/form_footer_widget.dart';
import 'package:my_party/src/common_widgets/form/form_header_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/features/screens/login/widgets/login_form_widget.dart';
import 'package:my_party/src/features/screens/signup/signup_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final platformBrightness = MediaQuery.of(context).platformBrightness;

    return SafeArea(
      child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
        child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FormHeaderWidget(
                  title: AppLocalizations.of(context)!.loginTitle,
                  subTitle: AppLocalizations.of(context)!.loginSubTitle,
                ),
                const LoginForm(),
                FooterFormWidget(
                  platformBrightness: platformBrightness,
                  text1: AppLocalizations.of(context)!.dontHaveAccount,
                  text2: AppLocalizations.of(context)!.signUp,
                  redirection: () => Get.to(() => const SignUpScreen()),
                )
              ],
            ),
        ),
      ),
          )),
    );
  }
}
