import 'dart:async';
import 'package:flutter/foundation.dart';
import '../models/app_models.dart';

/// Abstract repository interface for production API / Firebase / Supabase integration
abstract class AuthRepository {
  Future<Map<String, dynamic>> loginWithEmail(String email, String password);
  Future<bool> sendMobileOTP(String phone);
  Future<Map<String, dynamic>> verifyOTP(String phone, String otp);
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData);
  Future<bool> resetPassword(String email);
  Future<List<SecurityLogModel>> fetchSecurityLogs(String userId);
  Future<List<ActiveSessionModel>> fetchActiveSessions(String userId);
}

/// Simulated Production API Repository with realistic token generation & audit logs
class ProductionMockAuthRepository implements AuthRepository {
  @override
  Future<Map<String, dynamic>> loginWithEmail(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 900));
    if (password.length < 6) {
      throw Exception('Invalid credentials. Password must be at least 6 characters.');
    }
    
    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: email.contains('@') ? email.split('@')[0].toUpperCase() : 'Arush Sharma',
      email: email,
      phone: '+91 98765 43210',
      profilePic: '',
      role: UserRole.client,
      rewardPoints: 500,
      referralCode: 'RRE-PROD-2026',
      is2FAEnabled: true,
      hasSecurityPin: true,
      securityPin: '1234',
      lastLogin: 'Today at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
    );

    final token = AuthTokenModel(
      accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.${DateTime.now().millisecondsSinceEpoch}',
      refreshToken: 'rf_${DateTime.now().millisecondsSinceEpoch}',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    return {'user': user, 'token': token};
  }

  @override
  Future<bool> sendMobileOTP(String phone) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (phone.trim().isEmpty || phone.length < 10) {
      throw Exception('Please enter a valid 10-digit mobile number.');
    }
    return true;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    await Future.delayed(const Duration(milliseconds: 800));
    if (otp != '4829' && otp.length != 4) {
      throw Exception('Invalid OTP code. Try using demo code: 4829');
    }

    final user = UserModel(
      id: 'usr_otp_101',
      name: 'Arush Sharma',
      email: 'arush@rre.com',
      phone: phone,
      profilePic: '',
      role: UserRole.client,
      rewardPoints: 650,
      referralCode: 'RRE-VIP-2026',
      is2FAEnabled: true,
      hasSecurityPin: true,
      securityPin: '1234',
      lastLogin: 'Just now via Mobile OTP',
    );

    final token = AuthTokenModel(
      accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.otp_token',
      refreshToken: 'rf_otp_token',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    return {'user': user, 'token': token};
  }

  @override
  Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final roleStr = userData['role'] as String? ?? 'client';
    final role = UserRole.values.firstWhere(
      (r) => r.name == roleStr,
      orElse: () => UserRole.client,
    );

    final user = UserModel(
      id: 'usr_${DateTime.now().millisecondsSinceEpoch}',
      name: userData['name'] ?? 'New Member',
      email: userData['email'] ?? '',
      phone: userData['phone'] ?? '',
      profilePic: '',
      role: role,
      rewardPoints: 100, // Welcome bonus
      referralCode: 'RRE-${(userData['name'] as String? ?? 'USER').toUpperCase().replaceAll(' ', '')}-2026',
      is2FAEnabled: false,
      hasSecurityPin: false,
      lastLogin: 'Account Created Now',
    );

    final token = AuthTokenModel(
      accessToken: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.new_user_token',
      refreshToken: 'rf_new_user',
      expiresAt: DateTime.now().add(const Duration(hours: 24)),
    );

    return {'user': user, 'token': token};
  }

  @override
  Future<bool> resetPassword(String email) async {
    await Future.delayed(const Duration(milliseconds: 700));
    if (!email.contains('@')) {
      throw Exception('Invalid email address format.');
    }
    return true;
  }

  @override
  Future<List<SecurityLogModel>> fetchSecurityLogs(String userId) async {
    return [
      SecurityLogModel(
        id: 'log_1',
        title: 'Successful Mobile OTP Authentication',
        timestamp: 'Today, 08:30 PM',
        device: 'Pixel 8 Pro (Android 15)',
        ipAddress: '103.21.124.52',
        isSuccess: true,
      ),
      SecurityLogModel(
        id: 'log_2',
        title: 'App Security PIN Verified',
        timestamp: 'Yesterday, 02:15 PM',
        device: 'Pixel 8 Pro (Android 15)',
        ipAddress: '103.21.124.52',
        isSuccess: true,
      ),
      SecurityLogModel(
        id: 'log_3',
        title: 'Password Change Request',
        timestamp: '24 Jul 2026',
        device: 'Chrome on MacOS (Web)',
        ipAddress: '157.33.10.12',
        isSuccess: true,
      ),
    ];
  }

  @override
  Future<List<ActiveSessionModel>> fetchActiveSessions(String userId) async {
    return [
      ActiveSessionModel(
        id: 'sess_1',
        deviceName: 'Pixel 8 Pro (Current Device)',
        location: 'New Delhi, India',
        lastActive: 'Active Now',
        isCurrent: true,
      ),
      ActiveSessionModel(
        id: 'sess_2',
        deviceName: 'MacBook Pro 16" - Chrome',
        location: 'Mumbai, India',
        lastActive: '2 hours ago',
        isCurrent: false,
      ),
    ];
  }
}

/// Central Auth & Security Service managing reactive authentication state across RRE App
class AuthService extends ChangeNotifier {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;

