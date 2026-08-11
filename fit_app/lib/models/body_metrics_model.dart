class BodyMetrics {
  final String id;
  final DateTime date;
  
  // Dados Gerais
  final double weight; // kg
  final double height; // cm
  final double targetWeight; // kg
  
  // Bioimpedância
  final double bodyFatPercentage; // %
  final double muscleMassKg; // kg
  final double boneMassKg; // kg
  final double waterPercentage; // %

  // Medidas Corporais (Perímetros em cm)
  final double chestCm;
  final double waistCm;
  final double hipsCm;
  final double leftArmCm;
  final double rightArmCm;
  final double leftThighCm;
  final double rightThighCm;

  // Dobras Cutâneas (mm)
  final double tricepsSkinfoldMm;
  final double subscapularSkinfoldMm;
  final double suprailiacSkinfoldMm;
  final double abdominalSkinfoldMm;

  // Foto de Progresso
  final String photoUrl;

  BodyMetrics({
    required this.id,
    required this.date,
    required this.weight,
    required this.height,
    required this.targetWeight,
    this.bodyFatPercentage = 0.0,
    this.muscleMassKg = 0.0,
    this.boneMassKg = 0.0,
    this.waterPercentage = 0.0,
    this.chestCm = 0.0,
    this.waistCm = 0.0,
    this.hipsCm = 0.0,
    this.leftArmCm = 0.0,
    this.rightArmCm = 0.0,
    this.leftThighCm = 0.0,
    this.rightThighCm = 0.0,
    this.tricepsSkinfoldMm = 0.0,
    this.subscapularSkinfoldMm = 0.0,
    this.suprailiacSkinfoldMm = 0.0,
    this.abdominalSkinfoldMm = 0.0,
    this.photoUrl = '',
  });

  // Cálculo de IMC (Índice de Massa Corporal)
  double get bmi {
    if (height <= 0) return 0.0;
    final heightMeters = height / 100.0;
    return weight / (heightMeters * heightMeters);
  }

  String get bmiCategory {
    final val = bmi;
    if (val < 18.5) return 'Abaixo do peso';
    if (val < 25.0) return 'Peso Normal';
    if (val < 30.0) return 'Sobrepeso';
    return 'Obesidade';
  }

  factory BodyMetrics.fromJson(Map<String, dynamic> json, String id) {
    return BodyMetrics(
      id: id,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      weight: (json['weight'] ?? 0.0).toDouble(),
      height: (json['height'] ?? 0.0).toDouble(),
      targetWeight: (json['targetWeight'] ?? 0.0).toDouble(),
      bodyFatPercentage: (json['bodyFatPercentage'] ?? 0.0).toDouble(),
      muscleMassKg: (json['muscleMassKg'] ?? 0.0).toDouble(),
      boneMassKg: (json['boneMassKg'] ?? 0.0).toDouble(),
      waterPercentage: (json['waterPercentage'] ?? 0.0).toDouble(),
      chestCm: (json['chestCm'] ?? 0.0).toDouble(),
      waistCm: (json['waistCm'] ?? 0.0).toDouble(),
      hipsCm: (json['hipsCm'] ?? 0.0).toDouble(),
      leftArmCm: (json['leftArmCm'] ?? 0.0).toDouble(),
      rightArmCm: (json['rightArmCm'] ?? 0.0).toDouble(),
      leftThighCm: (json['leftThighCm'] ?? 0.0).toDouble(),
      rightThighCm: (json['rightThighCm'] ?? 0.0).toDouble(),
      tricepsSkinfoldMm: (json['tricepsSkinfoldMm'] ?? 0.0).toDouble(),
      subscapularSkinfoldMm: (json['subscapularSkinfoldMm'] ?? 0.0).toDouble(),
      suprailiacSkinfoldMm: (json['suprailiacSkinfoldMm'] ?? 0.0).toDouble(),
      abdominalSkinfoldMm: (json['abdominalSkinfoldMm'] ?? 0.0).toDouble(),
      photoUrl: json['photoUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weight': weight,
      'height': height,
      'targetWeight': targetWeight,
      'bodyFatPercentage': bodyFatPercentage,
      'muscleMassKg': muscleMassKg,
      'boneMassKg': boneMassKg,
      'waterPercentage': waterPercentage,
      'chestCm': chestCm,
      'waistCm': waistCm,
      'hipsCm': hipsCm,
      'leftArmCm': leftArmCm,
      'rightArmCm': rightArmCm,
      'leftThighCm': leftThighCm,
      'rightThighCm': rightThighCm,
      'tricepsSkinfoldMm': tricepsSkinfoldMm,
      'subscapularSkinfoldMm': subscapularSkinfoldMm,
      'suprailiacSkinfoldMm': suprailiacSkinfoldMm,
      'abdominalSkinfoldMm': abdominalSkinfoldMm,
      'photoUrl': photoUrl,
    };
  }
}