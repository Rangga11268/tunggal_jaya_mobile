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
import 'features/routes/presentation/pages/routes_page.dart';
import 'features/booking/presentation/pages/booking_history_page.dart';
import 'features/news/presentation/pages/news_list_page.dart';
import 'features/profile/presentation/pages/profile_page.dart';

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
    initialLocation: '/get-started',
    refreshListenable: _authRefreshNotifier,
    redirect: (context, state) {
      final authState = ref.read(authProvider);
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
            path: '/routes',
            pageBuilder: (context, state) =>
                const NoTransitionPage(child: RoutesPage()),
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
    if (currentLocation.startsWith('/routes')) return 1;
    if (currentLocation.startsWith('/bookings')) return 2;
    if (currentLocation.startsWith('/news')) return 3;
    if (currentLocation.startsWith('/profile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex();
    const navBarHeight = 76.0;
    const buttonSize = 60.0;
    const buttonOverhang = 22.0;
    const notchDepth = 20.0;
    const notchWidth = 68.0;

    return Scaffold(
      body: child,
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: EdgeInsets.only(top: buttonOverhang),
            decoration: const BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 20,
                  offset: Offset(0, -6),
                ),
              ],
            ),
            child: ClipPath(
              clipper: _NotchClipper(
                notchWidth: notchWidth,
                notchDepth: notchDepth,
              ),
              child: Container(
                height: navBarHeight,
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: SafeArea(
                  top: false,
                  bottom: false,
                  child: Row(
                    children: [
                      const Spacer(flex: 3),
                      _NavBarItem(
                        icon: Icons.home_outlined,
                        activeIcon: Icons.home_rounded,
                        label: 'Beranda',
                        isActive: currentIndex == 0,
                        onTap: () => context.go('/home'),
                      ),
                      const Spacer(flex: 4),
                      _NavBarItem(
                        icon: Icons.alt_route_outlined,
                        activeIcon: Icons.alt_route_rounded,
                        label: 'Rute',
                        isActive: currentIndex == 1,
                        onTap: () => context.go('/routes'),
                      ),
                      Spacer(flex: buttonSize ~/ 4),
                      _NavBarItem(
                        icon: Icons.newspaper_outlined,
                        activeIcon: Icons.newspaper_rounded,
                        label: 'Berita',
                        isActive: currentIndex == 3,
                        onTap: () => context.go('/news'),
                      ),
                      const Spacer(flex: 4),
                      _NavBarItem(
                        icon: Icons.person_outlined,
                        activeIcon: Icons.person_rounded,
                        label: 'Profil',
                        isActive: currentIndex == 4,
                        onTap: () => context.go('/profile'),
                      ),
                      const Spacer(flex: 3),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Center(
              child: _FloatingButton(
                size: buttonSize,
                isActive: currentIndex == 2,
                onTap: () => context.go('/bookings'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NotchClipper extends CustomClipper<Path> {
  final double notchWidth;
  final double notchDepth;

  const _NotchClipper({
    required this.notchWidth,
    required this.notchDepth,
  });

  @override
  Path getClip(Size size) {
    final r = 28.0;
    final cx = size.width / 2;
    final half = notchWidth / 2;

    return Path()
      ..moveTo(0, r)
      ..quadraticBezierTo(0, 0, r, 0)
      ..lineTo(cx - half, 0)
      ..quadraticBezierTo(cx, notchDepth, cx + half, 0)
      ..lineTo(size.width - r, 0)
      ..quadraticBezierTo(size.width, 0, size.width, r)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant _NotchClipper old) =>
      old.notchWidth != notchWidth || old.notchDepth != notchDepth;
}

class _NavBarItem extends StatefulWidget {
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
  State<_NavBarItem> createState() => _NavBarItemState();
}

class _NavBarItemState extends State<_NavBarItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.scale(
          scale: _animation.value,
          child: child,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              widget.isActive ? widget.activeIcon : widget.icon,
              size: 22,
              color: widget.isActive
                  ? AppColors.primary
                  : AppColors.disabled,
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 10,
                fontWeight:
                    widget.isActive ? FontWeight.w700 : FontWeight.w500,
                color: widget.isActive
                    ? AppColors.primary
                    : AppColors.disabled,
                height: 1.2,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FloatingButton extends StatefulWidget {
  final double size;
  final bool isActive;
  final VoidCallback onTap;

  const _FloatingButton({
    required this.size,
    required this.isActive,
    required this.onTap,
  });

  @override
  State<_FloatingButton> createState() => _FloatingButtonState();
}

class _FloatingButtonState extends State<_FloatingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.1).chain(
          CurveTween(curve: Curves.easeOut),
        ),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.1, end: 1.0).chain(
          CurveTween(curve: Curves.easeIn),
        ),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _controller.forward(from: 0);
        widget.onTap();
      },
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) => Transform.scale(
          scale: _animation.value,
          child: child,
        ),
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFFE11D48), Color(0xFFBE123C)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.15),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.confirmation_number_rounded,
                color: Colors.white,
                size: 28,
              ),
              if (widget.isActive)
                Positioned(
                  top: 6,
                  right: 8,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary,
                        width: 2,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
