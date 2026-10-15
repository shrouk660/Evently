import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/colors_manager.dart';
import 'package:evently/core/resources/routes_manager.dart';
import 'package:evently/ui/home/tabs/favorite_tab/favorite_tab.dart';
import 'package:evently/ui/home/tabs/home_tab/home_tab.dart';
import 'package:evently/ui/home/tabs/profile_tab/profile_tab.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  List<Widget> tabs = [
    HomeTab(),
    FavoriteTab(),
    ProfileTab()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            selectedIndex = value;
          });
        } ,
          currentIndex:selectedIndex ,
          items: [
            BottomNavigationBarItem(
              label: "Home",
                icon:SvgPicture.asset(
                    AssetsManager.home,
                    colorFilter: ColorFilter.mode(
                        ColorsManager.unselectedTabColor,
                        BlendMode.srcIn
                    )
                ),
                activeIcon: SvgPicture.asset(
                  AssetsManager.home_selected,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn
                  ),
                )
            ),
            BottomNavigationBarItem(
              label: "Favorite",
                icon:SvgPicture.asset(
                    AssetsManager.heart,
                    colorFilter: ColorFilter.mode(
                        ColorsManager.unselectedTabColor,
                        BlendMode.srcIn
                    )
                ),
                activeIcon: SvgPicture.asset(
                  AssetsManager.heart_selected,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn
                  ),
                )
            ),
            BottomNavigationBarItem(
              label: "Profile",
                icon:SvgPicture.asset(
                    AssetsManager.profile,
                    colorFilter: ColorFilter.mode(
                        ColorsManager.unselectedTabColor,
                        BlendMode.srcIn
                    )
                ),
                activeIcon: SvgPicture.asset(
                  AssetsManager.profile_selected,
                  colorFilter: ColorFilter.mode(
                      Theme.of(context).colorScheme.primary,
                      BlendMode.srcIn
                  ),
                )
            ),
          ]
      ),
      body:tabs[selectedIndex] ,
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            Navigator.of(context).pushNamed(RoutesManager.addEvent);
          },
      backgroundColor: Theme.of(context).colorScheme.primary,
      shape: const CircleBorder(),
      child: SvgPicture.asset(
        AssetsManager.add,
        width: 24,
        height: 24,
      ),
      ),

    );
  }
}
