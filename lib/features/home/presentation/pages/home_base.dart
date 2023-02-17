import 'package:challenge_app/core/constants/app_icons.dart';
import 'package:challenge_app/core/extensions/localization_helper.dart';
import 'package:challenge_app/core/extensions/theme_helper.dart';
import 'package:challenge_app/features/bookmarks/presentation/pages/bookmarks.dart';
import 'package:challenge_app/features/home/presentation/pages/home.dart';
import 'package:challenge_app/features/profile/presentation/pages/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../manager/bottom_navigation_provider/bottom_navigation_provider.dart';

class HomeBase extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _BottomNavBar(),
      body: SafeArea(
          child: Consumer(
            builder: (context, ref, child) {
              final index = ref.watch(bottomNavigationIndexProvider);

              return IndexedStack(
                index: index,
                children: [
                  Home(),
                  Bookmarks(),
                  Profile()
                ],
              );
            },

          )
      ),
    );
  }
}

class _BottomNavBar extends ConsumerWidget {
  const _BottomNavBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final index = ref.watch(bottomNavigationIndexProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: BottomNavigationBar(
        onTap: (i){
          ref.read(bottomNavigationIndexProvider.notifier).state = i;
        },
        backgroundColor: context.theme.scaffoldBackgroundColor,
        unselectedItemColor: context.theme.lightGreyColor,
        selectedItemColor: context.theme.primaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home),
            label: ''
          ),

          BottomNavigationBarItem(
            icon: Icon(AppIcons.bookmarkOutlineFa,size: 22,),
            label: ''
          ),

          BottomNavigationBarItem(
            icon: Icon(AppIcons.profile),
            label: ''
          ),
        ]
      ),
    );
  }
}
