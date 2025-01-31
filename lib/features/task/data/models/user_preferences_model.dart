import 'package:hive/hive.dart';

part 'user_preferences_model.g.dart';

@HiveType(typeId: 1)
class UserPreferences {
  @HiveField(0)
  String theme; // Light/Dark Theme

  @HiveField(1)
  String sortOrder; // Sorting preference (e.g., by date, priority)

  UserPreferences({
    required this.theme,
    required this.sortOrder,
  });
}
