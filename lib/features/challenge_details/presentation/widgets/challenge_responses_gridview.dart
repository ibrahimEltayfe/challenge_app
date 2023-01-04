import 'dart:developer';

import 'package:challenge_app/features/challenge_details/presentation/widgets/like_container.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/user_details_card.dart';
import 'package:flutter/material.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ChallengeResponsesGridView extends StatelessWidget {
  const ChallengeResponsesGridView({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.7,
          crossAxisSpacing: 10,
          mainAxisSpacing: 18
      ),
      delegate: SliverChildBuilderDelegate(childCount: 8, (_, int index) {
        return ChallengeRespondCard();
      }),
    );
  }
}


class ChallengeRespondCard extends StatelessWidget {
  const ChallengeRespondCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Column(
              children: const[
                _BuildResponseCard(),

                SizedBox(height: 10,),

                UserDetailsCard(
                  height: 40,
                  imageUrl: '',
                  name: "Ibrahim eltayfe",
                  title: 'Flutter Developer',
                )
              ],
            )
    );
  }
}

class _BuildResponseCard extends StatelessWidget {
  const _BuildResponseCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: LayoutBuilder(
        builder: (context,size) {
          return Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigator.pushNamed(context, AppRoutes.challengeRespondCardDetailsRoute);
                },
                child: Placeholder()
              ),

              Positioned(
                bottom: 0,

                child: Container(
                  width: size.maxWidth,
                  height: 29,
                  padding: const EdgeInsets.all(4),
                  color: Color(0x7ff2f2f2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    textDirection: TextDirection.ltr,
                    children: const [
                      SizedBox(width: 6,),
                      LikeContainer(
                        numOfLikes:40,
                        isActive:false
                      ),

                      SizedBox(width: 8,),
                      _BuildCardCategoryName(),

                      SizedBox(width: 10,)
                    ],
                  ),
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}

class _BuildCardCategoryName extends StatelessWidget {
  const _BuildCardCategoryName({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: Alignment.centerRight,

        child: Text(
          "Flutter",
          style: context.textTheme.titleSmall!.copyWith(
              color: context.theme.greyColor,
          ),

          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
        ),
      ),
    );
  }
}

