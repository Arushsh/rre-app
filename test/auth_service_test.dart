import 'package:flutter_test/flutter_test.dart';
import 'package:rre_app/models/app_models.dart';
import 'package:rre_app/services/auth_service.dart';

void main() {
  group('AuthService Production Auth & Security Tests', () {
    late AuthService authService;

    setUp(() {
      authService = AuthService();
    });

    test('Initial user session is unauthenticated (requires login)', () {
      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
      expect(authService.errorMessage, isNull);
    });

    test('Password Strength Evaluator scores correctly', () {
      final weak = AuthService.evaluatePasswordStrength('abc');
      expect(weak['score'], equals(0));
      expect(weak['label'], equals('Weak'));

      final strong = AuthService.evaluatePasswordStrength('RreSecret#2026');
      expect(strong['score'], greaterThanOrEqualTo(4));
      expect(strong['label'], equals('Strong & Secure'));
    });

    test('Login with valid email & password succeeds', () async {
      final success = await authService.loginWithEmail('test@rre.com', 'SecurePass123!');
      expect(success, isTrue);
      expect(authService.isLoggedIn, isTrue);
      expect(authService.currentToken, isNotNull);
      expect(authService.currentToken!.isExpired, isFalse);
    });

    test('Login with invalid password fails with error message', () async {
      final success = await authService.loginWithEmail('test@rre.com', '123');
      expect(success, isFalse);
      expect(authService.errorMessage, contains('Invalid credentials'));
    });

    test('Send Mobile OTP and verify code succeeds', () async {
      final otpSent = await authService.sendMobileOTP('+91 98765 43210');
      expect(otpSent, isTrue);

      final verified = await authService.verifyMobileOTP('+91 98765 43210', '4829');
      expect(verified, isTrue);
      expect(authService.isLoggedIn, isTrue);
    });

    test('User registration with Artist role succeeds', () async {
      final registered = await authService.registerUser(
        name: 'DJ Electra Partner',
        email: 'electra@rre.com',
        phone: '+91 99999 88888',
        password: 'SuperSecretPass#1',
        role: UserRole.artist,
      );

      expect(registered, isTrue);
      expect(authService.currentUser!.role, equals(UserRole.artist));
      expect(authService.currentUser!.name, equals('DJ Electra Partner'));
    });

    test('2FA and Security PIN management updates state and logs', () {
      authService.toggle2FA(true);
      expect(authService.currentUser!.is2FAEnabled, isTrue);

      final pinSet = authService.setSecurityPin('9876');
      expect(pinSet, isTrue);
      expect(authService.currentUser!.hasSecurityPin, isTrue);

      final verified = authService.verifySecurityPin('9876');
      expect(verified, isTrue);
    });

    test('Logout clears current user session', () {
      authService.logout();
      expect(authService.isLoggedIn, isFalse);
      expect(authService.currentUser, isNull);
      expect(authService.currentToken, isNull);
    });
  });
}
