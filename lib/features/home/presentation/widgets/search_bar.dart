import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search',
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 9),
        child: Container(
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            boxShadow: [
              BoxShadow(
                color: context.theme.lightGreyColor,
                blurRadius: 11,
                offset: const Offset(2, 4),
              ),
            ],
            color: Colors.white,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(width: 20,),
              const Icon(AppIcons.search,size: 30,),

              const SizedBox(width: 13,),
              VerticalDivider(color: context.theme.greyColor,),

              const SizedBox(width: 10,),
              Text(context.localization.search,style: context.textTheme.labelMedium!.copyWith(
                fontWeight: FontWeight.normal,
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
