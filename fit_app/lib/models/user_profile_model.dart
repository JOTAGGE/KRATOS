
enum AppThemeStyle { standard, cyberpunk, synthwave, rockMetal }

class UserProfile {
  final String uid;
  final String name;
  final String nickname;
  final String email;
  final String phone;
  final String bio;
  final String photoUrl;
  
  // Customização Visual
  final int seedColorValue;
  final bool isDarkMode;
  final AppThemeStyle themeStyle;

  // Configurações
  final String unitSystem; // 'metric' ou 'imperial'
  final String language;   // 'pt_BR', 'en_US'

  UserProfile({
    required this.uid,
    required this.name,
    required this.nickname,
    required this.email,
    required this.phone,
    required this.bio,
    required this.photoUrl,
    this.seedColorValue = 0xFF6750A4, // Colors.deepPurple por padrão
    this.isDarkMode = true,
    this.themeStyle = AppThemeStyle.standard,
    this.unitSystem = 'metric',
    this.language = 'pt_BR',
  });

  factory UserProfile.fromJson(Map<String, dynamic> json, String uid) {
    return UserProfile(
      uid: uid,
      name: json['name'] ?? 'Atleta',
      nickname: json['nickname'] ?? '@atleta',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      bio: json['bio'] ?? 'Foco no processo!',
      photoUrl: json['photoUrl'] ?? '',
      seedColorValue: json['seedColorValue'] ?? 0xFF6750A4,
      isDarkMode: json['isDarkMode'] ?? true,
      themeStyle: AppThemeStyle.values[json['themeStyle'] ?? 0],
      unitSystem: json['unitSystem'] ?? 'metric',
      language: json['language'] ?? 'pt_BR',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'nickname': nickname,
      'email': email,
      'phone': phone,
      'bio': bio,
      'photoUrl': photoUrl,
      'seedColorValue': seedColorValue,
      'isDarkMode': isDarkMode,
      'themeStyle': themeStyle.index,
      'unitSystem': unitSystem,
      'language': language,
    };
  }

  UserProfile copyWith({
    String? name,
    String? nickname,
    String? bio,
    String? photoUrl,
    int? seedColorValue,
    bool? isDarkMode,
    AppThemeStyle? themeStyle,
    String? unitSystem,
    String? language,
  }) {
    return UserProfile(
      uid: uid,
      name: name ?? this.name,
      nickname: nickname ?? this.nickname,
      email: email,
      phone: phone,
      bio: bio ?? this.bio,
      photoUrl: photoUrl ?? this.photoUrl,
      seedColorValue: seedColorValue ?? this.seedColorValue,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      themeStyle: themeStyle ?? this.themeStyle,
      unitSystem: unitSystem ?? this.unitSystem,
      language: language ?? this.language,
    );
  }
}