import 'package:easy_localization/easy_localization.dart';
import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/routes_manager.dart';
import 'package:evently/core/resources/string_manager.dart';
import 'package:evently/ui/home/tabs/profile_tab/widget/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../providers/themes_provider.dart';
import '../../../../providers/user_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: screenHeight * 0.05),
                 CircleAvatar(
                   radius: screenWidth * 0.15,
                   backgroundImage: AssetImage(AssetsManager.route),
                 ),
                SizedBox(height: 16,),
                userProvider.user == null
                    ?Center(child: CircularProgressIndicator(),)
                    :Text(
                    userProvider.user?.name??"",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4,),
                userProvider.user == null
                    ?Center(child: CircularProgressIndicator(),)
                    :Text(
                  userProvider.user?.email??"",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
                ),
                SizedBox(height: screenHeight * 0.04,),
                SettingsTile(
                  title: StringsManager.darkMode,
                  icon: Switch(
                    value: Provider.of<ThemeProvider>(context).themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      Provider.of<ThemeProvider>(context, listen: false)
                          .changeTheme(value ? ThemeMode.dark : ThemeMode.light);
                    },
                  ),
                ),
                SizedBox(height: screenHeight * 0.015),
                SettingsTile(
                  title: StringsManager.language,
                  icon: SvgPicture.asset(AssetsManager.arrowRight,width: 24,
                    height: 24, matchTextDirection: true
                  ),
                  onTap: (){
                    _showLanguageSheet(context);

                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                SettingsTile(
                  title: StringsManager.logout,
                  icon: SvgPicture.asset(AssetsManager.logout,matchTextDirection: true),
                  onTap: () {
                     FirebaseAuth.instance.signOut();
                     Navigator.of(context).pushReplacementNamed(RoutesManager.signin);
                  },
                ),

              ],
            ),
          ),
      ),
    );
  }
  void _showLanguageSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        final current = context.locale.languageCode;

        Widget option(String label, String code) {
          final selected = current == code;
          return ListTile(
            title: Text(label),
            trailing: selected ? const Icon(Icons.check) : null,
            onTap: () async {
              await context.setLocale(Locale(code));
              if (sheetContext.mounted) Navigator.pop(sheetContext);
            },
          );
        }

        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 8),
              option('English', 'en'),
              option('العربية', 'ar'),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }
}
