import 'package:flutter/material.dart';
import 'package:get/get.dart';

SnackbarController SnackBarInformationWidget({required String title, required String text, required String type}) {
  late Color backgroundColor;
  late Color textColor;

  switch (type) {
    case 'success':
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      break;
    case 'error':
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
      break;
    default:
      backgroundColor = Colors.green.withOpacity(0.1);
      textColor = Colors.green;
  }

  return Get.snackbar(
      title,
      text,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: backgroundColor,
      colorText: textColor
  );
}