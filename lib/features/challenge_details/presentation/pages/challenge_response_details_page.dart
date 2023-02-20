import 'package:challenge_app/core/common/models/user_model.dart';
import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/data/models/challenge_response_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/specific_challenge_response_provider/specific_challenge_response_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/like_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/back_button_shadow_box.dart';
import '../widgets/user_details_card.dart';

class ChallengeResponseCardDetails extends ConsumerWidget {
  final String responseUserId;
  const ChallengeResponseCardDetails(this.responseUserId,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final challengeResponseState = ref.watch(specificChallengeResponseProvider(responseUserId));

    if(challengeResponseState is SpecificChallengeResponseLoading){
      return const _BuildLoadingWidget();
    }else if(challengeResponseState is SpecificChallengeResponseError){
      return _BuildErrorWidget(challengeResponseState.message);

    }else if(challengeResponseState is SpecificChallengeResponseDataFetched){
      final responseModel = ref.watch(specificChallengeResponseProvider(responseUserId).notifier).responseModel;

      return Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: [
                      const BackButtonBox(),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                          child: _BuildChallengeResponseCard(responseModel)
                      )
                    ],
                  ),
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 22,)),
                _BuildUserDetailsCard(
                  responseModel
                ),

                const SliverToBoxAdapter(child: SizedBox(height: 22,)),
                _BuildCodeSection(repositoryUrl:responseModel.repositoryUrl!)

              ],
            ),
          ),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

class _BuildChallengeResponseCard extends ConsumerWidget {
  final ChallengeResponseModel responseModel;
  const _BuildChallengeResponseCard(this.responseModel,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    return Column(
      children: [
        const SizedBox(
          height: 370,
          width: 360,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: Placeholder()
          ),
        ),
      ],
    );
  }
}

class _BuildUserDetailsCard extends StatelessWidget {
  final ChallengeResponseModel responseModel;
  const _BuildUserDetailsCard(this.responseModel,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      leading: const SizedBox.shrink(),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children:[
            Flexible(
              child: UserDetailsCard(
                width: double.infinity,
                height: 55,
                imageUrl: '',
                name: responseModel.userModel!.name!,
                title:  responseModel.userModel!.title!,
                nameFontSize: 19,
                titleFontSize: 15,
                imageSize: 55,
              ),
            ),

            LikeContainer(
              isActive: false,
              numOfLikes: responseModel.numOfLikes!,
            ),

            const SizedBox(width:10)
          ],
        ),
      ),
    );
  }
}

class _BuildCodeSection extends StatelessWidget {
  final String repositoryUrl;
  const _BuildCodeSection({Key? key, required this.repositoryUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Text(
              context.localization.code,style: context.textTheme.titleLarge,
            ),

            const SizedBox(height: 15,),

            _BuildGithubCard(repositoryUrl),

            const SizedBox(height: 9,),
            ActionButton(
                width: 380,
                height: 47,
                title: context.localization.exploreCode,
                onTap: (){
                  Navigator.pushNamed(context, AppRoutes.repositoryFileExplorerRoute);
                }
            )
          ],
        ),
    );
  }
}

class _BuildGithubCard extends StatelessWidget {
  final String repositoryUrl;
  const _BuildGithubCard(this.repositoryUrl,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color(0xfff3f3f3),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            textDirection: TextDirection.ltr,
            children: [
              const FaIcon(AppIcons.githubFa,size: 30,),

              const SizedBox(width: 10,),
              Text(
                  "Github",
                  style: context.textTheme.titleMedium
              ),
            ],
          ),

          const SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 12),
            child: Text(
              repositoryUrl,
              style: context.textTheme.titleMedium!.copyWith(
                  decoration: TextDecoration.underline
              ),
              textAlign: TextAlign.left,
            ),
          ),

          SizedBox(height: 4,),
        ],
      ),
    );
  }
}

class _BuildErrorWidget extends StatelessWidget {
  final String message;
  const _BuildErrorWidget(this.message,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Text(
          message,
          style: context.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class _BuildLoadingWidget extends StatelessWidget {
  const _BuildLoadingWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width: 40,
            height: 40,
            child: CircularProgressIndicator(color: context.theme.primaryColor,),
          ),
        ),
      ),
    );
  }
}
