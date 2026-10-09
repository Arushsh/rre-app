import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_widgets.dart';
import '../services/auth_service.dart';

class SecurityDashboardWidget extends StatefulWidget {
  const SecurityDashboardWidget({super.key});

  @override
  State<SecurityDashboardWidget> createState() => _SecurityDashboardWidgetState();
}

class _SecurityDashboardWidgetState extends State<SecurityDashboardWidget> {
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _showSetPinDialog(BuildContext context, AuthService authService) {
    _pinController.clear();
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: GlassCard(
            padding: const EdgeInsets.all(22),
            borderRadius: 24,
            borderColor: AppColors.goldPrimary.withValues(alpha: 0.5),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.shield_moon_rounded, color: AppColors.goldPrimary, size: 36),
                const SizedBox(height: 12),
                const Text(
                  'Set 4-Digit Security PIN',
                  style: TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 6),
                const Text(
                  'This PIN will be required to unlock sensitive booking actions & app access.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                GlassCard(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  borderRadius: 16,
                  child: TextField(
                    controller: _pinController,
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    obscureText: true,
                    maxLength: 4,
                    style: const TextStyle(
                      color: AppColors.goldLight,
                      fontSize: 22,
                      letterSpacing: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      counterText: '',
                      hintText: '• • • •',
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GradientPillButton(
                  label: 'SAVE PIN CODE',
                  icon: Icons.check_circle_rounded,
                  onPressed: () {
                    if (authService.setSecurityPin(_pinController.text)) {
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Security PIN successfully configured!'),
                          backgroundColor: AppColors.goldPrimary,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return ListenableBuilder(
      listenable: authService,
      builder: (context, _) {
        final user = authService.currentUser;
        if (user == null) return const SizedBox.shrink();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Security & Privacy Control',
              style: TextStyle(
                fontFamily: 'serif',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),

            // SECURITY HEALTH CARD
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              borderColor: AppColors.goldPrimary.withValues(alpha: 0.3),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldPrimary.withValues(alpha: 0.15),
                        ),
                        child: const Icon(Icons.security_rounded, color: AppColors.goldPrimary, size: 28),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text(
                                  'Security Health',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.greenAccent.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.5)),
                                  ),
                                  child: const Text(
                                    '95% EXCELLENT',
                                    style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.greenAccent),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Account Role: ${user.role.name.toUpperCase()} • JWT Token Encrypted',
                              style: const TextStyle(fontSize: 10, color: Colors.white60),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: Colors.white12, height: 24),

                  // TOGGLES LIST
                  _SecurityToggleRow(
                    icon: Icons.phonelink_lock_rounded,
                    title: 'Two-Factor Authentication (2FA)',
                    subtitle: 'Require OTP verification for unrecognized devices',
                    value: user.is2FAEnabled,
                    onChanged: (val) => authService.toggle2FA(val),
                  ),
                  const SizedBox(height: 12),
                  _SecurityToggleRow(
                    icon: Icons.fingerprint_rounded,
                    title: 'Biometric / Face Recognition',
                    subtitle: 'Use device biometrics for quick app unlock',
                    value: user.isBiometricEnabled,
                    onChanged: (val) => authService.toggleBiometrics(val),
                  ),
                  const SizedBox(height: 12),

                  // PIN ACTION
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.pin_rounded, color: AppColors.goldPrimary, size: 20),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'App Security PIN',
                                style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                              ),
                              Text(
                                user.hasSecurityPin ? 'PIN Configured (4-digits)' : 'No PIN set yet',
                                style: const TextStyle(fontSize: 10, color: Colors.white54),
                              ),
                            ],
                          ),
                        ],
                      ),
                      OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: AppColors.goldPrimary.withValues(alpha: 0.6)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        onPressed: () => _showSetPinDialog(context, authService),
                        child: Text(
                          user.hasSecurityPin ? 'Change PIN' : 'Set PIN',
                          style: const TextStyle(fontSize: 11, color: AppColors.goldLight),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // ACTIVE SESSIONS & DEVICES
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Active Devices & Sessions',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Icon(Icons.devices_rounded, color: AppColors.goldPrimary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...authService.activeSessions.map((session) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: session.isCurrent
                            ? AppColors.goldPrimary.withValues(alpha: 0.1)
                            : Colors.white.withValues(alpha: 0.04),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: session.isCurrent
                              ? AppColors.goldPrimary.withValues(alpha: 0.3)
                              : Colors.white10,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            session.deviceName.contains('Pixel') ? Icons.phone_android : Icons.laptop_mac,
                            color: session.isCurrent ? AppColors.goldPrimary : Colors.white70,
                            size: 20,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  session.deviceName,
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: session.isCurrent ? Colors.white : Colors.white70,
                                  ),
                                ),
                                Text(
                                  '${session.location} • ${session.lastActive}',
                                  style: const TextStyle(fontSize: 10, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          if (!session.isCurrent) ...[
                            IconButton(
                              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent, size: 18),
                              onPressed: () => authService.revokeSession(session.id),
                            ),
                          ] else ...[
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.goldPrimary.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                'Current',
                                style: TextStyle(fontSize: 9, color: AppColors.goldLight, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),

            const SizedBox(height: 18),

            // SECURITY AUDIT LOGS
            GlassCard(
              padding: const EdgeInsets.all(16),
              borderRadius: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Security Activity Log',
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      Icon(Icons.history_rounded, color: AppColors.goldPrimary, size: 18),
                    ],
                  ),
                  const SizedBox(height: 12),

                  ...authService.securityLogs.map((log) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Icon(
                            log.isSuccess ? Icons.check_circle_outline : Icons.warning_amber_rounded,
                            color: log.isSuccess ? Colors.greenAccent : Colors.redAccent,
                            size: 16,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.title,
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white70),
                                ),
                                Text(
                                  '${log.timestamp} • ${log.device} (${log.ipAddress})',
                                  style: const TextStyle(fontSize: 9, color: Colors.white38),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _SecurityToggleRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SecurityToggleRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(icon, color: AppColors.goldPrimary, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(fontSize: 10, color: Colors.white54),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Switch.adaptive(
          value: value,
          activeTrackColor: AppColors.teal.withValues(alpha: 0.5),
          activeThumbColor: AppColors.teal,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
