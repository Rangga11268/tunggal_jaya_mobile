import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  static String get apiBaseUrl {
    final envUrl = dotenv.env['API_BASE_URL'];
    if (envUrl != null && envUrl.isNotEmpty) {
      // If web is running and url is 10.0.2.2, automatically convert it to localhost
      if (kIsWeb && envUrl.contains('10.0.2.2')) {
        return envUrl.replaceAll('10.0.2.2', 'localhost');
      }
      return envUrl;
    }
    return kIsWeb ? 'http://localhost:8000' : 'http://10.0.2.2:8000';
  }

  static String get apiPrefix =>
      dotenv.env['API_PREFIX'] ?? '/api';

  static String get apiUrl => '$apiBaseUrl$apiPrefix';

  static String get appName =>
      dotenv.env['APP_NAME'] ?? 'Tunggal Jaya Transport';

  static const Duration requestTimeout = Duration(seconds: 30);
  static const Duration paymentPollInterval = Duration(seconds: 3);
  static const int paymentPollMaxAttempts = 20;
}
