import 'dart:developer';

import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/challenge_details_provider/challenge_details_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/challenge_response_provider/challenge_responses_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/like_container.dart';
import 'package:challenge_app/features/challenge_details/presentation/widgets/user_details_card.dart';
import 'package:flutter/material.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sliver_tools/sliver_tools.dart';

import '../../data/models/challenge_response_model.dart';

class ChallengeResponsesGridView extends ConsumerWidget {
  final String challengeId;
  const ChallengeResponsesGridView({super.key,required this.challengeId});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final challengeResponseState = ref.watch(challengeResponseProvider(challengeId));
    final challengeResponseRef = ref.watch(challengeResponseProvider(challengeId).notifier);

    if(challengeResponseState is ChallengeResponseDataFetched && challengeResponseRef.responses.isEmpty){
      return _BuildInfoText(context.localization.noShares);
    }

    return MultiSliver(
      children: [
        if(challengeResponseState is ChallengeResponseDataFetched)
        SliverGrid(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.7,
              crossAxisSpacing: 10,
              mainAxisSpacing: 18
          ),
          delegate: SliverChildBuilderDelegate(childCount: challengeResponseRef.responses.length, (_,index) {
            return ChallengeRespondCard(challengeResponseRef.responses[index]);
          }),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(
            height: 15,
          ),
        ),

        if(challengeResponseState is ChallengeResponseLoading)
          SliverToBoxAdapter(
            child: SizedBox(
              width: 40,
              height: 40,
              child: FittedBox(child: CircularProgressIndicator(color: context.theme.primaryColor,))
            ),
          )

        else if(challengeResponseState is ChallengeResponseError)
          _BuildInfoText(challengeResponseState.message,)

      ],
    );
  }
}


class ChallengeRespondCard extends ConsumerWidget {
  final ChallengeResponseModel responseModel;
  const ChallengeRespondCard(this.responseModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {

    return ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(15)),
        child: Column(
              children:[
                _BuildResponseCard(responseModel),

                const SizedBox(height: 10,),

                UserDetailsCard(
                  height: 40,
                  imageUrl: responseModel.userModel!.image!,
                  name: responseModel.userModel!.name!,
                  title: responseModel.userModel!.title!,
                )
              ],
            )
    );
  }
}

class _BuildResponseCard extends ConsumerWidget {
  final ChallengeResponseModel response;
  const _BuildResponseCard(this.response, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    return Expanded(
      flex: 5,
      child: LayoutBuilder(
        builder: (context,size) {
          return Stack(
            children: [
              GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: (){
                  Navigator.pushNamed(
                      context,
                      AppRoutes.challengeRespondCardDetailsRoute,
                      arguments: response.id
                  );
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
                    children: [
                      const SizedBox(width: 6,),
                      LikeContainer(
                        numOfLikes:response.numOfLikes!,
                        isActive:false
                      ),

                      SizedBox(width: 8,),
                      _BuildCardCategoryName(),//todo:

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

class _BuildInfoText extends StatelessWidget {
  final String text;
  const _BuildInfoText(this.text,{Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Center(
        child: Text(
          text,
          style: context.textTheme.titleMedium,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
