import 'package:challenge_app/core/constants/app_strings.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_icons.dart';

class LikeContainer extends StatelessWidget {
  final int numOfLikes;
  final bool isActive;
  final double maxWidth;
  const LikeContainer({
    Key? key,
    required this.numOfLikes,
    required this.isActive,
    this.maxWidth = 75
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      textDirection: TextDirection.ltr,
      children: [
        FittedBox(
          child: FaIcon(
          isActive
          ?AppIcons.heartSolidFa
            :AppIcons.heartOutlineFa,
            color: context.theme.redColor,
          ),
        ),

        const SizedBox(width: 4,),
        ConstrainedBox(
          constraints: BoxConstraints(
              maxWidth: maxWidth,
              minWidth: 25,
          ),

          child: Text(
            '$numOfLikes',
            style: context.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.clip,
            softWrap: false,
            textDirection: TextDirection.ltr,
          ),
        )
      ],
    );
  }
}

