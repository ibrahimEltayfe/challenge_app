import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/like_container.dart';
import 'package:challenge_app/features/reusable_components/coins.dart';
import 'package:flutter/material.dart';

import '../widgets/profile_buttons.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const[
             SizedBox(height: 8,),
            _BuildTopBar(),

            SizedBox(height: 8,),
            _BuildBasicUserDetails(),

            SizedBox(height: 13,),
            //todo:pass user profile model
            ProfileButtons(),


          ],
        ),
      ),
    );
  }
}

class _BuildTopBar extends StatelessWidget {
  const _BuildTopBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: AlignmentDirectional.centerStart,
      children: [
        const Positioned(
          left: 10,
          child: Coins(numOfCoins: '10',),
        ),

        Center(child: Text('Profile',style: context.textTheme.titleLarge,)),
      ],
    );
  }
}


class _BuildBasicUserDetails extends StatelessWidget {
  const _BuildBasicUserDetails({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20,),
        SizedBox(
          width: 90,
          height: 90,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Placeholder(),
          ),
        ),

        const SizedBox(height: 8,),
        Text(
          'Ibrahim Eltayfe',
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),

        Text('Flutter Developer',style: context.textTheme.titleMedium!.copyWith(
          color: context.theme.greyColor,
          height: context.isRtl ? 1 : null,
          fontWeight: FontWeight.w500,
        ),),

        const SizedBox(height: 6,),
        LikeContainer(
         numOfLikes: 40,
          isActive: true,
          responseId: '',
          maxWidth: 75,
          maxHeight: 29,
        ),

        SizedBox(height: 20,),


      ],
    );
  }
}
