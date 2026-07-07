import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'core/config/app_theme.dart';
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
import 'features/search/presentation/pages/search_page.dart';
import 'features/booking/presentation/pages/booking_history_page.dart';
import 'features/news/presentation/pages/news_list_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter(WidgetRef ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/get-started',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
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
            path: '/search',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: SearchPage()),
          ),
          GoRoute(
            path: '/bookings',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: BookingHistoryPage()),
          ),
          GoRoute(
            path: '/news',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: NewsListPage()),
          ),
          GoRoute(
            path: '/profile',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: ProfilePage()),
          ),
        ],
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
    ],
  );
}

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
    if (currentLocation.startsWith('/search')) return 1;
    if (currentLocation.startsWith('/bookings')) return 2;
    if (currentLocation.startsWith('/news')) return 3;
    if (currentLocation.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(top: BorderSide(color: AppColors.border, width: 0.5)),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(_navItems.length, (index) {
              final item = _navItems[index];
              final isActive = index == currentIndex;
              return _NavBarItem(
                icon: item.icon,
                activeIcon: item.activeIcon,
                label: item.label,
                isActive: isActive,
                onTap: () {
                  switch (index) {
                    case 0:
                      context.go('/home');
                    case 1:
                      context.go('/search');
                    case 2:
                      context.go('/bookings');
                    case 3:
                      context.go('/news');
                    case 4:
                      context.go('/profile');
                  }
                },
              );
            }),
          ),
        ),
      ),
    );
  }
}

const _navItems = [
  _NavItemData(Icons.home_outlined, Icons.home_rounded, 'Beranda'),
  _NavItemData(Icons.search_outlined, Icons.search_rounded, 'Cari'),
  _NavItemData(
    Icons.confirmation_number_outlined,
    Icons.confirmation_number_rounded,
    'Pesanan',
  ),
  _NavItemData(Icons.newspaper_outlined, Icons.newspaper_rounded, 'Berita'),
  _NavItemData(Icons.person_outlined, Icons.person_rounded, 'Profil'),
];

class _NavItemData {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  const _NavItemData(this.icon, this.activeIcon, this.label);
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavBarItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        padding: EdgeInsets.symmetric(
          horizontal: isActive ? 20 : 8,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              size: isActive ? 22 : 24,
              color: isActive ? Colors.white : AppColors.disabled,
            ),
            if (isActive) ...[
              const SizedBox(width: 6),
              Text(
                label,
                style: GoogleFonts.manrope(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
