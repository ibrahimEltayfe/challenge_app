import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:riverpod/riverpod.dart';
import '../../../features/app_settings/data/models/app_languages.dart';
import '../../../main.dart';
import '../../utils/shared_pref_helper.dart';
part 'language_state.dart';

final languageProvider = StateNotifierProvider<LanguageProvider,LanguageState>(
  (ref){
    return LanguageProvider();
  }
);

class LanguageProvider extends StateNotifier<LanguageState> {
  LanguageProvider() : super(LanguageInitial());

  AppLanguages? appLanguage;

  void init(){
    try{
      appLanguage = SharedPrefHelper.getLanguage();
      state = LanguageChanged();

    }catch(e){
      //todo:localize error message
      state = LanguageError('Could not get your preferred language');
    }

  }

  Future<void> changeLang(AppLanguages nextAppLanguage) async{
    state = const LanguageLoading();

    try{
      await SharedPrefHelper.setLanguage(nextAppLanguage.name);
      await Future.delayed(Duration(seconds: 1));
      appLanguage = nextAppLanguage;
      state = const LanguageChanged();
    }catch(e){
      log(e.toString());
      state = const LanguageError('error while changing the language..');
    }
  }

}

