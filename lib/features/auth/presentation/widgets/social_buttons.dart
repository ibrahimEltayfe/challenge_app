import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialButtons extends StatelessWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BuildSocialCircle(
          onTap: (){
            //todo: login with facebook
          },
          icon:AppIcons.googleFa ,
        ),

        const SizedBox(width: 10,),

        _BuildSocialCircle(
          onTap:(){
            //todo: login with google
          },
          icon:AppIcons.facebookFa ,
        )
      ],
    );
  }
}

class _BuildSocialCircle extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _BuildSocialCircle({Key? key, required this.icon, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child:Container(
        width: 45,
        height: 45,
        padding: const EdgeInsets.all(9),
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: context.theme.primaryColor)
        ),

        child: FittedBox(
          child: FaIcon(icon),
        ),
      ),
    );
  }
}
