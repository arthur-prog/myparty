import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:my_party/src/constants/image_strings.dart';
import 'package:my_party/src/repository/authentication_repository/authentication_repository.dart';

class FooterFormWidget extends StatelessWidget {
  const FooterFormWidget({
    Key? key,
    required this.platformBrightness, required this.text1, required this.text2, required this.redirection,
  }) : super(key: key);

  final Brightness platformBrightness;
  final String text1;
  final String text2;
  final VoidCallback redirection;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(AppLocalizations.of(context)!.or),
        const SizedBox(height: 20,),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              AuthenticationRepository.instance.signInWithGoogle();
            },
            icon: const Image(
              image: AssetImage(googleLogoImage),
              height: 20,
            ),
            label:
            Text(AppLocalizations.of(context)!.signInWithGoogle),
          ),
        ),
        TextButton(
            onPressed: redirection,
            child: Text.rich(
              TextSpan(
                text: text1,
                style: Theme.of(context).textTheme.bodyText1,
                children: [
                  TextSpan(
                    text: text2,
                    style: platformBrightness == Brightness.light
                        ? const TextStyle(color: Colors.black, decoration: TextDecoration.underline)
                        : const TextStyle(color: Colors.white, decoration: TextDecoration.underline),
                  ),
                ],
              ),
            )
        ),
      ],
    );
  }
}