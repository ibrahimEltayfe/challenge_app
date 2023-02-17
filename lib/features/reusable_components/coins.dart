import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../core/constants/app_images.dart';

class Coins extends StatelessWidget {
  final String numOfCoins;
  const Coins({Key? key, required this.numOfCoins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 105
          ),

          child: Text(
            '$numOfCoins',
            style: context.textTheme.titleSmall,
            maxLines: 1,
            overflow: TextOverflow.fade,
            softWrap: false,
            textDirection: TextDirection.ltr,
          ),
        ),
        const SizedBox(width: 4,),
        SvgPicture.asset(AppImages.coins,width: 22,height: 25,),
      ],
    );
  }
}
