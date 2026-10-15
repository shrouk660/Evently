import 'package:evently/core/resources/assets_manager.dart';

typedef EventCategory = ({
String title,
String icon,
String bannerLight,
String bannerDark,
});

abstract final class EventCategories {
  static const List<EventCategory> all = [
    (title: "Sport", icon: AssetsManager.sportIcon, bannerLight: AssetsManager.sport_light, bannerDark: AssetsManager.sport_dark),
    (title: "Birthday", icon: AssetsManager.birthdayIcon, bannerLight: AssetsManager.birthday_light, bannerDark: AssetsManager.birthday_dark),
    (title: "Meeting", icon: AssetsManager.meetingIcon, bannerLight: AssetsManager.meeting_light, bannerDark: AssetsManager.meeting_dark),
    (title: "Exhibition", icon: AssetsManager.exhibitionIcon, bannerLight: AssetsManager.exhibition_light, bannerDark: AssetsManager.exhibition_dark),
    (title: "Book club", icon: AssetsManager.bookIcon, bannerLight: AssetsManager.book_light, bannerDark: AssetsManager.book_dark),
  ];
}