import 'dart:developer';

import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/home/presentation/manager/user_data_provider/user_data_provider.dart';
import 'package:challenge_app/features/reusable_components/challenge_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/common/models/challenge_model.dart';

class HorizontalList extends StatelessWidget {
  final List<ChallengeModel> challengeModels;
  final bool isLoading;
  final String title;
  final bool Function(ScrollNotification) onNotification;
  const HorizontalList({
    required this.title,
    required this.challengeModels,
    required this.isLoading,
    Key? key, required this.onNotification,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8,horizontal: 10),
      child: SizedBox(
        width: context.width,
        height: 308,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(title,style: context.textTheme.titleLarge,),
                const SizedBox(width: 10,),
                if(isLoading)
                SizedBox(
                  width: 15,
                  height: 15,
                  child: FittedBox(
                    child: CircularProgressIndicator(
                      color: context.theme.primaryColor,
                      strokeWidth: 5,
                    ),
                  )
                )
              ],
            ),
            const SizedBox(height: 14,),

            Expanded(
              child: NotificationListener<ScrollNotification>(
              onNotification: (scrollNotification){
                return onNotification(scrollNotification);
              },
               child: Consumer(
                 builder: (_,ref,child) {
                   ref.watch(userDataProvider.select((state) => state is UserDataFetched));

                   return ListView.separated(
                     separatorBuilder: (context, i) => const SizedBox(width: 20,),
                     physics: const BouncingScrollPhysics(),
                     scrollDirection: Axis.horizontal,
                     itemCount: challengeModels.length,
                     itemBuilder: (context, i) {
                       final isBookmarked = ref.watch(userDataProvider.notifier).isBookmarked(challengeModels[i].id!);
                       return ChallengeItem(
                         challengeModel: challengeModels[i],
                         isBookmarkActive: isBookmarked,
                       );
                     },
                   );
                 }
               ),

             )
            )
          ],
        ),
      ),
    );
  }
}

