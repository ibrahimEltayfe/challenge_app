import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class InputTextField extends StatelessWidget {
  final double width;
  final double height;
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final bool isObscure;
  final double borderRadius;

  const InputTextField({
    Key? key,
    this.width = 338,
    this.height = 60,
    this.isObscure = false,
    required this.hint,
    this.validator,
    required this.controller,
    required this.textInputAction,
    this.keyboardType,
    this.borderRadius = 15
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width,
      //height: height,
      child: TextFormField(
        validator: validator,
        controller: controller,
        style: context.textTheme.titleMedium,
        textDirection: TextDirection.ltr,
        maxLines: 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: context.theme.primaryColor,
        textInputAction: textInputAction,
        keyboardType: keyboardType,
        obscureText: isObscure,
        decoration: InputDecoration(
          isDense: true,
          hintText: hint,
          hintStyle: context.textTheme.labelMedium,
          alignLabelWithHint: true,
          filled: false,

          errorStyle: context.textTheme.titleSmall!.copyWith(
            fontSize: 14,
            color: context.theme.redColor
          ),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: context.theme.primaryColor)
          ),

          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(borderRadius)),
              borderSide: BorderSide(color: context.theme.primaryColor)
          ),

        ),
      ),
    );
  }
}
