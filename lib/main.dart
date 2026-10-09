import 'dart:async';
import 'package:flutter/material.dart';
import 'theme/app_colors.dart';
import 'widgets/app_widgets.dart';
import 'screens/all_screens.dart';
import 'services/auth_service.dart';
import 'screens/auth_screen.dart';
import 'screens/auth_landing_screen.dart';

void main() {
  runApp(const RREApp());
}

class RREApp extends StatelessWidget {
  const RREApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rajat Raj Entertainment - RRE',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.dark(
          primary: AppColors.teal,
          secondary: AppColors.tealLight,
          surface: AppColors.surface,
          onPrimary: Color(0xFF0A192F),
          onSurface: AppColors.iceWhite,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.surface,
          hintStyle: const TextStyle(color: AppColors.slate, fontSize: 13),
          labelStyle: const TextStyle(color: AppColors.slateLight, fontSize: 13),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: AppColors.teal.withValues(alpha: 0.25)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
                color: AppColors.teal.withValues(alpha: 0.2)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.teal, width: 1.5),
          ),
        ),
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.teal
                  : AppColors.slate),
          trackColor: WidgetStateProperty.resolveWith((states) =>
              states.contains(WidgetState.selected)
                  ? AppColors.teal.withValues(alpha: 0.4)
                  : Colors.white12),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

