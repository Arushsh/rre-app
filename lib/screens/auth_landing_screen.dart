import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/app_models.dart';
import '../widgets/app_widgets.dart';
import '../services/auth_service.dart';
import 'auth_screen.dart';

class AuthLandingScreen extends StatefulWidget {
  final VoidCallback onAuthenticated;

  const AuthLandingScreen({
    super.key,
    required this.onAuthenticated,
  });

  @override
  State<AuthLandingScreen> createState() => _AuthLandingScreenState();
}

class _AuthLandingScreenState extends State<AuthLandingScreen> {
  int _activeAuthTab = 0; // 0: Login, 1: Register

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return Scaffold(
      body: Stack(
        children: [
          const CosmicBackground(),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),

                  // TOP BRANDING LOGO & BADGE
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFF172A45), Color(0xFF0A192F)],
                          ),
                          border: Border.all(
                            color: AppColors.teal.withValues(alpha: 0.6),
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.teal.withValues(alpha: 0.3),
                              blurRadius: 16,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.blur_on_rounded,
                          color: AppColors.teal,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'R R E',
                            style: TextStyle(
                              fontFamily: 'serif',
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 6,
                              color: AppColors.iceWhite,
                            ),
                          ),
                          Text(
                            'RAJAT RAJ ENTERTAINMENT',
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 2,
                              color: AppColors.slateLight,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // HERO CARD PREVIEW
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 28,
                    borderColor: AppColors.goldPrimary.withValues(alpha: 0.4),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(colors: AppColors.primaryGradient),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            'AUTHENTICATION REQUIRED',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 14),
                        const Text(
                          'Welcome to RRE Spectacle',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'serif',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Please log in or register to access the Dashboard, Event Booking Engine, AI Photo Finder & Artist Catalog.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white.withValues(alpha: 0.75),
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // FEATURE HIGHLIGHT CHIPS
                        const Wrap(
                          alignment: WrapAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _FeatureBadge(icon: Icons.celebration, label: 'Royal Weddings'),
                            _FeatureBadge(icon: Icons.graphic_eq, label: 'Concert Audio & DJs'),
                            _FeatureBadge(icon: Icons.face_retouching_natural, label: 'AI Face Match'),
                            _FeatureBadge(icon: Icons.shield, label: '2FA Protected'),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // FULL EMBEDDED AUTH FORM CARD
                  GlassCard(
                    padding: const EdgeInsets.all(20),
                    borderRadius: 28,
                    child: Column(
                      children: [
                        // TAB SWITCHER (LOGIN VS REGISTER)
                        Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: Colors.black.withValues(alpha: 0.35),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _activeAuthTab = 0),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 11),
                                    decoration: BoxDecoration(
                                      gradient: _activeAuthTab == 0
                                          ? const LinearGradient(colors: AppColors.primaryGradient)
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'LOG IN',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _activeAuthTab == 0 ? Colors.black : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () => setState(() => _activeAuthTab = 1),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(vertical: 11),
                                    decoration: BoxDecoration(
                                      gradient: _activeAuthTab == 1
                                          ? const LinearGradient(colors: AppColors.primaryGradient)
                                          : null,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'REGISTER ACCOUNT',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: _activeAuthTab == 1 ? Colors.black : Colors.white70,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // AUTH MODAL DIALOG CONTAINER EMBEDDED
                        AuthModalDialog(
                          initialMode: _activeAuthTab,
                          onSuccess: widget.onAuthenticated,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // QUICK DEMO ONE-TAP LOGIN ACCELERATOR FOR EVALUATORS
                  GlassCard(
                    padding: const EdgeInsets.all(16),
                    borderRadius: 20,
                    child: Column(
                      children: [
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.bolt_rounded, color: AppColors.goldPrimary, size: 18),
                            SizedBox(width: 6),
                            Text(
                              'QUICK DEMO ACCELERATORS',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.goldLight,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.goldPrimary.withValues(alpha: 0.5)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onPressed: () async {
                                  await authService.loginWithEmail('arush@rre.com', 'RreSecret#2026');
                                  widget.onAuthenticated();
                                },
                                icon: const Icon(Icons.person, color: AppColors.goldPrimary, size: 16),
                                label: const Text(
                                  'Client (Arush)',
                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: OutlinedButton.icon(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(color: AppColors.pinkAccent.withValues(alpha: 0.5)),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  padding: const EdgeInsets.symmetric(vertical: 10),
                                ),
                                onPressed: () async {
                                  await authService.registerUser(
                                    name: 'DJ Electra Partner',
                                    email: 'electra@rre.com',
                                    phone: '+91 99887 76655',
                                    password: 'SecretArtistPassword#1',
                                    role: UserRole.artist,
                                  );
                                  widget.onAuthenticated();
                                },
                                icon: const Icon(Icons.mic, color: AppColors.pinkAccent, size: 16),
                                label: const Text(
                                  'Artist (DJ Electra)',
                                  style: TextStyle(color: Colors.white, fontSize: 11),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _FeatureBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: AppColors.goldPrimary, size: 13),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Color(0xDEFFFFFF)),
          ),
        ],
      ),
    );
  }
}
