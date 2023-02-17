import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/sliver_convertor.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/home/presentation/manager/regular_challenges_provider/regular_challenges_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sliver_tools/sliver_tools.dart' show MultiSliver, SliverPinnedHeader;
import '../../../reusable_components/challenge_item.dart';
import '../../data/models/challenge_model.dart';
import '../manager/user_data_provider/user_data_provider.dart';

class RegularChallengesSliverGrid extends ConsumerWidget {
  const RegularChallengesSliverGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final challengesState = ref.watch(regularChallengesProvider);
    final List<ChallengeModel> challenges = ref.watch(regularChallengesProvider.notifier).challengeModels;

    return MultiSliver(
      pushPinnedChildren: true,
      children: [
        SliverPinnedHeader(
          child: Container(
            decoration: BoxDecoration(
              color: context.theme.whiteColor,
              borderRadius: const BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15)
              )

            ),
            padding: const EdgeInsetsDirectional.symmetric(horizontal: 8,vertical: 8),
            child: Text("Challenges",style: context.textTheme.titleLarge,)
          ),
        ),

        SliverPadding(
          padding: const EdgeInsets.all(8.0),

          sliver: Consumer(
            builder: (context, ref, child) {
              ref.watch(userDataProvider.select((state) => state is UserDataFetched));
              final userData = ref.watch(userDataProvider.notifier).userModel;

              return SliverGrid.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  childAspectRatio: 0.72,
                  mainAxisSpacing:10,
                ),
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  final userLikes =  userData?.bookmarks ?? [];
                  final isBookmarked = userLikes.contains(challenges[index].id);

                  return ChallengeItem(
                    isBookmarkActive: isBookmarked,
                    challengeModel: challenges[index],
                  );
                },
              );
            },
          ),
        ),

        if(challengesState is RegularChallengesLoading)
         Center(
            child: CircularProgressIndicator(color: context.theme.primaryColor,),
         ).toSliver,

        if(challengesState is RegularChallengesError)
         _BuildErrorWidget(
             message: challengesState.message,
             onRefresh: (){
               ref.read(regularChallengesProvider.notifier).fetchChallenges();
             }
         ).toSliver
        ]
      );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRefresh;
  const _BuildErrorWidget({Key? key, required this.message, required this.onRefresh}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Column(
        children: [
          Text(
            message,
            style: context.textTheme.titleMedium!.copyWith(color: context.theme.redColor),
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: 5,),

          Expanded(
            child: InkWell(
              onTap: onRefresh,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: const Icon(AppIcons.refresh,size: 20,),
            ),
          )


        ],
      ),
    );
  }
}
