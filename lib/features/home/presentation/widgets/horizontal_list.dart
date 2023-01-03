import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/reusable_components/challenge_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../reusable_components/bookmark_button.dart';

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
                  return ChallengeItem(
                    challengePoints: 10,
                    isBookmarkActive: false,
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

