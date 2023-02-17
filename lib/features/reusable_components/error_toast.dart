import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

showErrorToast(BuildContext context,String message){
  Fluttertoast.showToast(
      msg: message,
      backgroundColor: context.theme.redColor,
      textColor: context.theme.whiteColor
  );
}