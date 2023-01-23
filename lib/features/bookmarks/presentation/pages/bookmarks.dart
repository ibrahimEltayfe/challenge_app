import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/reusable_components/challenge_item.dart';
import 'package:flutter/material.dart';

class Bookmarks extends StatelessWidget {
  const Bookmarks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(height: 10,),
            Center(
              child: Text(
                'Bookmarks',
                style: context.textTheme.titleLarge,
              )
            ),

            SizedBox(height: 6,),
            _BuildBookmarkItems()
          ],
        ),
      ),
    );
  }
}

class _BuildBookmarkItems extends StatelessWidget {
  const _BuildBookmarkItems({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        padding: EdgeInsets.all(8),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 6,
            childAspectRatio: 0.75,
            mainAxisSpacing:6,
          ),
          itemCount: 6,
          itemBuilder: (context, index) {
            return ChallengeItem(
              isBookmarkActive: true,
              challengePoints: 10,
            );
          },
      ),
    );
  }
}
