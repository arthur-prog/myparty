import 'package:flutter/material.dart';

class ForgetPasswordBtnWidget extends StatelessWidget {
  ForgetPasswordBtnWidget({
    Key? key,
    required this.icon,
    required this.title,
    required this.subTitle, required this.onTap,
  }) : super(key: key);

  final IconData icon;
  final String title, subTitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: mediaQuery.platformBrightness == Brightness.light ?
              Colors.grey.shade200 :
              Colors.grey.shade800
          ,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 60,
            ),
            const SizedBox(
              width: 10,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Text(
                  subTitle,
                  style: Theme.of(context).textTheme.bodyText2,
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}