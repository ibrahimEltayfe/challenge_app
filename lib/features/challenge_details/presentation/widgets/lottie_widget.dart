import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieWidget extends StatelessWidget {
  final String message;
  final String lottiePath;
  final bool repeat;
  const LottieWidget({
    Key? key,
    required this.message,
    required this.lottiePath,
    this.repeat = true
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Lottie.asset(
              lottiePath,
              width: 190,
              height: 190,
              repeat: repeat
          ),

          const SizedBox(height: 10,),

          Text(message,style: context.textTheme.titleMedium,),
        ],
      ),
    );
  }
}
