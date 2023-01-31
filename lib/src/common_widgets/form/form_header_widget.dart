import 'package:flutter/material.dart';

class FormHeaderWidget extends StatelessWidget {
  const FormHeaderWidget({
    Key? key,
    this.image = "",
    required this.title,
    required this.subTitle,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.heightBetween,
    this.textAlign,
    this.imageHeight = 0.2,
    this.iconData,
    this.iconSize,
  }) : super(key: key);

  final String image, title, subTitle;
  final CrossAxisAlignment crossAxisAlignment;
  final double? heightBetween;
  final double? imageHeight;
  final TextAlign? textAlign;
  final IconData? iconData;
  final double? iconSize;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Column(
      crossAxisAlignment: crossAxisAlignment,
      children: [
        if (image != "")
          Image(
            image: AssetImage(image),
            height: size.height * imageHeight!,
          ),
        if (iconData != null)
          Icon(
            iconData!,
            size: iconSize,
          ),
        SizedBox(height: heightBetween),
        Text(
          title,
          style: Theme.of(context).textTheme.headline1,
        ),
        Text(
          subTitle,
          style: Theme.of(context).textTheme.bodyText1,
          textAlign: textAlign,
        ),
      ],
    );
  }
}
