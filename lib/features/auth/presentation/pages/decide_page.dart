import 'dart:developer';

import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_routes.dart';

class DecidePage extends StatelessWidget {
  const DecidePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (_,AsyncSnapshot<User?> snapshot) {
          if(snapshot.connectionState == ConnectionState.active){
            if(snapshot.data?.uid != null){
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, AppRoutes.homeRoute);
              });
            }else{
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacementNamed(context, AppRoutes.loginRoute);
              });
            }
          }

          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: context.theme.primaryColor,
              ),
            ),
          );
        }

    );
  }
}
