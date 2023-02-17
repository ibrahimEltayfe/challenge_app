import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/cupertino.dart';

BoxDecoration shadowBoxDecoration(BuildContext context){
  return BoxDecoration(
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
        color: context.theme.lightGreyColor,
        blurRadius: 11,
        offset: const Offset(2, 4),
      ),
    ],
    color: context.theme.whiteColor,
  );
}