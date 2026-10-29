import 'package:evently/core/resources/assets_manager.dart';
import 'package:evently/core/resources/string_manager.dart';

typedef EventCategory = ({
String id,
String title,
String icon,
String bannerLight,
String bannerDark,
});

abstract final class EventCategories {
  static List<EventCategory> get all => [
    (
    id: 'sport',
    title: StringsManager.sport,
    icon: AssetsManager.sportIcon,
    bannerLight: AssetsManager.sport_light,
    bannerDark: AssetsManager.sport_dark,
    ),
    (
    id: 'birthday',
    title: StringsManager.birthday,
    icon: AssetsManager.birthdayIcon,
    bannerLight: AssetsManager.birthday_light,
    bannerDark: AssetsManager.birthday_dark,
    ),
    (
    id: 'meeting',
    title: StringsManager.meeting,
    icon: AssetsManager.meetingIcon,
    bannerLight: AssetsManager.meeting_light,
    bannerDark: AssetsManager.meeting_dark,
    ),
    (
    id: 'exhibition',
    title: StringsManager.exhibition,
    icon: AssetsManager.exhibitionIcon,
    bannerLight: AssetsManager.exhibition_light,
    bannerDark: AssetsManager.exhibition_dark,
    ),
    (
    id: 'bookClub',
    title: StringsManager.bookClub,
    icon: AssetsManager.bookIcon,
    bannerLight: AssetsManager.book_light,
    bannerDark: AssetsManager.book_dark,
    ),
  ];


  static List<({String id, String title, String icon})> get withAll => [
    (id: 'all', title: StringsManager.all, icon: AssetsManager.allIcon),
    for (final c in all) (id: c.id, title: c.title, icon: c.icon),
  ];

  static EventCategory byId(String? id) {
    return all.firstWhere(
          (c) => c.id == id,
      orElse: () => all.first,
    );
  }
}