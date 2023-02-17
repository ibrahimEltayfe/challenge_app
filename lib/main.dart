import 'dart:ui';
import 'package:challenge_app/config/app_themes.dart';
import 'package:challenge_app/features/app_settings/data/models/app_languages.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:responsive_framework/responsive_wrapper.dart';
import 'config/app_routers.dart';
import 'core/common/language_provider/language_provider.dart';
import 'core/common/no_context_localization.dart';
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


class MyApp extends ConsumerWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(languageProvider.select((value) => value is LanguageChanged));

    ref.listen(languageProvider, (previous, current) {
      if(current is LanguageError){
        Fluttertoast.showToast(msg: current.message);
      }
    });

    final AppLanguages? currentLang = ref.watch(languageProvider.notifier).appLanguage;

    return DevicePreview.appBuilder(context,
          MaterialApp(
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            useInheritedMediaQuery: true,

            builder: (context, child) {
              return ResponsiveWrapper.builder(
                Theme(
                  data: AppThemes.lightTheme(context,Localizations.localeOf(context)),
                  child: child!
                ),
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
            initialRoute: AppRoutes.decideRoute,

            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            localeResolutionCallback: (Locale? locale,Iterable<Locale> supportedLocales){
              if(currentLang != null){
                return Locale(currentLang.name);
              }

              return localeCallBack(locale,supportedLocales);
            }

          ),
        );
  }

  Locale localeCallBack(Locale? locale,Iterable<Locale> supportedLocales){
    if (locale == null) {
      return const Locale('en');
    }

    for (var supportedLocale in supportedLocales) {
      if (locale.countryCode == supportedLocale.countryCode) {
        return supportedLocale;
      }
    }

    return const Locale('en');
  }
}