// --- ANIMATED GLASSMORPHIC SPLASH SCREEN ---
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late AnimationController _progressController;
  double _loadingProgress = 0.0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.05).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeIn),
    );

    _logoController.forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..addListener(() {
        setState(() {
          _loadingProgress = _progressController.value;
        });
      });

    _progressController.forward();

    _timer = Timer(const Duration(milliseconds: 3000), () {
      _navigateToHome();
    });
  }

  void _navigateToHome() {
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 800),
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AppRouter(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _logoController.dispose();
    _progressController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const CosmicBackground(),
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 44),
                    borderRadius: 32,
                    borderColor: AppColors.teal.withValues(alpha: 0.35),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 110,
                              height: 110,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.teal.withValues(alpha: 0.4),
                                    AppColors.tealLight.withValues(alpha: 0.1),
                                    Colors.transparent,
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: const LinearGradient(
                                  colors: [Color(0xFF172A45), Color(0xFF0A192F)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                border: Border.all(
                                  color: AppColors.teal.withValues(alpha: 0.6),
                                  width: 2,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.teal.withValues(alpha: 0.35),
                                    blurRadius: 20,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.blur_on_rounded,
                                color: AppColors.teal,
                                size: 44,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'R R E',
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 42,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 8,
                            color: AppColors.iceWhite,
                            shadows: [
                              Shadow(
                                color: AppColors.teal,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'RAJAT RAJ ENTERTAINMENT',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 3,
                            color: AppColors.slateLight.withValues(alpha: 0.8),
                          ),
                        ),
                        const SizedBox(height: 36),
                        Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 4,
                                width: 220,
                                color: Colors.white.withValues(alpha: 0.12),
                                child: Stack(
                                  children: [
                                    FractionallySizedBox(
                                      widthFactor: _loadingProgress,
                                      child: Container(
                                        decoration: const BoxDecoration(
                                          gradient: LinearGradient(
                                            colors: AppColors.primaryGradient,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Initializing AI Engine (${(_loadingProgress * 100).toInt()}%)',
                              style: const TextStyle(
                                fontSize: 11,
                                color: AppColors.slate,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        GestureDetector(
                          onTap: _navigateToHome,
                          child: const Text(
                            'TAP TO ENTER',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                              color: AppColors.teal,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- AUTH ROUTER: Gates entire app on authentication state ---
class AppRouter extends StatelessWidget {
  const AppRouter({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();
    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        if (!authService.isLoggedIn) {
          return AuthLandingScreen(
            onAuthenticated: () {
              // AuthService.notifyListeners() triggers rebuild automatically
            },
          );
        }
        return const MainNavigationScreen();
      },
    );
  }
}

// --- MAIN NAVIGATION SCREEN WITH DRAWER & TABS ---
class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0; // Default to Home
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _openBookingModal() {
    showDialog(
      context: context,
      builder: (context) => EventBookingModal(
        onCompleted: () {
          setState(() {
            _currentIndex = 0;
          });
        },
      ),
    );
  }

  void _openAuthModal() {
    showDialog(
      context: context,
      builder: (context) => AuthModalDialog(
        onSuccess: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Successfully authenticated!'),
              backgroundColor: AppColors.goldPrimary,
            ),
          );
        },
      ),
    );
  }

  void _handleLogout() {
    AuthService().logout();
    // AppRouter ListenableBuilder reactively switches to AuthLandingScreen
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logged out successfully.'),
        backgroundColor: Colors.redAccent,
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    final List<Widget> screens = [
      HomeDashboardScreen(
        onNavigateTab: (index) => setState(() => _currentIndex = index),
        onOpenBooking: _openBookingModal,
      ),
      EventsScreenView(),
      ScanTabManager(),
      ArtistsScreenView(),
      ProfileScreenView(onToggleAuth: _openAuthModal),
      ServicesScreenView(),
      GalleryScreenView(),
      SupportScreenView(),
      AdminDashboardScreenView(),
    ];

    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        return Scaffold(
          key: _scaffoldKey,
          drawer: NavigationDrawerWidget(
            onSelectModule: (index) {
              Navigator.of(context).pop();
              setState(() {
                _currentIndex = index;
              });
            },
            onOpenAuth: _openAuthModal,
            onLogout: _handleLogout,
          ),
          body: Stack(
            children: [
              const CosmicBackground(),
              SafeArea(
                child: Column(
                  children: [
                    // Header Bar
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              GlassIconButton(
                                icon: Icons.menu_rounded,
                                onPressed: () => _scaffoldKey.currentState?.openDrawer(),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF172A45), Color(0xFF0A192F)],
                                  ),
                                  border: Border.all(
                                    color: AppColors.teal.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                ),
                                child: const Icon(Icons.blur_on_rounded, color: AppColors.teal, size: 18),
                              ),
                              const SizedBox(width: 10),
                              const Text(
                                'R R E',
                                style: TextStyle(
                                  fontFamily: 'serif',
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 4,
                                  color: AppColors.iceWhite,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              GlassIconButton(
                                icon: authService.isLoggedIn
                                    ? Icons.account_circle_rounded
                                    : Icons.login_rounded,
                                iconColor: authService.isLoggedIn
                                    ? AppColors.teal
                                    : AppColors.pinkAccent,
                                onPressed: () {
                                  if (authService.isLoggedIn) {
                                    setState(() => _currentIndex = 4); // Go to Profile
                                  } else {
                                    _openAuthModal();
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              GlassIconButton(
                                icon: Icons.notifications_none_rounded,
                                onPressed: () {},
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    Expanded(
                      child: IndexedStack(
                        index: _currentIndex < screens.length ? _currentIndex : 0,
                        children: screens,
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Navigation Bar
              Positioned(
                left: 16,
                right: 16,
                bottom: 20,
                child: GlassBottomNavBar(
                  currentIndex: _currentIndex > 4 ? 0 : _currentIndex,
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// NAVIGATION DRAWER (Access all 15 modules & Authentication)
class NavigationDrawerWidget extends StatelessWidget {
  final ValueChanged<int> onSelectModule;
  final VoidCallback onOpenAuth;
  final VoidCallback onLogout;

  const NavigationDrawerWidget({
    super.key,
    required this.onSelectModule,
    required this.onOpenAuth,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        final isLoggedIn = authService.isLoggedIn;
        final user = authService.currentUser;

        return Drawer(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            borderRadius: 0,
            backgroundColor: AppColors.background.withValues(alpha: 0.96),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User Session Header
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: isLoggedIn
                                  ? AppColors.primaryGradient
                                  : [Colors.grey, Colors.black45],
                            ),
                          ),
                          child: Icon(
                            isLoggedIn ? Icons.person : Icons.person_outline,
                            color: Colors.black,
                            size: 26,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isLoggedIn ? (user?.name ?? 'Arush Sharma') : 'Guest User',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                isLoggedIn
                                    ? 'RRE ${user?.role.name.toUpperCase()} VIP'
                                    : 'Not logged in',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: isLoggedIn
                                      ? AppColors.goldLight
                                      : Colors.white54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(
                            isLoggedIn ? Icons.logout_rounded : Icons.login_rounded,
                            color: isLoggedIn ? Colors.redAccent : AppColors.goldLight,
                            size: 22,
                          ),
                          onPressed: () {
                            Navigator.of(context).pop();
                            if (isLoggedIn) {
                              onLogout();
                            } else {
                              onOpenAuth();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text('RRE APPLICATION MODULES',
                        style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.goldPrimary,
                            letterSpacing: 1.5)),
                  ),
                  const SizedBox(height: 10),

                  Expanded(
                    child: ListView(
                      children: [
                        _drawerTile(Icons.space_dashboard_outlined, 'Home Dashboard', 0),
                        _drawerTile(Icons.event_available_outlined, 'Event Categories & Booking', 1),
                        _drawerTile(Icons.qr_code_scanner_rounded, 'AI Photo Finder & Face Match', 2),
                        _drawerTile(Icons.star_border_rounded, 'Artists & Performers', 3),
                        _drawerTile(Icons.person_outline_rounded, 'My Profile & Security', 4),
                        _drawerTile(Icons.design_services_outlined, 'Sound, Lighting & DJ Services', 5),
                        _drawerTile(Icons.grid_view_rounded, 'Event Media Gallery', 6),
                        _drawerTile(Icons.headset_mic_outlined, 'Contact & Support', 7),
                        const Divider(color: Colors.white24),
                        _drawerTile(Icons.admin_panel_settings_outlined, 'Admin & Analytics Console', 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _drawerTile(IconData icon, String title, int index) {
    return ListTile(
      leading: Icon(icon, color: AppColors.goldLight, size: 20),
      title: Text(title,
          style: const TextStyle(
              color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
      onTap: () => onSelectModule(index),
    );
  }
}
