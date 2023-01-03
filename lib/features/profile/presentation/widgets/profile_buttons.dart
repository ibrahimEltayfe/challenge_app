import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/profile/presentation/manager/profile_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        width: 370,
        child: ListView.separated(
          itemCount: 6,
          separatorBuilder: (context, index) => SizedBox(height: index==4?32:11,),
          itemBuilder: (context, i) {
            return _BuildProfileButton(index: i,);
          },
        ),
      ),
    );
  }
}

class _BuildProfileButton extends ConsumerWidget {
  final int index;

  const _BuildProfileButton({Key? key, required this.index}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final profileRef = ref.watch(profileProvider);
    final currentButtonType = ProfileButtonType.values[index];

    return InkWell(
      onTap: (){
        ref.read(profileProvider).navigateToPage(context, currentButtonType);
      },
      borderRadius: BorderRadius.circular(15),
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 18,vertical: 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: context.theme.shadowColor,
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
          color: context.theme.primaryColor,
        ),

        child: Row(
          children: [
            FittedBox(
             child: Icon(
              profileRef.getButtonIcon(currentButtonType),
               color: profileRef.getIconColor(context, currentButtonType),
             )
            ),
            const SizedBox(width: 12,),
            FittedBox(
              child: Text(
                profileRef.getButtonTitle(context, currentButtonType),
                style: context.textTheme.titleMedium!.copyWith(
                  color: context.theme.whiteColor
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}


