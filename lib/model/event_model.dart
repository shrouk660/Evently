class EventModel {
  final String title;
  final String description;
  final String category;
  final DateTime date;
  final int hour;
  final int minute;
  final String bannerLight;
  final String bannerDark;

  EventModel({
    required this.title,
    required this.description,
    required this.category,
    required this.date,
    required this.hour,
    required this.minute,
    required this.bannerLight,
    required this.bannerDark,
  });

  EventModel copyWith({
    String? title,
    String? description,
    String? category,
    DateTime? date,
    int? hour,
    int? minute,
    String? bannerLight,
    String? bannerDark,
  }) {
    return EventModel(
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      date: date ?? this.date,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      bannerLight: bannerLight ?? this.bannerLight,
      bannerDark: bannerDark ?? this.bannerDark,
    );
  }
}