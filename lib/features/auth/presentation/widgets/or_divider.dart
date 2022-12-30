import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

class OrDivider extends StatelessWidget {
  const OrDivider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width*0.86,
      child: Row(
        children: [
          Expanded(child: Divider(color: context.theme.darkGreyColor,)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.width*0.02),
            child:Text(
              context.localization.or,
              style: context.textTheme.titleSmall,
            ),
          ),
          Expanded(child: Divider(color: context.theme.darkGreyColor,)),

        ],
      ),
    );
  }
}
