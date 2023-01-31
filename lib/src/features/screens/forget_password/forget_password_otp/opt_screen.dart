import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:my_party/src/constants/colors.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(AppLocalizations.of(context)!.otpTitle,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 80,
                    )),
                Text(
                  AppLocalizations.of(context)!.otpSubTitle.toUpperCase(),
                  style: Theme.of(context).textTheme.headline5,
                ),
                const SizedBox(
                  height: 40,
                ),
                Text(
                  "${AppLocalizations.of(context)!.otpMessage}support@mail.com",
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 20,
                ),
                OtpTextField(
                  numberOfFields: 6,
                  fillColor: Colors.black.withOpacity(0.1),
                  cursorColor: mediaQuery.platformBrightness == Brightness.light
                      ? darkColor
                      : lightColor,
                  filled: true,
                  focusedBorderColor: primaryColor,
                  enabledBorderColor: mediaQuery.platformBrightness == Brightness.light
                      ? darkColor
                      : lightColor,
                  onSubmit: (String code) {
                    print("OTP IS => $code");
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text(AppLocalizations.of(context)!.next),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
