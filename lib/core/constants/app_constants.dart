class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:8080';
  static const Duration apiTimeout = Duration(seconds: 30);

  // Mock Data Configuration
  static const Duration mockNetworkDelay = Duration(milliseconds: 500);

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultBorderRadius = 8.0;

  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 300);
  static const Duration longAnimationDuration = Duration(milliseconds: 500);
}

/// App-wide string constants
class AppStrings {
  // App
  static const String appTitle = 'Note Taking App';

  // Errors
  static const String genericError = 'Something went wrong';
  static const String networkError = 'Network error occurred';
  static const String noNotesFound = 'No notes yet. Add one!';

  // Success messages
  static const String noteAddedSuccess = 'Note added successfully';
  static const String noteUpdatedSuccess = 'Note updated successfully';
  static const String noteDeletedSuccess = 'Note deleted successfully';
  static const String notesDeletedSuccess = 'Notes deleted successfully';

  // Actions
  static const String add = 'Add';
  static const String save = 'Save';
  static const String delete = 'Delete';
  static const String cancel = 'Cancel';
  static const String retry = 'Retry';
}
