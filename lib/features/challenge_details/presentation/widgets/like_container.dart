import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../core/constants/app_icons.dart';

class LikeContainer extends StatelessWidget {
  final int numOfLikes;
  final bool isActive;
  const LikeContainer({
    Key? key,
    required this.numOfLikes,
    required this.isActive
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
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

        SizedBox(width: 4,),
        ConstrainedBox(
          constraints: const BoxConstraints(
              maxWidth: 75,
              minWidth: 25
          ),

          child: Text(
            '$numOfLikes',
            style: context.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            textDirection: TextDirection.ltr,
          ),
        )
      ],
    );
  }
}

