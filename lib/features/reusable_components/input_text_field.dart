import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:responsive_framework/responsive_framework.dart';

class InputTextField extends StatelessWidget {
  final double width;
  final String hint;
  final String? Function(String?)? validator;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final TextInputType? keyboardType;
  final bool isObscure;
  const InputTextField({
    Key? key,
    this.width = 338,
    this.isObscure = false,
    required this.hint,
    this.validator,
    required this.controller,
    required this.textInputAction,
    this.keyboardType
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width:width,
      height: 60,
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
          hintText: hint,
          hintStyle: context.textTheme.labelMedium,
          alignLabelWithHint: true,
          filled: false,
          border: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: context.theme.primaryColor)
          ),

          focusedBorder: OutlineInputBorder(
              borderRadius: const BorderRadius.all(Radius.circular(15)),
              borderSide: BorderSide(color: context.theme.primaryColor)
          ),

        ),
      ),
    );
  }
}
