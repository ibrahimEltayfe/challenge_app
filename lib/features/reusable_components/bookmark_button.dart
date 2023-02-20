import 'dart:developer';

import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/constants/app_lottie.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/home/presentation/manager/bookmark_challenge_provider/bookmark_challenge_provider.dart';
import 'package:challenge_app/features/home/presentation/manager/trendy_challenges_provider/trendy_challenges_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';

import '../home/presentation/manager/user_data_provider/user_data_provider.dart';

class BookmarkButton extends StatefulWidget {
  bool isActive;
  final double width;
  final double height;
  final String challengeId;

  BookmarkButton({
    Key? key,
    this.isActive = false,
    this.width = 36,
    this.height = 36,
    required this.challengeId,
  }) : super(key: key);

  @override
  State createState() => _BookmarkButtonState();
}

class _BookmarkButtonState extends State<BookmarkButton> with SingleTickerProviderStateMixin{
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
  void didUpdateWidget(covariant BookmarkButton oldWidget) {
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
      builder: (context, ref, child) {
        final userData = ref.watch(userDataProvider.notifier).userModel;

        return GestureDetector(
          onTap: () async{
            bool isActiveStatus = widget.isActive;

            if(isActiveStatus){
              await ref.read(bookmarkChallengeProvider.notifier).removeFromBookmarks(
                  challengeId: widget.challengeId,
                  userId: userData?.uid ?? ''
              );

              ref.watch(userDataProvider.notifier).removeBookmarkFromModel(widget.challengeId);

              animationController.reverse();
              isActiveStatus = false;
            }else{
              await ref.read(bookmarkChallengeProvider.notifier).addToBookmarks(
                  challengeId: widget.challengeId,
                  userId: userData?.uid ?? ''
              );

              ref.watch(userDataProvider.notifier).addBookmarkToModel(widget.challengeId);

              animationController.forward();
              isActiveStatus = true;
            }

            setState(() {
              widget.isActive = isActiveStatus;
            });

          },
          child: Container(
            width: widget.width,
            height: widget.height,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 23,
                  offset: Offset(0, 4),
                ),
              ],
              gradient: LinearGradient(begin: Alignment.bottomLeft, end: Alignment.topRight, colors: [Color(0xffcad8ee), Color(0x00ffffff)], ),
            ),

            child: Lottie.asset(
                AppLottie.addBookmark,
                controller: animationController,
                repeat: false,
                fit: BoxFit.contain,
             )
          ),
        );
      },
    );
  }
}