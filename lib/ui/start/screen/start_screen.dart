import 'package:easy_localization/easy_localization.dart';
import 'package:evently/core/resources/routes_manager.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/assets_manager.dart';
import '../../../core/resources/string_manager.dart';
import '../../../core/reusable_components/custom_button.dart';
import '../../../providers/themes_provider.dart';
import '../widgets/language_switch.dart';
import '../widgets/theme_switch.dart';
class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    ThemeProvider provider = Provider.of<ThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(AssetsManager.logo,
          color: Theme.of(context).colorScheme.primary,
          width: screenWidth*0.45,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(AssetsManager.beingCreative,color: Theme.of(context).colorScheme.onPrimary,),
            Text(StringsManager.startTitle,style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontSize: 17
            ),),
            Text(StringsManager.startDesc,style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 15
            )),
            SizedBox(height: 16,),
            Row(
              children: [
                Text(StringsManager.language,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),),
                Spacer(),
                LanguageSwitch(
                  title: "English",
                  languageCode: "en",
                  selectedLanguage: context.locale.languageCode,
                  onClicked:(){
                    context.setLocale(Locale("en"));
                  } ,
                ),
                SizedBox(width: 8,),
                LanguageSwitch(
                  title: "Arabic",
                  languageCode: "ar",
                  selectedLanguage: context.locale.languageCode,
                  onClicked: (){
                    context.setLocale(Locale("ar"));
                  },
                ),

              ],
            ),
            SizedBox(height: 16,),
            Row(
              children: [
                Text(StringsManager.theme,style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w500
                ),),
                Spacer(),
                ThemeSwitch(iconPath: provider.themeMode == ThemeMode.light
                    ?AssetsManager.sunSelected
                    :AssetsManager.sun,
                  mode: ThemeMode.light,),
                SizedBox(width: 8,),
                ThemeSwitch(iconPath: provider.themeMode == ThemeMode.dark
                    ?AssetsManager.moonSelected
                    :AssetsManager.moon,
                  mode: ThemeMode.dark,),

              ],
            ),
            SizedBox(height: 24,),
            CustomButton(title: StringsManager.startActionTitle,
              onClick: () {
              Navigator.of(context).pushReplacementNamed(RoutesManager.onboarding);

            },)
          ],
        ),
      ),
    );
  }
}
