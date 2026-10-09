enum UserRole { client, artist, admin }

class AuthTokenModel {
  final String accessToken;
  final String refreshToken;
  final DateTime expiresAt;

  AuthTokenModel({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);

  Map<String, dynamic> toJson() => {
        'accessToken': accessToken,
        'refreshToken': refreshToken,
        'expiresAt': expiresAt.toIso8601String(),
      };

  factory AuthTokenModel.fromJson(Map<String, dynamic> json) => AuthTokenModel(
        accessToken: json['accessToken'] ?? '',
        refreshToken: json['refreshToken'] ?? '',
        expiresAt: json['expiresAt'] != null
            ? DateTime.parse(json['expiresAt'])
            : DateTime.now().add(const Duration(hours: 24)),
      );
}

class SecurityLogModel {
  final String id;
  final String title;
  final String timestamp;
  final String device;
  final String ipAddress;
  final bool isSuccess;

  SecurityLogModel({
    required this.id,
    required this.title,
    required this.timestamp,
    required this.device,
    required this.ipAddress,
    this.isSuccess = true,
  });
}

class ActiveSessionModel {
  final String id;
  final String deviceName;
  final String location;
  final String lastActive;
  final bool isCurrent;

  ActiveSessionModel({
    required this.id,
    required this.deviceName,
    required this.location,
    required this.lastActive,
    this.isCurrent = false,
  });
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String profilePic;
  final UserRole role;
  final int rewardPoints;
  final String referralCode;
  final bool is2FAEnabled;
  final bool isBiometricEnabled;
  final bool hasSecurityPin;
  final String? securityPin;
  final String lastLogin;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.profilePic,
    this.role = UserRole.client,
    this.rewardPoints = 450,
    this.referralCode = 'RRE-ARUSH-2026',
    this.is2FAEnabled = true,
    this.isBiometricEnabled = false,
    this.hasSecurityPin = false,
    this.securityPin,
    this.lastLogin = 'Just now',
  });

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? profilePic,
    UserRole? role,
    int? rewardPoints,
    String? referralCode,
    bool? is2FAEnabled,
    bool? isBiometricEnabled,
    bool? hasSecurityPin,
    String? securityPin,
    String? lastLogin,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePic: profilePic ?? this.profilePic,
      role: role ?? this.role,
      rewardPoints: rewardPoints ?? this.rewardPoints,
      referralCode: referralCode ?? this.referralCode,
      is2FAEnabled: is2FAEnabled ?? this.is2FAEnabled,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      hasSecurityPin: hasSecurityPin ?? this.hasSecurityPin,
      securityPin: securityPin ?? this.securityPin,
      lastLogin: lastLogin ?? this.lastLogin,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'profilePic': profilePic,
        'role': role.name,
        'rewardPoints': rewardPoints,
        'referralCode': referralCode,
        'is2FAEnabled': is2FAEnabled,
        'isBiometricEnabled': isBiometricEnabled,
        'hasSecurityPin': hasSecurityPin,
        'securityPin': securityPin,
        'lastLogin': lastLogin,
      };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
        id: json['id'] ?? '',
        name: json['name'] ?? '',
        email: json['email'] ?? '',
        phone: json['phone'] ?? '',
        profilePic: json['profilePic'] ?? '',
        role: UserRole.values.firstWhere(
          (r) => r.name == json['role'],
          orElse: () => UserRole.client,
        ),
        rewardPoints: json['rewardPoints'] ?? 0,
        referralCode: json['referralCode'] ?? '',
        is2FAEnabled: json['is2FAEnabled'] ?? false,
        isBiometricEnabled: json['isBiometricEnabled'] ?? false,
        hasSecurityPin: json['hasSecurityPin'] ?? false,
        securityPin: json['securityPin'],
        lastLogin: json['lastLogin'] ?? 'Unknown',
      );
}

class EventModel {
  final String id;
  final String title;
  final String category;
  final String location;
  final String date;
  final String imageUrl;
  final int totalPhotos;
  final bool isFeatured;
  final String priceRange;

  EventModel({
    required this.id,
    required this.title,
    required this.category,
    required this.location,
    required this.date,
    required this.imageUrl,
    required this.totalPhotos,
    this.isFeatured = false,
    required this.priceRange,
  });
}

class ArtistModel {
  final String id;
  final String name;
  final String category; // DJ, Singer, Dancer, Anchor, Orchestra
  final double rating;
  final int reviewCount;
  final String location;
  final String startingPrice;
  final String bio;
  final List<String> tags;

  ArtistModel({
    required this.id,
    required this.name,
    required this.category,
    required this.rating,
    required this.reviewCount,
    required this.location,
    required this.startingPrice,
    required this.bio,
    required this.tags,
  });
}

class BookingModel {
  final String id;
  final String eventType;
  final String date;
  final String venue;
  final String budget;
  final String status; // Pending, Confirmed, In Progress, Completed
  final String totalAmount;

  BookingModel({
    required this.id,
    required this.eventType,
    required this.date,
    required this.venue,
    required this.budget,
    required this.status,
    required this.totalAmount,
  });
}

class ServiceModel {
  final String id;
  final String title;
  final String description;
  final String iconName;
  final String price;

  ServiceModel({
    required this.id,
    required this.title,
    required this.description,
    required this.iconName,
    required this.price,
  });
}
