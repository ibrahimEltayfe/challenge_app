import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> statusSnackBar({
  required BuildContext context,
  required String text,
  bool isError = false
}){
  return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: isError?AppColors.darkRed:Colors.green,
        content: SizedBox(
          child: Text(
          text,
          style: context.textTheme.headlineMedium!.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
         ),
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        margin: EdgeInsets.only(
            bottom: 5,
            right: 10,
            left: 10
        ),
      ));
}