import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
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

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({Key? key}) : super(key: key);

  @override
  State<FilterBottomSheet> createState() => FilterBottomSheetState();
}

class FilterBottomSheetState extends State<FilterBottomSheet> {

  /*
  todo:get filter data from firebase
  check this example: https://pub.dev/packages/chips_choice/example
  */

  List<String> tags = [];
  List<String> options = [
    'Flutter', 'Css', 'HTML', 'JavaScript',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: context.width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(
                minHeight: 115
            ),
            child: ChipsChoice<String>.multiple(
              alignment:WrapAlignment.start ,
              value: tags,
              onChanged: (val) => setState(() => tags = val),
              choiceItems: C2Choice.listFrom<String, String>(
                source: options,
                value: (i, v) => v,
                label: (i, v) => v,
              ),
              wrapped: true,
              textDirection: TextDirection.ltr,
              choiceLabelBuilder: (item, i) {
                return Text(item.value,style: context.textTheme.titleSmall!.copyWith(
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
          ),

          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: ActionButton(
                  title: 'Apply Filter',
                  height: 52,
                  width: 360,
                  onTap: (){
                    //todo: apply filter
                    Navigator.pop(context);
                  }
              ),
            ),
          ),
        ],
      ),
    );
  }
}
