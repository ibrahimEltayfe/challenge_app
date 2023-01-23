import 'package:challenge_app/core/common/language_provider/language_provider.dart';
import 'package:challenge_app/features/app_settings/data/models/app_languages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/utils/shared_pref_helper.dart';
import '../firebase_options.dart';

final initializeAppServicesProvider = Provider<InitializeAppServices>((ref) {
  return InitializeAppServices(ref);
});

class InitializeAppServices{
  final Ref ref;
  InitializeAppServices(this.ref);

  Future<void> init() async{
    WidgetsFlutterBinding.ensureInitialized();
    await SharedPrefHelper.init();
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    ref.read(languageProvider.notifier).init();
  }
}
