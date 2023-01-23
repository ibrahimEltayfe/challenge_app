import 'package:shared_preferences/shared_preferences.dart';

import '../../features/app_settings/data/models/app_languages.dart';

class SharedPrefHelper{
  static late SharedPreferences sharedPref;

  static Future<void> init() async{
    sharedPref = await SharedPreferences.getInstance();
  }

  static AppLanguages? getLanguage(){
    final String? langCode = sharedPref.getString('lang');

    if(langCode != null){

      for(AppLanguages language in AppLanguages.values){
        if(language.name == langCode){
          return language;
        }
      }

    }

    return null;
  }

  static Future<void> setLanguage(String language) async{
    await sharedPref.setString('lang', language);
  }
}