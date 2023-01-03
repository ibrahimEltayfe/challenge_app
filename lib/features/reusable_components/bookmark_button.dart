import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class BookmarkButton extends StatelessWidget {
  final bool isActive;
  final double width;
  final double height;
  const BookmarkButton({
    Key? key,
    required this.isActive,
    this.width = 36,
    this.height = 36
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(9),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 23,
            offset: Offset(0, 4),
          ),
        ],
        gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Color(0xffcad8ee), Color(0x00ffffff)], ),
      ),

      child: FittedBox(
        child: FaIcon(
          isActive?AppIcons.bookmarkFillFa:AppIcons.bookmarkOutlineFa,
          color: context.theme.skyBlueColor,
        ),
      ),
    );
  }
}
