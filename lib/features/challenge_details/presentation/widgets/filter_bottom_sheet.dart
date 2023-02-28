import 'dart:developer';

import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/data/models/filter_model.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/challenge_details_provider/challenge_details_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/challenge_response_provider/challenge_responses_provider.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/filter_provider/filter_provider.dart';
import 'package:chips_choice/chips_choice.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../../core/constants/app_icons.dart';
import '../../../reusable_components/action_button.dart';

class FilterButton extends StatelessWidget {

  const FilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () async{
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

class FilterBottomSheet extends  ConsumerWidget{
  const FilterBottomSheet({super.key});

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final filterState = ref.watch(filterProvider);

    if(filterState is FilterLoading){
      return SizedBox(
        width: context.width,
        height: 115,
        child: Center(
          child: CircularProgressIndicator(color: context.theme.primaryColor,),
        ),
      );
    }else if(filterState is FilterError){
      return SizedBox(
        width: context.width,
        height: 115,
        child: Center(
          child: Text(
            filterState.message,
            style: context.textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }else if(filterState is FilterDataFetched){
      if(filterState.filters.isEmpty){
        return SizedBox(
          width: context.width,
          height: 115,
          child: Center(
            child: Text(
              'no filters found.',
              style: context.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return SizedBox(
        width: context.width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Consumer(
              builder: (context, ref, child) {
                final filterTags = ref.watch(filterTagsProvider);
                ref.watch(selectedFiltersProvider);
                
                return ConstrainedBox(
                  constraints: const BoxConstraints(
                      minHeight: 115
                  ),
                  child: ChipsChoice<FilterModel>.multiple(
                    alignment:WrapAlignment.start ,
                    value: filterTags,
                    onChanged: (val){
                      ref.read(filterTagsProvider.notifier).state = val;
                    },
                    choiceItems: C2Choice.listFrom<FilterModel, FilterModel>(
                      source: filterState.filters,
                      value: (i, v) => v,
                      label: (i, v) => v.name!,
                    ),
                    wrapped: true,
                    textDirection: TextDirection.ltr,
                    choiceLabelBuilder: (item, i) {
                      return Text(
                        item.label,
                        style: context.textTheme.titleSmall!.copyWith(
                            color: item.selected?context.theme.whiteColor:context.theme.primaryColor
                        ),);
                    },

                    choiceStyle: C2ChipStyle.toned(
                      selectedStyle: C2ChipStyle.filled(
                        color: context.theme.primaryColor,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                );
              },
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: ActionButton(
                    title: context.localization.applyFilter,
                    height: 52,
                    width: 360,
                    onTap: (){
                      ref.watch(selectedFiltersProvider.notifier).state = ref.watch(filterTagsProvider);

                      final filters = ref.read(selectedFiltersProvider.notifier).state.map((e){
                        return e.id!;
                      }).toList();
                      final challengeId = ref.read(challengeDetailsProvider.notifier).challengeModel.id!;
                      final challengeResponseRef = ref.read(challengeResponseProvider(challengeId).notifier);

                      challengeResponseRef.reset();

                      if(filters.isEmpty){
                        challengeResponseRef.getChallengeResponses(challengeId);
                      }else{
                        challengeResponseRef.getFilteredChallengeResponses(challengeId, filters);
                      }

                      Navigator.pop(context);
                    }
                ),
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