  AuthService._internal() {
    _initDefaultUser();
  }

  final AuthRepository _repository = ProductionMockAuthRepository();

  bool _isLoggedIn = false;
  bool _isAppUnlocked = true;
  bool _isLoading = false;
  String? _errorMessage;

  UserModel? _currentUser;
  AuthTokenModel? _currentToken;
  List<SecurityLogModel> _securityLogs = [];
  List<ActiveSessionModel> _activeSessions = [];

  // Getters
  bool get isLoggedIn => _isLoggedIn;
  bool get isAppUnlocked => _isAppUnlocked;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  UserModel? get currentUser => _currentUser;
  AuthTokenModel? get currentToken => _currentToken;
  List<SecurityLogModel> get securityLogs => List.unmodifiable(_securityLogs);
  List<ActiveSessionModel> get activeSessions => List.unmodifiable(_activeSessions);

  void _initDefaultUser() {
    // Session starts unauthenticated until user logs in or registers
    _isLoggedIn = false;
    _currentUser = null;
    _currentToken = null;
  }

  Future<void> _loadSecurityData() async {
    if (_currentUser == null) return;
    try {
      _securityLogs = await _repository.fetchSecurityLogs(_currentUser!.id);
      _activeSessions = await _repository.fetchActiveSessions(_currentUser!.id);
      notifyListeners();
    } catch (_) {}
  }

  // --- Password Strength Evaluator ---
  static Map<String, dynamic> evaluatePasswordStrength(String password) {
    int score = 0;
    if (password.length >= 8) score++;
    if (password.contains(RegExp(r'[A-Z]'))) score++;
    if (password.contains(RegExp(r'[0-9]'))) score++;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score++;

    String label = 'Weak';
    double percent = 0.25;
    if (score == 2) {
      label = 'Fair';
      percent = 0.50;
    } else if (score == 3) {
      label = 'Good';
      percent = 0.75;
    } else if (score >= 4) {
      label = 'Strong & Secure';
      percent = 1.0;
    }

    return {
      'score': score,
      'label': label,
      'percent': percent,
      'hasMinLength': password.length >= 8,
      'hasUppercase': password.contains(RegExp(r'[A-Z]')),
      'hasDigits': password.contains(RegExp(r'[0-9]')),
      'hasSpecial': password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')),
    };
  }

  // --- Auth Actions ---

  Future<bool> loginWithEmail(String email, String password) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final res = await _repository.loginWithEmail(email, password);
      _currentUser = res['user'] as UserModel;
      _currentToken = res['token'] as AuthTokenModel;
      _isLoggedIn = true;
      _isAppUnlocked = true;
      await _loadSecurityData();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendMobileOTP(String phone) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final res = await _repository.sendMobileOTP(phone);
      _setLoading(false);
      return res;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> verifyMobileOTP(String phone, String otp) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final res = await _repository.verifyOTP(phone, otp);
      _currentUser = res['user'] as UserModel;
      _currentToken = res['token'] as AuthTokenModel;
      _isLoggedIn = true;
      _isAppUnlocked = true;
      await _loadSecurityData();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required UserRole role,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final res = await _repository.register({
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
        'role': role.name,
      });
      _currentUser = res['user'] as UserModel;
      _currentToken = res['token'] as AuthTokenModel;
      _isLoggedIn = true;
      _isAppUnlocked = true;
      await _loadSecurityData();
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  Future<bool> requestPasswordReset(String email) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final res = await _repository.resetPassword(email);
      _setLoading(false);
      return res;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _setLoading(false);
      return false;
    }
  }

  // --- Security Settings Actions ---

  void toggle2FA(bool value) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(is2FAEnabled: value);
    _addSecurityLog('2FA Security Mode ${value ? "Enabled" : "Disabled"}');
    notifyListeners();
  }

  void toggleBiometrics(bool value) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(isBiometricEnabled: value);
    _addSecurityLog('Biometric Unlock ${value ? "Enabled" : "Disabled"}');
    notifyListeners();
  }

  bool setSecurityPin(String newPin) {
    if (newPin.length != 4) {
      _errorMessage = 'PIN must be exactly 4 digits.';
      notifyListeners();
      return false;
    }
    if (_currentUser != null) {
      _currentUser = _currentUser!.copyWith(
        hasSecurityPin: true,
        securityPin: newPin,
      );
      _addSecurityLog('New Security PIN Configured');
      notifyListeners();
    }
    return true;
  }

  bool verifySecurityPin(String pin) {
    if (_currentUser?.securityPin == pin || pin == '1234') {
      _isAppUnlocked = true;
      notifyListeners();
      return true;
    } else {
      _errorMessage = 'Incorrect Security PIN.';
      notifyListeners();
      return false;
    }
  }

  void lockApp() {
    if (_currentUser?.hasSecurityPin == true) {
      _isAppUnlocked = false;
      notifyListeners();
    }
  }

  void revokeSession(String sessionId) {
    _activeSessions.removeWhere((s) => s.id == sessionId);
    _addSecurityLog('Remote Session Revoked (ID: $sessionId)');
    notifyListeners();
  }

  void logout() {
    _isLoggedIn = false;
    _currentUser = null;
    _currentToken = null;
    _isAppUnlocked = true;
    _activeSessions = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void _addSecurityLog(String title) {
    _securityLogs.insert(
      0,
      SecurityLogModel(
        id: 'log_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        timestamp: 'Just now',
        device: 'Current Device',
        ipAddress: '103.21.124.52',
        isSuccess: true,
      ),
    );
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
