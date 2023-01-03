import 'dart:ui';

import 'package:challenge_app/core/constants/app_colors.dart';
import 'package:challenge_app/core/constants/app_strings.dart';
import 'package:flutter/material.dart';

class AppThemes{
  static ThemeData lightTheme(BuildContext context){
    return ThemeData(
      scaffoldBackgroundColor:AppColors.backgroundColor ,
      backgroundColor: AppColors.backgroundColor,
      primaryColor: AppColors.primaryColor,
      shadowColor: AppColors.lightGrey,
      /* -the rest of colors are in theme extension- */

      fontFamily: window.locale.languageCode == 'ar'? AppStrings.dubaiFont: AppStrings.senFont,

      textTheme: TextTheme(

        displayLarge: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: window.locale.languageCode == 'ar'? AppStrings.dubaiFont: AppStrings.junegullFont,
            fontSize: 52
        ),

        displayMedium: TextStyle(
            color: AppColors.darkGrey,
            fontFamily: window.locale.languageCode == 'ar'? AppStrings.dubaiFont: AppStrings.bergenFont,
            fontSize: 32
        ),

        /* - bold text styles - */
        titleLarge: const TextStyle(
            color: AppColors.primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 25
        ),

        titleMedium: const TextStyle(
          color: AppColors.primaryColor,
          fontSize: 17,
          fontWeight: FontWeight.bold,
        ),

        titleSmall: const TextStyle(
          color: AppColors.primaryColor,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),

        /* - for text field labels - */
        labelMedium: const TextStyle(
          color: AppColors.grey,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),

        /* - for buttons - */
        headlineSmall: const TextStyle(
          color: AppColors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),

      ),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.backgroundColor,
        elevation: 2,
        selectedItemColor:AppColors.primaryColor,
        unselectedItemColor: AppColors.lightGrey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ) ,
    );
  }
}
