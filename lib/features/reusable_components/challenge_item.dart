import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_routes.dart';
import 'bookmark_button.dart';

class ChallengeItem extends StatelessWidget {
  final bool isBookmarkActive;
  final int challengePoints;
  const ChallengeItem({
    Key? key,
    required this.isBookmarkActive,
    required this.challengePoints
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 228,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Stack(
        children: [
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: (){
                Navigator.pushNamed(context, AppRoutes.challengeDetailsRoute);
              },
              child: Placeholder()
          ),

          _BuildPoints(points: challengePoints),

          PositionedDirectional(
              top: 5,
              end: 5,
              child: BookmarkButton(isActive: isBookmarkActive,)
          ),

          _BuildChallengeName(
              name:'Snowing Background'
          )

        ],
      ),
    );
  }
}

class _BuildPoints extends StatelessWidget {
  final int points;
  const _BuildPoints({Key? key, required this.points}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      top: 5,
      start: 5,
      child: Container(
        height: 28,
        constraints: const BoxConstraints(maxWidth: 165, minWidth: 54),
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.theme.mediumOrangeColor,
        ),

        child: FittedBox(
          child: Text(
            '$points ${context.localization.points}',
            style: context.textTheme.titleSmall,
          ),
        ),
      ),
    );
  }
}

class _BuildChallengeName extends StatelessWidget {
  final String name;
  const _BuildChallengeName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 28,
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
          color: Color(0x99ffffff),
        ),
        child: Text(
          name,
          style: context.textTheme.titleMedium,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
