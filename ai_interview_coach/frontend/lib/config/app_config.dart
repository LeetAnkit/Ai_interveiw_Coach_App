// // class AppConfig {
// //   static const String appName = 'AI Interview Coach';
// //   static const String version = '1.0.0';

// //   // API Configuration
// //   static const String apiBase = String.fromEnvironment(
// //     'API_BASE',
// //     defaultValue: 'https://ai-interveiw-coach-app.onrender.com',
// //   );

// //   // Frontend Configuration
// //   static const String frontendBase = String.fromEnvironment(
// //     'FRONTEND_BASE',
// //     defaultValue: 'http://localhost:8080',
// //   );

// //   // Endpoints
// //   static const String analyzeEndpoint = '/api/analyze-response';
// //   static const String saveResultEndpoint = '/api/save-result';
// //   static const String historyEndpoint = '/api/history';
// //   static const String healthEndpoint = '/api/health';

// //   // UI Configuration
// //   static const Duration animationDuration = Duration(milliseconds: 300);
// //   static const Duration splashDuration = Duration(seconds: 2);
// //   static const int maxHistoryItems = 50;

// //   // Speech Recognition
// //   static const Duration speechTimeout = Duration(seconds: 30);
// //   static const Duration pauseTimeout = Duration(seconds: 3);

// //   // Validation
// //   static const int minAnswerLength = 10;
// //   static const int maxAnswerLength = 5000;
// //   static const int minQuestionLength = 5;

// //   // Colors
// //   static const int primaryColorValue = 0xFF2196F3;
// //   static const int secondaryColorValue = 0xFF14B8A6;
// //   static const int accentColorValue = 0xFFF97316;

// //   // Firebase Collections
// //   static const String usersCollection = 'users';
// //   static const String sessionsCollection = 'sessions';

// //   // SharedPreferences Keys
// //   static const String themeKey = 'theme_mode';
// //   static const String onboardingKey = 'onboarding_completed';
// //   static const String lastSessionKey = 'last_session_date';

// //   // Development flags
// //   static const bool isDevelopment =
// //       bool.fromEnvironment('DEVELOPMENT', defaultValue: true);
// //   static const bool enableOfflineMode =
// //       bool.fromEnvironment('OFFLINE_MODE', defaultValue: false);
// // }

// class AppConfig {
//   static const String appName = 'AI Interview Coach';
//   static const String version = '1.0.0';

//   // ✅ API Configuration (point this to Vercel backend)
//   static const String apiBase = String.fromEnvironment(
//     'API_BASE',
//     defaultValue: 'https://ai-interview-coach-app.vercel.app', // changed
//   );

//   // ✅ Frontend Configuration (use deployed frontend instead of localhost for production)
//   static const String frontendBase = String.fromEnvironment(
//     'FRONTEND_BASE',
//     defaultValue:
//         'https://ai-interview-coach-frontend.vercel.app', // change when deployed
//   );

//   // Endpoints
//   static const String analyzeEndpoint = '/api/analyze-response';
//   static const String saveResultEndpoint = '/api/save-result';
//   static const String historyEndpoint = '/api/history';
//   static const String healthEndpoint = '/api/health';

//   // UI Configuration
//   static const Duration animationDuration = Duration(milliseconds: 300);
//   static const Duration splashDuration = Duration(seconds: 2);
//   static const int maxHistoryItems = 50;

//   // Speech Recognition
//   static const Duration speechTimeout = Duration(seconds: 30);
//   static const Duration pauseTimeout = Duration(seconds: 3);

//   // Validation
//   static const int minAnswerLength = 10;
//   static const int maxAnswerLength = 5000;
//   static const int minQuestionLength = 5;

//   // Colors
//   static const int primaryColorValue = 0xFF2196F3;
//   static const int secondaryColorValue = 0xFF14B8A6;
//   static const int accentColorValue = 0xFFF97316;

//   // Firebase Collections
//   static const String usersCollection = 'users';
//   static const String sessionsCollection = 'sessions';

//   // SharedPreferences Keys
//   static const String themeKey = 'theme_mode';
//   static const String onboardingKey = 'onboarding_completed';
//   static const String lastSessionKey = 'last_session_date';

//   // Development flags
//   static const bool isDevelopment =
//       bool.fromEnvironment('DEVELOPMENT', defaultValue: true);
//   static const bool enableOfflineMode =
//       bool.fromEnvironment('OFFLINE_MODE', defaultValue: false);
// }

class AppConfig {
  static const String appName = 'AI Interview Coach';
  static const String version = '1.0.0';

  // API Configuration
  // Dynamically sets the backend API base URL using environment variables
  static const String apiBase = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://ai-interveiw-coach-app.onrender.com',
  );

  // Frontend Configuration (optional, if you deploy Flutter web later)
  static const String frontendBase = 'https://ai-interveiw-coach.vercel.app';

  // Endpoints

  // this is for the backend communication
  static const String analyzeEndpoint = '/api/analyze-response';
  static const String saveResultEndpoint = '/api/save-result';
  static const String historyEndpoint = '/api/history';
  static const String healthEndpoint = '/api/health';

  // UI Configuration
  static const Duration animationDuration = Duration(milliseconds: 300);
  static const Duration splashDuration = Duration(seconds: 2);
  static const int maxHistoryItems = 50;

  // Speech Recognition
  static const Duration speechTimeout = Duration(seconds: 30);
  static const Duration pauseTimeout = Duration(seconds: 3);

  // Validation
  static const int minAnswerLength = 10;
  static const int maxAnswerLength = 5000;
  static const int minQuestionLength = 5;

  // Colors
  static const int primaryColorValue = 0xFF2196F3;
  static const int secondaryColorValue = 0xFF14B8A6;
  static const int accentColorValue = 0xFFF97316;

  // Firebase Collections
  static const String usersCollection = 'users';
  static const String sessionsCollection = 'sessions';

  // SharedPreferences Keys
  static const String themeKey = 'theme_mode';
  static const String onboardingKey = 'onboarding_completed';
  static const String lastSessionKey = 'last_session_date';

  // Development flags
  // Toggles for enabling dev-specific features or offline functionality
  static const bool isDevelopment =
      bool.fromEnvironment('DEVELOPMENT', defaultValue: true);
  static const bool enableOfflineMode =
      bool.fromEnvironment('OFFLINE_MODE', defaultValue: false);
}
