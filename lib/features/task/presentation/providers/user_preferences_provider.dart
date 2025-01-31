import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:task_management_app/features/task/data/models/user_preferences_model.dart';
import 'package:task_management_app/features/task/data/repositories/task_repository.dart';



final userPreferencesProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences?>((ref) {
  return UserPreferencesNotifier(ref);
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences?> {
  final Ref ref;
  final _repository = TaskRepository();

  UserPreferencesNotifier(this.ref) : super(null) {
    loadUserPreferences(); // Load user preferences during initialization
  }

  Future<void> loadUserPreferences() async {
    state = await _repository.getUserPreferences();
  }

  Future<void> saveUserPreferences(UserPreferences preferences) async {
    await _repository.saveUserPreferences(preferences);
    state = preferences;
  }

  void toggleTheme() async {
    if (state != null) {
      String newTheme = (state!.theme == 'light') ? 'dark' : 'light';
      UserPreferences updatedPreferences = UserPreferences(
        theme: newTheme,
        sortOrder: state!.sortOrder,
      );

      await saveUserPreferences(updatedPreferences);
    }
  }
}
