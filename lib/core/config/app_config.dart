import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl =>
      dotenv.env['API_BASE_URL'] ?? 'http://10.0.2.2:8000';

  static String get apiPrefix =>
      dotenv.env['API_PREFIX'] ?? '/api';

  static String get apiUrl => '$apiBaseUrl$apiPrefix';

  static String get appName =>
      dotenv.env['APP_NAME'] ?? 'Tunggal Jaya Transport';

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration paymentPollInterval = Duration(seconds: 3);
  static const int paymentPollMaxAttempts = 20;
}
