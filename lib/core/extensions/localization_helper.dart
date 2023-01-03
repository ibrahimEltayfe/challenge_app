import 'package:challenge_app/l10n/app_localizations.dart';
import 'package:flutter/cupertino.dart';

extension LocalizationHelper on BuildContext{
  AppLocalizations get localization => AppLocalizations.of(this)!;
  bool get isRtl => Localizations.localeOf(this).languageCode == 'ar';
}

