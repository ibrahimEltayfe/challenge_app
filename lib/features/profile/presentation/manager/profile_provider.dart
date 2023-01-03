import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = Provider.autoDispose<ProfileProvider>((ref) {
  return ProfileProvider();
});

class ProfileProvider{
  void navigateToPage(BuildContext context,ProfileButtonType buttonType,{dynamic arguments}){
    switch(buttonType){
      case ProfileButtonType.editProfile:
         Navigator.pushNamed(context, AppRoutes.editProfileRoute);
         break;

      case ProfileButtonType.likes:
        Navigator.pushNamed(context, AppRoutes.userLikesRoute);
        break;

      case ProfileButtonType.myChallengesShares:
        Navigator.pushNamed(context, AppRoutes.userSharedChallengesRoute);
        break;

      case ProfileButtonType.settings:
        Navigator.pushNamed(context, AppRoutes.appSettingsRoute);
        break;

      case ProfileButtonType.about:
        Navigator.pushNamed(context, AppRoutes.aboutRoute);
        break;

      case ProfileButtonType.logout:
        //todo:logout
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.loginRoute, (route) => false);
        break;
    }
  }

  IconData getButtonIcon(ProfileButtonType buttonType){
    switch(buttonType){
      case ProfileButtonType.editProfile:
        return AppIcons.editProfileFa;

      case ProfileButtonType.likes:
        return AppIcons.heartSolidFa;

      case ProfileButtonType.myChallengesShares:
        return AppIcons.myChallengesSharesFa;

      case ProfileButtonType.settings:
        return AppIcons.settingsFa;

      case ProfileButtonType.about:
        return AppIcons.infoFa;

      case ProfileButtonType.logout:
        return AppIcons.logoutFa;
    }
  }

  String getButtonTitle(BuildContext context,ProfileButtonType buttonType){
    switch(buttonType){
      case ProfileButtonType.editProfile:
        return context.localization.editProfile;

      case ProfileButtonType.likes:
        return context.localization.likes;

      case ProfileButtonType.myChallengesShares:
        return context.localization.myChallenges;

      case ProfileButtonType.settings:
        return context.localization.appSetting;

      case ProfileButtonType.about:
        return context.localization.about;

      case ProfileButtonType.logout:
        return context.localization.logout;
    }
  }

  Color getIconColor(BuildContext context,ProfileButtonType buttonType){
    if(buttonType == ProfileButtonType.likes){
      return context.theme.redColor;
    }else if(buttonType == ProfileButtonType.logout){
      return context.theme.lightRed;
    }else{
      return context.theme.whiteColor;
    }
  }
}

enum ProfileButtonType{
  editProfile,
  likes,
  myChallengesShares,
  settings,
  about,
  logout,
}