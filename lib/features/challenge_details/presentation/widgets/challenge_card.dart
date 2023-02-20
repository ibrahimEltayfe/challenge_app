import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../home/presentation/manager/user_data_provider/user_data_provider.dart';
import '../../../reusable_components/bookmark_button.dart';
import '../manager/challenge_details_provider/challenge_details_provider.dart';

class ChallengeCard extends ConsumerWidget {
  const ChallengeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    ref.watch(userDataProvider.select((state) => state is UserDataFetched));
    final challengeDetailsState = ref.watch(challengeDetailsProvider);

    if(challengeDetailsState is ChallengeDetailsLoading){
      return Container(
        height: 390,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: context.theme.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: CircularProgressIndicator(color: context.theme.primaryColor,),
      );
    }else if(challengeDetailsState is ChallengeDetailsError){
      return Container(
        height: 390,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            border: Border.all(color: context.theme.primaryColor),
            borderRadius: const BorderRadius.all(Radius.circular(10))
        ),
        child: Text(
          challengeDetailsState.message,
          style: context.textTheme.titleMedium,
        ),
      );
    }else if(challengeDetailsState is ChallengeDetailsDataFetched){
      final challengeModel = ref.watch(challengeDetailsProvider.notifier).challengeModel;

      return SizedBox(
        height: 390,
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                child: Stack(
                  children: [
                    Placeholder(),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: BookmarkButton(
                        width: 40,
                        height: 40,
                        isActive: ref.watch(userDataProvider.notifier).isBookmarked(challengeModel.id!),
                        challengeId: challengeModel.id!,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                challengeModel.title!,
                style: context.textTheme.titleMedium!.copyWith(fontSize: 19),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();

  }
}