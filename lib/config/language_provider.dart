import 'package:challenge_app/features/app_settings/data/models/app_languages.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final languageProvider = StateProvider<AppLanguages>((ref) {
  return AppLanguages.en;
});