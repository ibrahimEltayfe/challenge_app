import 'dart:developer';

import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/auth/presentation/manager/social_login_provider/social_login_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../reusable_components/error_toast.dart';

class SocialButtons extends ConsumerWidget {
  const SocialButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    ref.listen(socialLoginProvider, (previous, current) {
      if(current is SocialLoginError){
        showErrorToast(context,current.message);
      }else if(current is SocialLoginSuccess){
        Navigator.pushNamedAndRemoveUntil(context, AppRoutes.homeRoute, (route) => false);
      }
    });

    if(ref.watch(socialLoginProvider) is SocialLoginLoading){
      return Lottie.asset(
        "assets/lottie/loading_black.json",
        width: 55,
        height: 55,
        fit: BoxFit.contain,
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _BuildSocialCircle(
          onTap: () async{
            await ref.read(socialLoginProvider.notifier).loginWithGoogle();
          },
          icon:AppIcons.googleFa,
        ),

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
