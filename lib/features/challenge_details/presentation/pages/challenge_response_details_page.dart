import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/like_container.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../reusable_components/action_button.dart';
import '../../../reusable_components/back_button_shadow_box.dart';
import '../widgets/user_details_card.dart';

class ChallengeResponseCardDetails extends StatelessWidget {
  const ChallengeResponseCardDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                 children: const [
                    BackButtonShadowBox(),
                    SizedBox(
                     width: 10,
                   ),
                   Expanded(
                       child: _BuildChallengeResponseCard()
                   )
                  ],
                 ),
              ),

              SliverToBoxAdapter(child: SizedBox(height: 22,)),
              _BuildUserDetailsCard(),

              SliverToBoxAdapter(child: SizedBox(height: 22,)),
              _BuildCodeSection()

            ],
          ),
        ),
      ),

    );
  }
}

class _BuildChallengeResponseCard extends StatelessWidget {
  const _BuildChallengeResponseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
        Align(
          alignment: Alignment.topLeft,
          child: Text(
            "Snowing Background",
            style: context.textTheme.titleMedium!.copyWith(fontSize: 19),
          ),
        ),
      ],
    );
  }
}

class _BuildUserDetailsCard extends StatelessWidget {
  const _BuildUserDetailsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      backgroundColor: context.theme.backgroundColor,
      leading: const SizedBox.shrink(),

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: const[
            Flexible(
              child: UserDetailsCard(
                width: double.infinity,
                height: 55,
                imageUrl: '',
                name: "Ibrahim eltayfe",
                title: 'Flutter Developer',
                nameFontSize: 19,
                titleFontSize: 15,
                imageSize: 55,
              ),
            ),
            LikeContainer(
              isActive: false,
              numOfLikes: 40,
            ),
            SizedBox(width:10)
          ],
        ),
      ),
    );
  }
}

class _BuildCodeSection extends StatelessWidget {
  const _BuildCodeSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          textDirection: TextDirection.ltr,
          children: [
            Text(
              "Code",style: context.textTheme.titleLarge,
            ),

            SizedBox(height: 15,),

            _BuildGithubCard(),

            const SizedBox(height: 9,),
            ActionButton(
                width: 380,
                height: 47,
                title: 'Explore Code',
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
  const _BuildGithubCard({Key? key}) : super(key: key);

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
              FaIcon(AppIcons.githubFa,size: 30,),

              SizedBox(width: 10,),
              Text(
                  "Github",
                  style: context.textTheme.titleMedium
              ),
            ],
          ),

          SizedBox(height: 10,),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Text(
              "https://github.com/ibrahimeltayfe/weather-app",
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
