import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_routes.dart';
import '../../../../core/constants/app_styles.dart';
import '../../../auth/presentation/widgets/back_arrow.dart';

class IdleSearchBar extends StatelessWidget {
  const IdleSearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.pushNamed(context, AppRoutes.searchRoute);
      },
      child: Hero(
        tag: 'search',
        child: ColoredBox(
          color: context.theme.whiteColor,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 14),
            child: Container(
              height: 60,
              decoration: shadowBoxDecoration(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(width: 20,),
                  const Icon(AppIcons.search,size: 30,),

                  const SizedBox(width: 13,),
                  VerticalDivider(color: context.theme.greyColor,width: 7,),

                  const SizedBox(width: 10,),

                  Text(context.localization.search,style: context.textTheme.labelMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),)

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}