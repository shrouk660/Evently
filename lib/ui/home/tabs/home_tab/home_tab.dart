import 'package:easy_localization/easy_localization.dart';
import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/string_manager.dart';
import 'package:evently/providers/themes_provider.dart';
import 'package:evently/providers/user_provider.dart';
import 'package:evently/ui/home/tabs/home_tab/tabs/all_view.dart';
import 'package:evently/ui/home/tabs/home_tab/tabs/birthbay_view.dart';
import 'package:evently/ui/home/tabs/home_tab/tabs/book_club_view.dart';
import 'package:evently/ui/home/tabs/home_tab/tabs/exhibition_%20view.dart';
import 'package:evently/ui/home/tabs/home_tab/tabs/meeting_view.dart';
import 'package:evently/ui/home/tabs/home_tab/tabs/sport_view.dart';
import 'package:evently/ui/start/widgets/language_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';


import '../../../../core/reusable_components/category_chip.dart';
import '../../../../model/event_categories.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});


  @override
  Widget build(BuildContext context) {
    context.locale;
    final categories = EventCategories.withAll;
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    UserProvider userProvider = Provider.of<UserProvider>(context);
    return DefaultTabController(
      length:categories.length,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(StringsManager.welcomeBack,style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                        ),),
                        userProvider.user == null
                            ?Center(child: CircularProgressIndicator(),)
                            :Text(
                          userProvider.user?.name??"",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: .w500,
                        ),),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      InkWell(
                        onTap: (){
                          if(themeProvider.themeMode==ThemeMode.dark){
                            themeProvider.changeTheme(ThemeMode.light);
                          }else{
                            themeProvider.changeTheme(ThemeMode.dark);
                          }
                        },
                        child: SvgPicture.asset(
                          themeProvider.themeMode==ThemeMode.dark
                              ?AssetsManager.moon
                              :AssetsManager.sun,
                          colorFilter: ColorFilter.mode(
                            Theme.of(context).colorScheme.primary,
                            BlendMode.srcIn,
                          ),
                          height: 24,
                          width: 24,
                        ),
                      ),
                      SizedBox(width: 4,),
                      LanguageSwitch(
                        title: context.locale.languageCode == 'en' ? "EN" : "AR",
                        languageCode: context.locale.languageCode,
                        selectedLanguage: context.locale.languageCode,
                        height: 32,
                        widgh: 32,
                        onClicked: () async {
                          final newLocale = context.locale.languageCode == 'en'
                              ? const Locale('ar')
                              : const Locale('en');
                          await context.setLocale(newLocale);
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24,),
              Builder(
                builder: (context){
                  final controller = DefaultTabController.of(context);
                  return AnimatedBuilder(
                    animation: controller,
                    builder: (context, _) => TabBar(
                      physics: NeverScrollableScrollPhysics(),
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                      WidgetStateProperty.all(Colors.transparent),
                      labelPadding: const EdgeInsetsDirectional.only(end: 8),
                      tabs: List.generate(
                        categories.length,
                            (i) => Tab(
                          height: 40,
                          child: CategoryChip(
                            title: categories[i].title,
                            image: categories[i].icon,
                            isSelected: controller.index == i,
                            onTap: () => controller.animateTo(i),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              Expanded(
                child: TabBarView(
                  children: [
                    AllView(),
                    SportView(),
                    BirthdayView(),
                    MeetingView(),
                    ExhibitionView(),
                    BookClubView()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
