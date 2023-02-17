import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_styles.dart';
import '../../../auth/presentation/widgets/back_arrow.dart';

class SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const SearchBar({
    Key? key,
    required this.controller
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search',

      child: Material(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Container(
            height: 60,
            decoration: shadowBoxDecoration(context),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(width: 20,),
                GestureDetector(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    AppIcons.leftBackArrowFa,
                    size: 24,
                  ),
                ),

                const SizedBox(width: 13,),
                VerticalDivider(color: context.theme.greyColor,width: 7,),

                const SizedBox(width: 10,),

                Expanded(
                  child: _BuildTextField(
                    controller: controller,
                  ),
                ),

                const SizedBox(width: 10,),

              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  const _BuildTextField({Key? key,required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: context.textTheme.labelMedium!.copyWith(
        fontWeight: FontWeight.normal,
        color: context.theme.primaryColor
      ),

      cursorColor: context.theme.primaryColor,
      maxLines: 1,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Search",
        hintStyle: context.textTheme.labelMedium!.copyWith(
          fontWeight: FontWeight.normal,
        ),

        border: InputBorder.none
      ),
    );
  }
}
