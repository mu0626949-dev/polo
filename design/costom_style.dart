import 'package:flutter/material.dart';
import 'package:polo/design/costom_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static  TextStyle button = TextStyle(
    color: AppColors.blueColor,
    fontSize: 17,
    fontWeight: FontWeight.w600,
  );

  static  TextStyle title = TextStyle(
    color: AppColors.blackColor,
    fontSize: 22,
    fontWeight: FontWeight.bold,
  );

  static  TextStyle body = TextStyle(
    color: AppColors.blackColor,
    fontSize: 14,
  );
}
