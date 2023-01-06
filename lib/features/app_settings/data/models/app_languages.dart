enum AppLanguages{
  ar,
  en,
}

extension languageHandler on AppLanguages{
  String get getLangName{
    switch(this){
      case AppLanguages.ar:
        return 'العربية';
      case AppLanguages.en:
        return "English";
    }
  }
}

