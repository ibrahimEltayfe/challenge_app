import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

extension ThemeHelper on BuildContext{
  ThemeData get theme => Theme.of(this);
  TextTheme get textTheme => Theme.of(this).textTheme;
}

extension CustomThemeColors on ThemeData{
  Color get skyBlueColor{
    return AppColors.skyBlue;
    /*if(brightness == Brightness.light){
     return AppColors.skyBlue;
   }else{

   }*/
  }

  Color get whiteColor{
    return AppColors.white;
  }

  Color get mediumOrangeColor{
    return AppColors.mediumOrange;
  }

  Color get lightRed{
    return AppColors.lightRed;
  }

  Color get redColor{
    return AppColors.red;
  }

  Color get darkGreyColor{
    return AppColors.darkGrey;
  }

  Color get greyColor{
    return AppColors.grey;
  }

  Color get lightGreyColor{
    return AppColors.lightGrey;
  }

  Color get darkBlueColor{
    return AppColors.darkBlue;
  }

  Color get lightOrangeColor{
    return AppColors.lightOrange;
  }

  Color get orangeColor{
    return AppColors.orange;
  }
}