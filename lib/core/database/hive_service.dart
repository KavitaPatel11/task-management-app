import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:task_management_app/features/task/data/models/user_preferences_model.dart';

class HiveService {
  Future<void> initHive() async {
    await Hive.initFlutter();
    Hive.registerAdapter(UserPreferencesAdapter());
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    var box = await Hive.openBox<UserPreferences>('userPreferences');
    await box.put('preferences', preferences);
  }

   Future<UserPreferences?> getUserPreferences() async {
    try {
      var box = await Hive.openBox<UserPreferences>('userPreferences');
      var preferences = box.get('preferences');

      // If preferences are not found, set default preferences
      if (preferences == null) {
        preferences = UserPreferences(theme: 'light', sortOrder: 'asc');
        await saveUserPreferences(preferences); // Save default preferences
      }

      return preferences;
    } catch (e) {
      return null;
    }
  }
}
