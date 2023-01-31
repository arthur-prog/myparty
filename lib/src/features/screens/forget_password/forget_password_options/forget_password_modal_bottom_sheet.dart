import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/features/screens/forget_password/forget_password_mail/forget_password_mail.dart';
import 'package:my_party/src/features/screens/forget_password/forget_password_options/forget_password_btn_widget.dart';

class ForgetPasswordScreen{
  static Future<dynamic> buildShowModalBottomSheet(BuildContext context) {
    return showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => Container(
          height: MediaQuery.of(context).size.height * 0.33,
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context)!.forgetPasswordTitle,
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                AppLocalizations.of(context)!.forgetPasswordSubTitle,
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const SizedBox(
                height: 30,
              ),
              ForgetPasswordBtnWidget(
                icon: Icons.mail_outline_rounded,
                title: AppLocalizations.of(context)!.email,
                subTitle: AppLocalizations.of(context)!.resetViaMail,
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPasswordMailScreen()));
                  },
              ),
            ],
          ),
        ));
  }
}