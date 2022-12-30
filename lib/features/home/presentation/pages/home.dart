import 'package:challenge_app/core/constants/app_images.dart';
import 'package:challenge_app/core/constants/app_lottie.dart';
import 'package:challenge_app/core/constants/app_routes.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/mediaquery_size.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../widgets/search_bar.dart';
import '../widgets/horizontal_list.dart';

class Home extends ConsumerWidget {
  const Home({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            /* - top bar - */
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
              child: SizedBox(
                height: 75,
                child: Stack(
                  children: const[
                    _BuildFireBall(),
                    _BuildWelcomeText(),
                    _BuildUserName(name:'Ibrahim'),
                    _BuildCoins(numOfCoins: 10)
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14,),
            GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, AppRoutes.searchRoute);
              },
              child: const SearchBar()
            ),

            const SizedBox(height: 15,),
            HorizontalList(
              title: context.localization.trending,
            ),

            HorizontalList(
              title: context.localization.news,
            )

          ],
        ),
      ),
    );
  }
}

class _BuildFireBall extends StatefulWidget {
  const _BuildFireBall({Key? key}) : super(key: key);
  @override
  State<_BuildFireBall> createState() => _BuildFireBallState();
}

class _BuildFireBallState extends State<_BuildFireBall> with SingleTickerProviderStateMixin{
  late final AnimationController _lottieController;

  @override
  void initState() {
    _lottieController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500)
    );

    TickerFuture tickerFuture = _lottieController.repeat();
    tickerFuture.timeout(const Duration(seconds: 12), onTimeout:  () {
      _lottieController.stop(canceled: true);
      _lottieController.dispose();
    });
    super.initState();
  }

  @override
  void dispose() {
    _lottieController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 125,
      top: -10,
      child: Lottie.asset(
        AppLottie.fireBall,
        width: 50,
        height: 50,
        controller: _lottieController
      ),
    );
  }
}

class _BuildWelcomeText extends StatelessWidget {
  const _BuildWelcomeText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        top: 0,
        height: 40,
        child: FittedBox(
          child: Text(
            context.localization.welcome,
            style: context.textTheme.displayMedium,
          ),
        )
    );
  }
}

class _BuildUserName extends StatelessWidget {
  final String name;
  const _BuildUserName({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        bottom: 0,
        height: 35,
        child: FittedBox(
          child: Text(name,style: context.textTheme.displayMedium!.copyWith(
              color: context.theme.primaryColor
          ),),
        )
    );
  }
}

class _BuildCoins extends StatelessWidget {
  final int numOfCoins;
  const _BuildCoins({Key? key, required this.numOfCoins}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
        end: 0,
        top: 13,
        child: Row(
          children: [
            Text('$numOfCoins',style: context.textTheme.titleSmall,),
            const SizedBox(width: 4,),
            SvgPicture.asset(AppImages.coins,width: 22,height: 25,),
          ],
        )
    );
  }
}
