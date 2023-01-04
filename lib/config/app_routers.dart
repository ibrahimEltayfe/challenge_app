import 'package:challenge_app/features/auth/presentation/pages/email_verification_check_page.dart';
import 'package:challenge_app/features/auth/presentation/pages/forgot_password.dart';
import 'package:challenge_app/features/auth/presentation/pages/register.dart';
import 'package:challenge_app/features/auth/presentation/pages/setup_profile.dart';
import 'package:challenge_app/features/challenge_details/presentation/pages/challenge_details_page.dart';
import 'package:challenge_app/features/challenge_details/presentation/pages/repository_file_explorer.dart';
import 'package:challenge_app/features/home/presentation/pages/search_Page.dart';
import 'package:challenge_app/features/profile/presentation/pages/about.dart';
import 'package:challenge_app/features/profile/presentation/pages/app_settings.dart';
import 'package:challenge_app/features/profile/presentation/pages/user_likes_page.dart';
import 'package:challenge_app/features/profile/presentation/pages/user_shared_challenges.dart';
import 'package:flutter/material.dart';
import '../core/constants/app_routes.dart';
import '../features/auth/presentation/pages/decide_page.dart';
import '../features/auth/presentation/pages/login.dart';
import '../features/challenge_details/presentation/pages/challenge_response_details.dart';
import '../features/home/presentation/pages/home_base.dart';

class RoutesManager{

  static Route<dynamic> routes(RouteSettings settings){
    switch(settings.name){
      case AppRoutes.homeRoute:
        return MaterialPageRoute(
            builder: (_)=> HomeBase(),
            settings: settings
        );

      case AppRoutes.decideRoute:
        return MaterialPageRoute(
            builder: (_)=> DecidePage(),
            settings: settings
        );

      case AppRoutes.loginRoute:
        return MaterialPageRoute(
            builder: (_)=> LoginPage(),
            settings: settings
        );

      case AppRoutes.registerRoute:
        return MaterialPageRoute(
            builder: (_)=> RegisterPage(),
            settings: settings
        );

      case AppRoutes.forgotPasswordRoute:
        return MaterialPageRoute(
            builder: (_)=> ForgotPasswordPage(),
            settings: settings
        );

      case AppRoutes.emailVerificationCheckRoute:
        return MaterialPageRoute(
            builder: (_)=> EmailVerificationCheckPage(),
            settings: settings
        );

      case AppRoutes.editProfileRoute:
        return MaterialPageRoute(
            builder: (_)=> SetupProfilePage(),
            settings: settings
        );

      case AppRoutes.userLikesRoute:
        return MaterialPageRoute(
            builder: (_)=> UserLikesPagePage(),
            settings: settings
        );

      case AppRoutes.userSharedChallengesRoute:
        return MaterialPageRoute(
            builder: (_)=> UserSharedChallengesPage(),
            settings: settings
        );

      case AppRoutes.repositoryFileExplorerRoute:
        return MaterialPageRoute(
            builder: (_)=> RepositoryFileExplorerPage(),
            settings: settings
        );

      case AppRoutes.appSettingsRoute:
        return MaterialPageRoute(
            builder: (_)=> AppSettingsPage(),
            settings: settings
        );

      case AppRoutes.aboutRoute:
        return MaterialPageRoute(
            builder: (_)=> AboutPage(),
            settings: settings
        );

      case AppRoutes.challengeDetailsRoute:
        return MaterialPageRoute(
            builder: (_)=> ChallengeDetailsPage(),
            settings: settings
        );

      case AppRoutes.challengeRespondCardDetailsRoute:
        return MaterialPageRoute(
            builder: (_)=> ChallengeResponseCardDetails(),
            settings: settings
        );

      case AppRoutes.searchRoute:
        return MaterialPageRoute(
            builder: (_)=> SearchPage(),
            settings: settings
        );


      default: return MaterialPageRoute(
          builder: (_)=> UnExcepectedErrorPage(),
          settings: settings
      );
    }

  }
}

//todo:
class UnExcepectedErrorPage extends StatelessWidget {
  const UnExcepectedErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('UnExcepected Error'),
      ),
    );
  }
}

