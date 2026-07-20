import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_theme.dart';
import 'features/auth/presentation/pages/splash_page.dart';
import 'features/auth/presentation/pages/get_started_page.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/auth/presentation/pages/login_otp_page.dart';
import 'features/auth/presentation/pages/register_page.dart';
import 'features/auth/presentation/pages/otp_page.dart';
import 'features/auth/presentation/pages/forgot_password_page.dart';
import 'features/auth/presentation/pages/verification_sent_page.dart';
import 'features/auth/presentation/pages/reset_password_page.dart';
import 'features/auth/presentation/pages/reset_success_page.dart';
import 'features/auth/presentation/pages/auth_success_page.dart';
import 'features/auth/presentation/providers/auth_provider.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/booking/presentation/pages/booking_history_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';
import 'features/search/presentation/pages/schedule_list_page.dart';
import 'features/booking/presentation/pages/seat_selection_page.dart';
import 'features/booking/presentation/pages/booking_checkout_page.dart';
import 'features/booking/presentation/pages/ticket_detail_page.dart';
import 'features/charter/presentation/pages/charter_landing_page.dart';
import 'features/charter/presentation/pages/charter_request_page.dart';
import 'features/help/presentation/pages/help_page.dart';
import 'features/promo/presentation/pages/promo_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class _AuthRefreshNotifier extends ChangeNotifier {
  void notify() => notifyListeners();
}

final _authRefreshNotifier = _AuthRefreshNotifier();

final routerProvider = Provider<GoRouter>((ref) {
  ref.listen(authProvider, (_, __) => _authRefreshNotifier.notify());

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    refreshListenable: _authRefreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
      final isLoggedIn = authState.isAuthenticated;
      final isSplash = state.matchedLocation == '/splash';
      final isAuthRoute =
          state.matchedLocation == '/get-started' ||
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/login-otp' ||
          state.matchedLocation == '/register' ||
          state.matchedLocation == '/otp' ||
          state.matchedLocation == '/forgot-password' ||
          state.matchedLocation == '/verification-sent' ||
          state.matchedLocation == '/reset-password' ||
          state.matchedLocation == '/reset-success' ||
          state.matchedLocation == '/auth-success';
      final isChecking = authState.isLoading && authState.user == null;
      final isOtpRoute = state.matchedLocation == '/otp';

      if (isSplash) return null; // Let splash screen handle its own duration
      if (isChecking) return null;

      if (!isLoggedIn && !isAuthRoute) return '/get-started';
      if (isLoggedIn && isAuthRoute && !authState.needsVerification) return '/home';
      if (isLoggedIn && authState.needsVerification && !isOtpRoute) return '/otp';
      return null;
    },
    routes: [
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) =>
            MainShell(currentLocation: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/home',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HomePage()),
          ),
          GoRoute(
            path: '/booking-history',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BookingHistoryPage()),
          ),
          GoRoute(
            path: '/help',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: HelpPage()),
          ),
          GoRoute(
            path: '/promo',
            builder: (context, state) => const PromoPage(),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfilePage()),
          ),
          GoRoute(
            path: '/schedule-list',
            builder: (context, state) {
              return ScheduleListPage(
                origin: state.uri.queryParameters['origin'] ?? '',
                destination: state.uri.queryParameters['destination'] ?? '',
                date: state.uri.queryParameters['date'] ?? '',
              );
            },
          ),
          GoRoute(
            path: '/seat-selection/:id',
            builder: (context, state) {
              return SeatSelectionPage(
                scheduleId: state.pathParameters['id'] ?? '',
              );
            },
          ),
          GoRoute(
            path: '/checkout/:id',
            builder: (context, state) {
              final extra = state.extra as Map<String, dynamic>?;
              final selectedSeats = (extra?['selectedSeats'] as List<String>?) ?? [];
              return BookingCheckoutPage(
                scheduleId: state.pathParameters['id'] ?? '',
                selectedSeats: selectedSeats,
              );
            },
          ),

          GoRoute(
            path: '/charter',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CharterLandingPage(),
            ),
          ),
          GoRoute(
            path: '/charter/request',
            pageBuilder: (context, state) => const NoTransitionPage(
              child: CharterRequestPage(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: '/splash',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/get-started',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const GetStartedPage(),
      ),
      GoRoute(
        path: '/login',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/login-otp',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginOtpPage(),
      ),
      GoRoute(
        path: '/register',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/otp',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const OtpPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/verification-sent',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const VerificationSentPage(),
      ),
      GoRoute(
        path: '/reset-password',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResetPasswordPage(),
      ),
      GoRoute(
        path: '/reset-success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ResetSuccessPage(),
      ),
      GoRoute(
        path: '/auth-success',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AuthSuccessPage(),
      ),
      GoRoute(
        path: '/ticket-detail',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TicketDetailPage(
            booking: extra ?? {},
          );
        },
      ),
    ],
  );
});
 
class MainShell extends StatelessWidget {
  final Widget child;
  final String currentLocation;

  const MainShell({
    super.key,
    required this.child,
    required this.currentLocation,
  });

  int _currentIndex() {
    if (currentLocation.startsWith('/home')) return 0;
    if (currentLocation.startsWith('/booking-history')) return 1;
    if (currentLocation.startsWith('/help')) return 2;
    if (currentLocation.startsWith('/profile')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex(),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/booking-history');
            case 2:
              context.go('/help');
            case 3:
              context.go('/profile');
          }
        },
        backgroundColor: AppColors.surface,
        elevation: 0,
        indicatorColor: AppColors.primaryLight,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded, color: AppColors.primary),
            label: 'Beranda',
          ),
          NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
            label: 'Pesanan',
          ),
          NavigationDestination(
            icon: Icon(Icons.help_outline_rounded),
            selectedIcon: Icon(Icons.help_rounded, color: AppColors.primary),
            label: 'Bantuan',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded, color: AppColors.primary),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}

