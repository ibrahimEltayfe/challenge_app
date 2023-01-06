import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:flutter/material.dart';

enum Socials{
  google,
  facebook,
  linkedIn,
  github,
}

extension SocialsIcons on Socials{
  IconData get getFaIcon {
    switch(this){
      case Socials.google : return AppIcons.googleFa;
      case Socials.facebook: return AppIcons.facebookFa;
      case Socials.linkedIn: return AppIcons.linkedInFa;
      case Socials.github: return AppIcons.githubFa;
    }
  }
}