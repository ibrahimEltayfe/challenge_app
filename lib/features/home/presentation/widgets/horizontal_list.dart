import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/reusable_components/bookmark_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HorizontalList extends ConsumerWidget {
  final String title;
  const HorizontalList({
    required this.title,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      child: SizedBox(
        width: context.width,
        height: 308,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title,style: context.textTheme.titleLarge,),
            const SizedBox(height: 14,),

            Expanded(
              child: ListView.separated(
                separatorBuilder: (context, index) => const SizedBox(width: 20,),
                scrollDirection: Axis.horizontal,
                itemCount: 2,
                itemBuilder: (context, index) {
                  return _BuildItem();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _BuildItem extends StatelessWidget {
  const _BuildItem({Key? key}) : super(key: key);

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

          _BuildPoints(points: 10),

          PositionedDirectional(
            top: 5,
            end: 5,
            child: BookmarkButton(isActive: false,)
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
        constraints: const BoxConstraints(maxWidth: 165),
        padding: EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: context.theme.mediumOrangeColor,
        ),

        child: FittedBox(
          child: Text(
            '$points points',
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
