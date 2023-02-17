import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/app_lottie.dart';

class FireBall extends StatefulWidget {
  const FireBall({Key? key}) : super(key: key);
  @override
  State<FireBall> createState() => _BuildFireBallState();
}

class _BuildFireBallState extends State<FireBall> with SingleTickerProviderStateMixin{
  late final AnimationController _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1500)
    );

    TickerFuture tickerFuture = _lottieController.repeat();


    tickerFuture.timeout(const Duration(seconds: 12),onTimeout: () {
      if(mounted){
        _lottieController.stop(canceled: true);
      }
    },);

    super.initState();
  }

  @override
  void dispose() {
    _lottieController.stop(canceled: true);
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0,-8),
      child: Lottie.asset(
          AppLottie.fireBall,
          width: 50,
          height: 50,
          controller: _lottieController
      ),
    );
  }
}