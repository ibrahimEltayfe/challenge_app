import 'dart:developer';
import 'package:challenge_app/config/providers.dart';
import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/data/models/filter_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/challenge_details_provider/challenge_details_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/challenge_response_provider/challenge_responses_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/filter_provider/filter_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/challenge_card.dart';
import 'package:challenge_app/features/reusable_components/action_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../reusable_components/back_button_shadow_box.dart';
import '../widgets/challenge_responses_gridview.dart';
import '../widgets/filter_bottom_sheet.dart';

final slideAnimationProvider = StateProvider.autoDispose<double>((ref){
  //i did this because first widget to build is loading widget and it did not have any
  //listeners for this state provider, so the provider disposes this state,
  //and it cause error in init state
  //but now i keep it alive and dispose it manually in dispose function

  final a = ref.keepAlive();
  ref.onDispose(() {a.close();});
  return 0.0;
});
final showBackButtonProvider = StateProvider.autoDispose<bool>((ref){
  final a = ref.keepAlive();
  ref.onDispose(() {a.close();});
  return false;
});

class ChallengeDetailsPage extends ConsumerStatefulWidget {
  final String id;
  const ChallengeDetailsPage(this.id, {
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState createState() => _ChallengeDetailsPageState();
}

class _ChallengeDetailsPageState extends ConsumerState<ChallengeDetailsPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController animationController;
  late final CurvedAnimation animation;
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    animation =
        CurvedAnimation(parent: animationController, curve: Curves.decelerate);

    late StateController<double> slideAnim;
    late StateController<bool> showBackButton;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(challengeDetailsProvider.notifier).getChallengeDetails(widget.id);

      slideAnim = ref.watch(slideAnimationProvider.notifier);
      showBackButton = ref.watch(showBackButtonProvider.notifier);
    });

    scrollController.addListener(() {
      double endOffset = context.height * 0.35;

      if (scrollController.offset <= endOffset) {
        slideAnim.state = scrollController.offset;
      }

      if (scrollController.offset >= endOffset - context.height * 0.25) {
        showBackButton.state = true;
      } else {
        showBackButton.state = false;
      }
    });

  }

  @override
  void dispose() {
    ref.invalidate(slideAnimationProvider);
    ref.invalidate(showBackButtonProvider);
    animationController.dispose();
    animation.dispose();
    scrollController.dispose();


    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengeDetailsState = ref.watch(challengeDetailsProvider);

    if(challengeDetailsState is ChallengeDetailsLoading){
      return Scaffold(
        body: SafeArea(
          child: Center(
             child: SizedBox(
               width: 40,
               height: 40,
               child: FittedBox(child: CircularProgressIndicator(color: context.theme.primaryColor,))
             )
          ),
        ),
      );
    }else if(challengeDetailsState is ChallengeDetailsError){
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Text(
              challengeDetailsState.message,
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }else if(challengeDetailsState is ChallengeDetailsDataFetched) {
      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: Stack(
                children: [
                  CustomScrollView(
                    controller: scrollController,
                    slivers: [
                      const _BuildBackButtonAndChallengeCard(),

                      const _BuildSeparator(20),
                      const _BuildSharesBar(),

                      const _BuildSeparator(12),
                      ChallengeResponsesGridView(
                          challengeId: widget.id
                      ),

                      const _BuildSeparator(100),
                    ],
                  ),

                  Positioned(
                    right: 0,
                    bottom: 4,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                          minWidth: 170
                      ),
                      child: ActionButton(
                        onTap: () {
                          //todo:navigate to share work page
                          Navigator.pushNamed(context, AppRoutes
                              .addChallengeResponseRoute);
                        },
                        title: context.localization.shareYourCreativity,
                        height: 54,
                        width: double.infinity,
                        cornerRadius: 15,
                      ),
                    ),
                  )
                ]

            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
class _BuildSeparator extends StatelessWidget {
  final double height;
  const _BuildSeparator(this.height,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: SizedBox(
        height: height,
      ),
    );
  }
}

class _BuildBackButtonAndChallengeCard extends ConsumerWidget {
  const _BuildBackButtonAndChallengeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    return SliverAppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: const SizedBox.shrink(),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(340),
        child: Consumer(
          builder: (context, ref, child) {
            final slideAnimation = ref.watch(slideAnimationProvider);
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              textDirection: TextDirection.ltr,
              children: [
                Transform(
                    alignment: AlignmentDirectional.centerStart,
                    transform: Matrix4.translationValues(-slideAnimation, 0, 0),
                    child: const BackButtonBox()
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Transform(
                      alignment: AlignmentDirectional.centerStart,
                      transform: Matrix4.translationValues(slideAnimation, 0, 0),
                      child: const ChallengeCard()
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}


/* filter and share title bar*/
class _BuildSharesBar extends StatelessWidget {
  const   _BuildSharesBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      floating: false,
      pinned: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(32),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Consumer(
                  builder: (context, ref, child) {
                    final showBackButton =
                    ref.watch(showBackButtonProvider);

                    return AnimatedSlide(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.ease,
                        offset: Offset(showBackButton ? 0 : -context.width * 0.02, 0),
                        child: showBackButton
                            ? child!
                            : SizedBox.shrink());
                  },
                  child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: FaIcon(
                        context.isRtl
                            ? AppIcons.rightBackArrowFa
                            :AppIcons.leftBackArrowFa,
                        size: 22,
                      )),
                ),
                const SizedBox(
                  width: 7,
                ),
                const _BuildSharesTitle(),
                const Spacer(),
                const _BuildFilterButton()
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            const _ChosenFiltersHorizontalList(),
            const SizedBox(
              height: 12,
            ),
          ],
        ),
      ),
    );
  }
}

