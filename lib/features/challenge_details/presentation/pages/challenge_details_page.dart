import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../reusable_components/back_button_shadow_box.dart';
import '../../../../reusable_components/bookmark_button.dart';
import '../widgets/challenge_responses_gridview.dart';

final slideAnimationProvider = StateProvider.autoDispose<double>((ref) => 0.0);
final showBackButtonProvider = StateProvider.autoDispose<bool>((ref) => false);

class ChallengeDetailsPage extends ConsumerStatefulWidget {
  const ChallengeDetailsPage({
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

    var slideAnim;
    var showBackButton;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      slideAnim = ref.watch(slideAnimationProvider.notifier);
      showBackButton = ref.watch(showBackButtonProvider.notifier);
    });

    scrollController.addListener(() {
      double endOffset = context.height * 0.35;

      if (scrollController.offset <= endOffset) {
        slideAnim.state = scrollController.offset;
      }

      if (scrollController.offset >= endOffset - context.width * 0.1) {
        showBackButton.state = true;
      } else {
        showBackButton.state = false;
      }
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    animation.dispose();
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: CustomScrollView(
            controller: scrollController,
            slivers: [
              //back button, challenge card
              SliverAppBar(
                backgroundColor: context.theme.backgroundColor,
                leading: SizedBox.shrink(),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(340),
                  child: Consumer(
                    builder: (context, ref, child) {
                      final slideAnimation = ref.watch(slideAnimationProvider);
                      return Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        textDirection: TextDirection.ltr,
                        children: [
                          Transform.translate(
                              offset: Offset(-slideAnimation, 0),
                              child: const BackButtonShadowBox()),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                              child: Transform.translate(
                                  offset: Offset(slideAnimation, 0),
                                  child: _BuildChallengeCard())),
                        ],
                      );
                    },
                  ),
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 20,
                ),
              ),

              //shares and filters
              SliverAppBar(
                backgroundColor: context.theme.backgroundColor,
                floating: false,
                pinned: true,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(40),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Consumer(
                            builder: (context, ref, child) {
                              final showBackButton =
                                  ref.watch(showBackButtonProvider);

                              return AnimatedSlide(
                                  duration: const Duration(milliseconds: 250),
                                  curve: Curves.ease,
                                  offset: Offset(
                                      showBackButton
                                          ? 0
                                          : -context.width * 0.02,
                                      0),
                                  child: showBackButton
                                      ? child!
                                      : SizedBox.shrink());
                            },
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const FaIcon(
                                  AppIcons.backArrowFa,
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
              ),

              const SliverToBoxAdapter(
                child: SizedBox(
                  height: 12,
                ),
              ),

              ChallengeResponsesGridView(),
            ],
          ),
        ),
      ),
    );
  }
}

class _BuildChallengeCard extends StatelessWidget {
  const _BuildChallengeCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 370,
          width: 360,
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
                      isActive: false,
                    ),
                 ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "Snowing Background",
            style: context.textTheme.titleMedium!.copyWith(fontSize: 19),
          ),
        ),
      ],
    );
  }
}

class _BuildSharesTitle extends StatelessWidget {
  const _BuildSharesTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 115,
      height: 40,
      child: FittedBox(
        child: Text.rich(TextSpan(
            text: "7",
            style: context.textTheme.titleMedium!
                .copyWith(color: context.theme.skyBlueColor),
            children: [
              TextSpan(text: " Shares", style: context.textTheme.titleMedium)
            ])),
      ),
    );
  }
}

class _BuildFilterButton extends StatelessWidget {
  const _BuildFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {},
        child: const FaIcon(
          AppIcons.filterFa,
          size: 25,
        ));
  }
}

class _ChosenFiltersHorizontalList extends StatelessWidget {
  const _ChosenFiltersHorizontalList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 28,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) => const SizedBox(
          width: 10,
        ),
        itemCount: 2,
        itemBuilder: (context, index) {
          return _BuildChosenFilterButton();
        },
      ),
    );
  }
}

class _BuildChosenFilterButton extends StatelessWidget {
  const _BuildChosenFilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Icon(
                Icons.close,
                size: 14,
                color: context.theme.whiteColor,
              ),
              const SizedBox(
                width: 4,
              ),
              Text(
                "flutter",
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



