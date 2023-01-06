import 'package:challenge_app/l10n/app_localizations.dart';
import 'package:flutter/material.dart';

import '../../data/models/app_languages.dart';

class AppSettingsPage extends StatelessWidget {
  const AppSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            SizedBox(height: 20,),
            _BuildLanguageMenu()
          ],
        ),
      ),

    );
  }
}

class _BuildLanguageMenu extends StatefulWidget {
  const _BuildLanguageMenu({Key? key}) : super(key: key);

  @override
  State<_BuildLanguageMenu> createState() => _BuildLanguageMenuState();
}

class _BuildLanguageMenuState extends State<_BuildLanguageMenu> {

  AppLanguages currentLang = AppLanguages.en;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<AppLanguages>(
        value: currentLang,
        items: List.generate(
            AppLanguages.values.length,
                (i) => DropdownMenuItem(
              value: AppLanguages.values[i],
              onTap: (){

              },
              child: Text(AppLanguages.values[i].getLangName,),
            )
        ),
        onChanged: (val){
          setState(() {
            currentLang = val!;
          });
        }
    );
  }
}
