import 'dart:developer';
import 'dart:ui';

import 'package:challenge_app/core/constants/app_themes.dart';
import 'package:challenge_app/testing/file_explorer.dart';
import 'package:challenge_app/testing/github_repo_downloader.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'config/app_routers.dart';
import 'core/constants/app_routes.dart';
import 'config/initialize_app_services.dart';
import 'l10n/app_localizations.dart';

void main() async {
  final container = ProviderContainer();
  await container.read(initializeAppServicesProvider).init();

  runApp(UncontrolledProviderScope(
    container: container,
    child: DevicePreview(
      enabled: false,
      builder: (context) => const MyApp(), // Wrap your app
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DevicePreview.appBuilder(context,
       MaterialApp(
          debugShowCheckedModeBanner: false,
          useInheritedMediaQuery: true,
          locale: DevicePreview.locale(context),
          theme: AppThemes.lightTheme(context),

          builder: (context, child) {
             return ResponsiveWrapper.builder(
                child!,

                defaultScale: true,
                breakpoints: [
                  const ResponsiveBreakpoint.resize(350, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(600, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1000, name: TABLET),
                  const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
                  const ResponsiveBreakpoint.autoScale(1400, name: DESKTOP),
                  const ResponsiveBreakpoint.resize(1600, name: DESKTOP),
                  const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
                ],

                breakpointsLandscape: [
                  const ResponsiveBreakpoint.resize(500, name: MOBILE),
                  const ResponsiveBreakpoint.autoScale(800, name: MOBILE),
                  const ResponsiveBreakpoint.resize(1024, name: TABLET),
                  const ResponsiveBreakpoint.autoScale(1120, name: TABLET),
                ],
              );
          },

         onGenerateRoute: RoutesManager.routes,
         initialRoute: AppRoutes.homeRoute,

         localizationsDelegates: AppLocalizations.localizationsDelegates,
         supportedLocales: AppLocalizations.supportedLocales,
         localeResolutionCallback: localeCallBack,
        ),
    );
  }
}

Locale localeCallBack(Locale? locale,Iterable<Locale> supportedLocales){

  if (locale == null) {
    return supportedLocales.first;
  }

  for (var supportedLocale in supportedLocales) {
    if (locale.countryCode == supportedLocale.countryCode) {
      return supportedLocale;
    }
  }

  return locale;
}
