import 'package:challenge_app/core/constants/app_fonts.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/challenge_details/presentation/manager/likes_manager_provider/likes_manager_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_icons.dart';
import '../../../../core/constants/app_lottie.dart';
import '../../../home/presentation/manager/user_data_provider/user_data_provider.dart';

class LikeContainer extends StatefulWidget {
  int numOfLikes;
  bool isActive;
  final double maxWidth;
  final double maxHeight;
  final String responseId;
  LikeContainer({
    Key? key,
    required this.numOfLikes,
    this.isActive = false,
    required this.maxWidth,
    required this.maxHeight,
    required this.responseId
  }) : super(key: key);

  @override
  State<LikeContainer> createState() => _LikeContainerState();
}

class _LikeContainerState extends State<LikeContainer> with SingleTickerProviderStateMixin{
  late AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
        value: widget.isActive?1:0
    );


    super.initState();
  }

  @override
  void didUpdateWidget(covariant LikeContainer oldWidget) {
    //to update bookmark`s value after navigating back
    //Ex: going to details page => change bookmark value => go back to home
    if(oldWidget.isActive != widget.isActive){
      if(widget.isActive){
        animationController.value = 1;
      }else{
        animationController.value = 0;
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context,ref,child) {
        final userData = ref.watch(userDataProvider.notifier).userModel;

        return Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          textDirection: TextDirection.ltr,
          children: [
            GestureDetector(
              onTap: () async{
                bool isActiveStatus = widget.isActive;

                if(isActiveStatus){
                  ref.read(likesManagerProvider.notifier).removeLike(
                      userData!.uid!,
                      widget.responseId
                  ).whenComplete((){
                    userData.likes!.remove(widget.responseId);
                  });

                  animationController.reverse();
                  isActiveStatus = false;
                  widget.numOfLikes = widget.numOfLikes - 1;
                }else{
                  ref.read(likesManagerProvider.notifier).addLike(
                      userData!.uid!,
                      widget.responseId
                  ).whenComplete((){
                    userData.likes!.add(widget.responseId);
                  });

                  animationController.forward();
                  isActiveStatus = true;
                  widget.numOfLikes = widget.numOfLikes + 1;
                }

                setState(() {
                  widget.isActive = isActiveStatus;
                });

              },
              child: SizedBox(
                width: widget.maxWidth*0.22,
                height: widget.maxHeight,
                child: OverflowBox(
                  maxHeight: widget.maxHeight*1.1,
                  maxWidth: widget.maxWidth*0.48,

                  child: Lottie.asset(
                    AppLottie.love,
                    controller: animationController,
                    repeat: false,
                    alignment: Alignment.center,
                    fit: BoxFit.contain,
                  ),
                ),
              )
            ),

            const SizedBox(width: 4,),
            ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: widget.maxWidth,
                  minWidth: widget.maxWidth*0.15,
              ),

              child: Text(
                '${widget.numOfLikes}',
                style: context.textTheme.titleSmall,
                maxLines: 1,
                overflow: TextOverflow.clip,
                softWrap: false,
                textDirection: TextDirection.ltr,
              ),
            )
          ],
        );
      }
    );
  }
}
