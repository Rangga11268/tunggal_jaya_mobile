class ApiEndpoints {
  static const String _prefix = '';

  static const String login = '$_prefix/auth/login';
  static const String register = '$_prefix/auth/register';
  static const String logout = '$_prefix/auth/logout';
  static const String forgotPassword = '$_prefix/auth/forgot-password';
  static const String resetPassword = '$_prefix/auth/reset-password';
  static const String verifyPhone = '$_prefix/auth/verify-phone';
  static const String resendOtp = '$_prefix/auth/resend-otp';

  static const String home = '$_prefix/home';
  static const String originsDestinations = '$_prefix/origins-destinations';
  static const String routes = '$_prefix/routes';
  static const String schedules = '$_prefix/schedules';
  static const String news = '$_prefix/news';
  static const String fleet = '$_prefix/fleet';
  static const String profile = '$_prefix/profile';

  static const String bookings = '$_prefix/bookings';
  static const String checkAvailability = '$_prefix/bookings/check-availability';
  static const String selectSeats = '$_prefix/bookings/select-seats';

  static const String paymentsProcess = '$_prefix/payments/process';
  static const String promoValidate = '$_prefix/promo/validate';

  static String routeDetail(int id) => '$_prefix/routes/$id';
  static String scheduleDetail(int id) => '$_prefix/schedules/$id';
  static String newsDetail(String slug) => '$_prefix/news/$slug';
  static String bookingDetail(int id) => '$_prefix/bookings/$id';
  static String bookingTicket(int id) => '$_prefix/bookings/$id/ticket';
  static String paymentStatus(String orderId) =>
      '$_prefix/payments/status/$orderId';
}
