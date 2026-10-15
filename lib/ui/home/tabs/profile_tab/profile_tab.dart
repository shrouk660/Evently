import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/routes_manager.dart';
import 'package:evently/ui/home/tabs/profile_tab/widget/settings_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../providers/themes_provider.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
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
                Text(
                  "John Safwat",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 4,),
                Text(
                  "johnsafwat.route@gmail.com",
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(fontSize: 14),
                ),
                SizedBox(height: screenHeight * 0.04,),
                SettingsTile(
                  title: "Dark mode",
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
                  title: "Language",
                  icon: SvgPicture.asset(AssetsManager.arrowRight,width: 24,
                    height: 24,
                  ),
                  onTap: (){

                  },
                ),
                SizedBox(height: screenHeight * 0.015),
                SettingsTile(
                  title: "Logout",
                  icon: SvgPicture.asset(AssetsManager.logout),
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
}
