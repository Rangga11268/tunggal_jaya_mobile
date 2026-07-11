class ApiEndpoints {
  static const String _prefix = '';

  // Auth
  static const String login = '$_prefix/auth/login';
  static const String register = '$_prefix/auth/register';
  static const String logout = '$_prefix/auth/logout';
  static const String sendOtp = '$_prefix/auth/send-otp';
  static const String verifyOtp = '$_prefix/auth/verify-otp';
  static const String resendOtp = '$_prefix/auth/resend-otp';
  static const String profile = '$_prefix/auth/profile';

  // Routes
  static const String routes = '$_prefix/routes';
  static const String originsDestinations = '$_prefix/routes/origins-destinations';

  // Schedules
  static const String schedules = '$_prefix/schedules';

  // Bookings
  static const String bookings = '$_prefix/bookings';
  static const String selectSeats = '$_prefix/bookings/select-seats';
  static const String processPayment = '$_prefix/bookings/process-payment';

  // News
  static const String news = '$_prefix/news';

  // Dynamic
  static String routeDetail(int id) => '$_prefix/routes/$id';
  static String scheduleDetail(int id) => '$_prefix/schedules/$id';
  static String newsDetail(String slug) => '$_prefix/news/$slug';
  static String bookingDetail(int id) => '$_prefix/bookings/$id';
}
