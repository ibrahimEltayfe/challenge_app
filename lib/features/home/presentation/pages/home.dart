import 'dart:developer';
import 'dart:ui';
import 'package:challenge_app/core/constants/app_lottie.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/sliver_convertor.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/home/presentation/manager/trendy_challenges_provider/trendy_challenges_provider.dart';
import 'package:challenge_app/features/home/presentation/manager/user_data_provider/user_data_provider.dart';
import 'package:challenge_app/features/home/presentation/widgets/regular_challenges_gridview.dart';
import 'package:challenge_app/features/reusable_components/error_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../reusable_components/coins.dart';
import '../manager/new_challenges_provider/new_challenges_provider.dart';
import '../manager/regular_challenges_provider/regular_challenges_provider.dart';
import '../widgets/fire_ball.dart';
import '../widgets/idle_search_bar.dart';
import '../widgets/horizontal_list.dart';

class Home extends ConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      body: SafeArea(
        child: NotificationListener<ScrollNotification>(
          onNotification: (scrollNotification){
            return ref.read(regularChallengesProvider.notifier).handleScrollPagination(
                scrollNotification,
                context.height*0.1
            );
          },
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const _AppBar().toSliver,

              const IdleSearchBar().toSliver,

              _BuildTrendyChallenges().toSliver,

              _BuildNewChallenges().toSliver,

              const RegularChallengesSliverGrid()

            ]
          ),
        ),
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        ref.listen(userDataProvider, (previous, current) {
          if(current is UserDataError){
            showErrorToast(context, current.message);
          }
        });

        final userDataState = ref.watch(userDataProvider);
        final userDataRef = ref.watch(userDataProvider.notifier);

        String name = '..';
        String points = '..';

        if(userDataState is UserDataFetched){
          name = userDataRef.userModel!.name!;
          points = userDataRef.userModel!.points!.toString();
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 85,
            child: Stack(
              children:[
                child!,
                _BuildUserName(name: name),
                PositionedDirectional(
                  end: 0,
                  top: 13,
                  child: Coins(numOfCoins: points),
                )

              ],
            ),
          ),
        );
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          _BuildWelcomeText(),
          FireBall(),
        ],
      ),
    );
  }
}

class _BuildWelcomeText extends StatelessWidget {
  const _BuildWelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      context.localization.welcome,
      style: context.textTheme.displayMedium,
    );
  }
}

class _BuildUserName extends StatelessWidget {
  final String name;
  const _BuildUserName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        child: Text(name,style: context.textTheme.titleLarge!.copyWith(
          fontWeight: window.locale.languageCode == 'ar' ? FontWeight.w500 : FontWeight.w700,
        ),)
    );
  }
}

class _BuildTrendyChallenges extends ConsumerWidget {
  const _BuildTrendyChallenges({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final trendyChallengeState = ref.watch(trendyChallengesProvider);
    final trendyChallengesRef = ref.watch(trendyChallengesProvider.notifier);

    if(trendyChallengesRef.challengeModels.isEmpty){
      return const SizedBox.shrink();
    }

    return HorizontalList(
      title: context.localization.trending,
      isLoading: trendyChallengeState is TrendyChallengesLoading,
      challengeModels: trendyChallengesRef.challengeModels,
      onNotification: (scrollNotification){
        return trendyChallengesRef.handleScrollPagination(scrollNotification, context.width*0.3);
      },
    );
  }
}

class _BuildNewChallenges extends ConsumerWidget {
  const _BuildNewChallenges({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newChallengeState = ref.watch(newChallengesProvider);
    final newChallengesRef = ref.watch(newChallengesProvider.notifier);

    if(newChallengesRef.challengeModels.isEmpty){
      return const SizedBox.shrink();
    }

    return HorizontalList(
      title: context.localization.news,
      isLoading: newChallengeState is NewChallengesLoading,
      challengeModels: newChallengesRef.challengeModels,
      onNotification: (scrollNotification){
        return newChallengesRef.handleScrollPagination(scrollNotification, context.width*0.3);
      },
    );
  }
}