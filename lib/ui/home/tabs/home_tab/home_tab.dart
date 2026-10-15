import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/providers/themes_provider.dart';
import 'package:evently/ui/start/widgets/language_switch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../../core/resources/routes_manager.dart';
import '../../../../core/reusable_components/category_chip.dart';
import '../../../../providers/events_provider.dart';
import '../../screen/event_details_screen.dart';
import '../../widget/event_card.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});
  static const List<({String title, String image})> categories = [
    (title: "All", image : AssetsManager.allIcon),
    (title: "Sport", image : AssetsManager.sportIcon),
    (title: "Birthday", image : AssetsManager.birthdayIcon),
    (title: "Meeting", image : AssetsManager.meetingIcon),
    (title: "Exhibition", image : AssetsManager.exhibitionIcon),
    (title: "Book club", image : AssetsManager.bookIcon),
  ];

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    final eventsProvider = context.watch<EventsProvider>();
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
                        Text("Welcom Back",style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: 14,
                        ),),
                        Text("John Safwat",style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
                        title: "EN",
                        languageCode: "en",
                        selectedLanguage: "en",
                        height: 32,
                        widgh: 32,
                      )
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
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      padding: EdgeInsets.zero,
                      dividerColor: Colors.transparent,
                      indicator: const BoxDecoration(),
                      splashFactory: NoSplash.splashFactory,
                      overlayColor:
                      WidgetStateProperty.all(Colors.transparent),
                      labelPadding: const EdgeInsets.only(right: 8),
                      tabs: List.generate(
                        categories.length,
                            (i) => Tab(
                          height: 40,
                          child: CategoryChip(
                            title: categories[i].title,
                            image: categories[i].image,
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
                  children: categories.map((category) {
                    final categoryEvents = category.title == "All"
                        ? eventsProvider.events
                        : eventsProvider.events
                        .where(
                          (event) => event.category == category.title,
                    )
                        .toList();

                    if (categoryEvents.isEmpty) {
                      return Center(
                        child: Text(
                          "No events yet",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 8),
                      itemCount: categoryEvents.length,
                      itemBuilder: (context, index) {
                        final event = categoryEvents[index];

                        return EventCard(
                          event: event,
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              RoutesManager.eventDetails,
                              arguments: event,
                            );
                          },
                        );
                      },
                    );
                  }).toList(),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
