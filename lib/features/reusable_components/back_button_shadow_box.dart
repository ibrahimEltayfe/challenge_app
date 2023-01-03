import 'dart:developer';

import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BackButtonShadowBox extends StatelessWidget {
  const BackButtonShadowBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pop(context);
      },
      child: Container(
        width: 53,
        height: 51,
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: const[
            BoxShadow(
              color: Color(0x2b000000),
              blurRadius: 11,
              offset: Offset(2, 4),
            ),
          ],
          color: context.theme.whiteColor,
        ),
        child: FittedBox(
          child: FaIcon(AppIcons.leftBackArrowFa),
        ),
      ),
    );
  }
}
