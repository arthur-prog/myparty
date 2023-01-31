import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:my_party/src/constants/colors.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/features/screens/login/login_screen.dart';
import 'package:my_party/src/features/screens/signup/signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    double height = mediaQuery.size.height;
    final platformBrightness = mediaQuery.platformBrightness;
    return Scaffold(
      // backgroundColor: platformBrightness == Brightness.light
      //     ? primaryColor
      //     : secondaryColor,
        body: Container(
      padding: const EdgeInsets.all(30),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(platformBrightness == Brightness.light
                ? welcomeDarkImage
                : welcomeLightImage),
            height: height * 0.5,
          ),
          Column(
            children: [
              Text(
                AppLocalizations.of(context)!.welcomeTitle,
                style: Theme.of(context).textTheme.headline3,
              ),
              Text(
                AppLocalizations.of(context)!.welcomeSubTitle,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: OutlinedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen())),
                      style: Theme.of(context).outlinedButtonTheme.style,
                      child: Text(
                          AppLocalizations.of(context)!.login.toUpperCase()))),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: ElevatedButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const SignUpScreen())),
                      style: Theme.of(context).elevatedButtonTheme.style,
                      child: Text(
                          AppLocalizations.of(context)!.signUp.toUpperCase()))),
            ],
          )
        ],
      ),
    ));
  }
}