class _BuildSharesTitle extends ConsumerWidget {
  const _BuildSharesTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return SizedBox(
      height: 32,
      child: FittedBox(
        fit: BoxFit.fitWidth,
        child: Consumer(
          builder: (context, ref, child) {
            final challengeId = ref.read(challengeDetailsProvider.notifier).challengeModel.id!;
            final challengeResponseState = ref.watch(challengeResponseProvider(challengeId));

            String numOfShares = '..';
            double opacity = 0;

            if(challengeResponseState is ChallengeResponseDataFetched){
              numOfShares = ref.watch(challengeResponseProvider(challengeId).notifier).responses.length.toString();
              opacity = 1;
            }else{
              opacity = 0;
            }

            return Row(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 300),
                  opacity: opacity,
                  child: Text(
                    numOfShares,
                    style: context.textTheme.titleMedium!
                        .copyWith(color: context.theme.skyBlueColor),
                  ),
                ),

                child!

              ],
            );
          },
          child:  Text(
              " ${context.localization.submits}",
              style: context.textTheme.titleMedium
          ),
        )
      ),
    );
  }
}

class _BuildFilterButton extends StatelessWidget {
  const _BuildFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Scaffold.of(context).showBottomSheet((_){
            return const FilterBottomSheet();
          });
        },
        child: const FaIcon(
          AppIcons.filterFa,
          size: 25,
        ));
  }
}

class _ChosenFiltersHorizontalList extends ConsumerWidget {
  const _ChosenFiltersHorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final selectedFilters = ref.watch(selectedFiltersProvider);

    return AnimatedContainer(
      height: selectedFilters.isEmpty?0:28,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: selectedFilters.length,
        itemBuilder: (context, index) {
          return _BuildChosenFilterButton(
              selectedFilters[index],
          );
        },
      ),
    );
  }
}

class _BuildChosenFilterButton extends ConsumerWidget {
  final FilterModel filterModel;
  const _BuildChosenFilterButton(this.filterModel,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(15)),
      child: ColoredBox(
        color: context.theme.primaryColor,
        child: SizedBox(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: 5,
              ),
              InkWell(
                onTap:() async{
                  ref.read(selectedFiltersProvider.notifier).state =
                      List.from(ref.read(selectedFiltersProvider.notifier).state..remove(filterModel));

                  final challengeId = ref.read(challengeDetailsProvider.notifier).challengeModel.id;
                  final challengeResponseRef = ref.read(challengeResponseProvider(challengeId!).notifier);
                  final List<String> filters = ref.watch(selectedFiltersProvider).map((e) => e.id!).toList();

                  challengeResponseRef.reset();

                  if(filters.isEmpty){
                    challengeResponseRef.getChallengeResponses(challengeId);
                  }else{
                    challengeResponseRef.getFilteredChallengeResponses(challengeId, filters);
                  }

                },
                child: Icon(
                  Icons.close,
                  size: 14,
                  color: context.theme.whiteColor,
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                filterModel.name!,
                style: context.textTheme.titleSmall!
                    .copyWith(color: context.theme.whiteColor),
              ),
              const SizedBox(
                width: 11,
              ),
            ],
          ),
        ),
      ),
    );
  }
}