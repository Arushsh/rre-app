import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../models/app_models.dart';
import '../widgets/app_widgets.dart';
import '../services/auth_service.dart';

class AuthModalDialog extends StatefulWidget {
  final VoidCallback onSuccess;
  final int initialMode; // 0: Login, 1: Register, 2: OTP, 3: Reset

  const AuthModalDialog({
    super.key,
    required this.onSuccess,
    this.initialMode = 0,
  });

  @override
  State<AuthModalDialog> createState() => _AuthModalDialogState();
}

class _AuthModalDialogState extends State<AuthModalDialog> {
  late int _mode; // 0: Login, 1: Register, 2: OTP, 3: Reset
  bool _useOtpLogin = true;
  bool _obscurePassword = true;

  final _phoneController = TextEditingController(text: '+91 98765 43210');
  final _emailController = TextEditingController(text: 'arush@rre.com');
  final _passwordController = TextEditingController(text: 'RreSecret#2026');
  final _nameController = TextEditingController(text: 'Arush Sharma');
  final _otpController = TextEditingController(text: '4829');

  UserRole _selectedRole = UserRole.client;
  Timer? _countdownTimer;
  int _otpCountdown = 60;
  bool _canResendOtp = false;

  @override
  void initState() {
    super.initState();
    _mode = widget.initialMode;
    if (_mode == 2) _startOtpTimer();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startOtpTimer() {
    _countdownTimer?.cancel();
    setState(() {
      _otpCountdown = 60;
      _canResendOtp = false;
    });
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_otpCountdown > 0) {
        setState(() => _otpCountdown--);
      } else {
        setState(() => _canResendOtp = true);
        timer.cancel();
      }
    });
  }

  Future<void> _handleLogin(AuthService authService) async {
    if (_useOtpLogin) {
      final success = await authService.sendMobileOTP(_phoneController.text);
      if (success && mounted) {
        setState(() => _mode = 2);
        _startOtpTimer();
      }
    } else {
      final success = await authService.loginWithEmail(
        _emailController.text,
        _passwordController.text,
      );
      if (success && mounted) {
        Navigator.of(context).pop();
        widget.onSuccess();
      }
    }
  }

  Future<void> _handleRegister(AuthService authService) async {
    final success = await authService.registerUser(
      name: _nameController.text,
      email: _emailController.text,
      phone: _phoneController.text,
      password: _passwordController.text,
      role: _selectedRole,
    );
    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onSuccess();
    }
  }

  Future<void> _handleVerifyOtp(AuthService authService) async {
    final success = await authService.verifyMobileOTP(
      _phoneController.text,
      _otpController.text,
    );
    if (success && mounted) {
      Navigator.of(context).pop();
      widget.onSuccess();
    }
  }

  Future<void> _handleResetPassword(AuthService authService) async {
    final success = await authService.requestPasswordReset(_emailController.text);
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle, color: Colors.black),
              SizedBox(width: 10),
              Text('Password reset link sent to your email!'),
            ],
          ),
          backgroundColor: AppColors.goldPrimary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          behavior: SnackBarBehavior.floating,
        ),
      );
      setState(() => _mode = 0);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: GlassCard(
            padding: const EdgeInsets.all(22),
            borderRadius: 28,
            borderColor: AppColors.goldPrimary.withValues(alpha: 0.4),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // --- HEADER BAR ---
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.goldPrimary.withValues(alpha: 0.3),
                                  AppColors.pinkAccent.withValues(alpha: 0.2),
                                ],
                              ),
                            ),
                            child: const Icon(
                              Icons.verified_user_rounded,
                              color: AppColors.goldPrimary,
                              size: 24,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _mode == 0
                                ? 'Access Account'
                                : _mode == 1
                                    ? 'Create Account'
                                    : _mode == 2
                                        ? 'Security Verification'
                                        : 'Reset Password',
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.close_rounded, color: Colors.white70),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // --- ERROR BANNER ---
                  if (authService.errorMessage != null) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.redAccent.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.redAccent.withValues(alpha: 0.4)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              authService.errorMessage!,
                              style: const TextStyle(color: Colors.white, fontSize: 12),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white60, size: 16),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(),
                            onPressed: () => authService.clearError(),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),
                  ],

                  // --- MODE 0: LOGIN ---
                  if (_mode == 0) ...[
                    // LOGIN METHOD SWITCHER (OTP VS PASSWORD)
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _useOtpLogin = true),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: _useOtpLogin
                                      ? const LinearGradient(colors: AppColors.primaryGradient)
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Mobile OTP',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: _useOtpLogin ? Colors.black : Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: GestureDetector(
                              onTap: () => setState(() => _useOtpLogin = false),
                              child: Container(
                                padding: const EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                  gradient: !_useOtpLogin
                                      ? const LinearGradient(colors: AppColors.primaryGradient)
                                      : null,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  'Email & Password',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: !_useOtpLogin ? Colors.black : Colors.white70,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    if (_useOtpLogin) ...[
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        borderRadius: 16,
                        child: TextField(
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.phone_android_rounded, color: AppColors.goldPrimary),
                            hintText: 'Mobile Number (+91)',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ] else ...[
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        borderRadius: 16,
                        child: TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            icon: Icon(Icons.email_outlined, color: AppColors.goldPrimary),
                            hintText: 'Email Address',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      GlassCard(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                        borderRadius: 16,
                        child: TextField(
                          controller: _passwordController,
                          obscureText: _obscurePassword,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            icon: const Icon(Icons.lock_outline_rounded, color: AppColors.goldPrimary),
                            hintText: 'Password',
                            border: InputBorder.none,
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.white54,
                              ),
                              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () => setState(() => _mode = 3),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: AppColors.goldLight, fontSize: 12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    authService.isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary))
                        : GradientPillButton(
                            label: _useOtpLogin ? 'SEND OTP CODE' : 'LOGIN TO ACCOUNT',
                            icon: _useOtpLogin ? Icons.sms_rounded : Icons.login_rounded,
                            onPressed: () => _handleLogin(authService),
                          ),

                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () => setState(() => _mode = 1),
                      child: const Text(
                        "Don't have an account? Register Now",
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ]

                  // --- MODE 1: REGISTER ---
                  else if (_mode == 1) ...[
                    // ROLE SELECTION
                    const Text(
                      'Account Type:',
                      style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _RoleChip(
                            label: 'Event Booker',
                            subtitle: 'Client Access',
                            icon: Icons.person_rounded,
                            isSelected: _selectedRole == UserRole.client,
                            onTap: () => setState(() => _selectedRole = UserRole.client),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _RoleChip(
                            label: 'RRE Artist',
                            subtitle: 'Partner/Perform',
                            icon: Icons.mic_external_on_rounded,
                            isSelected: _selectedRole == UserRole.artist,
                            onTap: () => setState(() => _selectedRole = UserRole.artist),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      borderRadius: 16,
                      child: TextField(
                        controller: _nameController,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.person_outline, color: AppColors.goldPrimary),
                          hintText: 'Full Name',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      borderRadius: 16,
                      child: TextField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.phone_android, color: AppColors.goldPrimary),
                          hintText: 'Mobile Phone',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      borderRadius: 16,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email_outlined, color: AppColors.goldPrimary),
                          hintText: 'Email Address',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      borderRadius: 16,
                      child: TextField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        onChanged: (val) => setState(() {}),
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          icon: const Icon(Icons.lock_outline_rounded, color: AppColors.goldPrimary),
                          hintText: 'Create Password',
                          border: InputBorder.none,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white54,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // REAL-TIME PASSWORD STRENGTH INDICATOR
                    _PasswordStrengthWidget(password: _passwordController.text),

                    const SizedBox(height: 16),

                    authService.isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary))
                        : GradientPillButton(
                            label: 'REGISTER & CREATE ACCOUNT',
                            icon: Icons.person_add_alt_1_rounded,
                            onPressed: () => _handleRegister(authService),
                          ),

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => setState(() => _mode = 0),
                      child: const Text(
                        'Already registered? Back to Login',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ]

                  // --- MODE 2: OTP VERIFICATION ---
                  else if (_mode == 2) ...[
                    Text(
                      'We sent a 4-digit security code to\n${_phoneController.text}',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.75)),
                    ),
                    const SizedBox(height: 18),

                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      borderRadius: 16,
                      child: TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.goldLight,
                          fontSize: 24,
                          letterSpacing: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: '• • • •',
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    // OTP DEMO AUTOFILL HELPER
                    GestureDetector(
                      onTap: () {
                        setState(() => _otpController.text = '4829');
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.goldPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.goldPrimary.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.touch_app_rounded, color: AppColors.goldPrimary, size: 14),
                            SizedBox(width: 6),
                            Text(
                              'Tap to Auto-fill Demo OTP: 4829',
                              style: TextStyle(color: AppColors.goldLight, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timer_outlined,
                          size: 14,
                          color: _otpCountdown > 0 ? AppColors.goldLight : Colors.white38,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _otpCountdown > 0 ? 'Resend code in ${_otpCountdown}s' : 'Code expired',
                          style: TextStyle(
                            fontSize: 12,
                            color: _otpCountdown > 0 ? AppColors.goldLight : Colors.white38,
                          ),
                        ),
                        if (_canResendOtp) ...[
                          TextButton(
                            onPressed: () {
                              authService.sendMobileOTP(_phoneController.text);
                              _startOtpTimer();
                            },
                            child: const Text('Resend OTP', style: TextStyle(color: AppColors.pinkAccent, fontSize: 12)),
                          ),
                        ],
                      ],
                    ),

                    const SizedBox(height: 18),

                    authService.isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary))
                        : GradientPillButton(
                            label: 'VERIFY CODE & LOGIN',
                            icon: Icons.shield_rounded,
                            onPressed: () => _handleVerifyOtp(authService),
                          ),

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => setState(() => _mode = 0),
                      child: const Text('Back to Login', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                  ]

                  // --- MODE 3: FORGOT PASSWORD ---
                  else ...[
                    Text(
                      'Enter your registered email address to receive a secure password reset link.',
                      style: TextStyle(fontSize: 12, color: Colors.white.withValues(alpha: 0.7)),
                    ),
                    const SizedBox(height: 16),

                    GlassCard(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 2),
                      borderRadius: 16,
                      child: TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          icon: Icon(Icons.email_outlined, color: AppColors.goldPrimary),
                          hintText: 'Email Address',
                          border: InputBorder.none,
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    authService.isLoading
                        ? const Center(child: CircularProgressIndicator(color: AppColors.goldPrimary))
                        : GradientPillButton(
                            label: 'SEND RESET LINK',
                            icon: Icons.send_rounded,
                            onPressed: () => _handleResetPassword(authService),
                          ),

                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () => setState(() => _mode = 0),
                      child: const Text('Back to Login', style: TextStyle(color: Colors.white70, fontSize: 12)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Role chip selector widget
class _RoleChip extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _RoleChip({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.goldPrimary.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? AppColors.goldPrimary : Colors.white24,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 20,
              color: isSelected ? AppColors.goldPrimary : Colors.white60,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.white70,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 9,
                color: isSelected ? AppColors.goldLight : Colors.white38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Password Strength Meter Widget
class _PasswordStrengthWidget extends StatelessWidget {
  final String password;

  const _PasswordStrengthWidget({required this.password});

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    final result = AuthService.evaluatePasswordStrength(password);
    final double percent = result['percent'] as double;
    final String label = result['label'] as String;
    final bool hasMinLength = result['hasMinLength'] as bool;
    final bool hasUppercase = result['hasUppercase'] as bool;
    final bool hasDigits = result['hasDigits'] as bool;
    final bool hasSpecial = result['hasSpecial'] as bool;

    Color progressColor = Colors.redAccent;
    if (percent >= 0.75) progressColor = AppColors.goldPrimary;
    if (percent >= 1.0) progressColor = Colors.greenAccent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Password Strength:', style: TextStyle(fontSize: 10, color: Colors.white54)),
            Text(
              label,
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: progressColor),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percent,
            minHeight: 5,
            backgroundColor: Colors.white12,
            valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 12,
          runSpacing: 4,
          children: [
            _CriteriaBadge(label: '8+ chars', isMet: hasMinLength),
            _CriteriaBadge(label: 'A-Z', isMet: hasUppercase),
            _CriteriaBadge(label: '0-9', isMet: hasDigits),
            _CriteriaBadge(label: 'Symbol (!@#)', isMet: hasSpecial),
          ],
        ),
      ],
    );
  }
}

class _CriteriaBadge extends StatelessWidget {
  final String label;
  final bool isMet;

  const _CriteriaBadge({required this.label, required this.isMet});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          isMet ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
          size: 11,
          color: isMet ? Colors.greenAccent : Colors.white30,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 9,
            color: isMet ? Colors.white70 : Colors.white30,
          ),
        ),
      ],
    );
  }
}
