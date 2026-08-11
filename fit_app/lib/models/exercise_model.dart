class Exercise {
  final String id;
  final String name;
  final String targetMuscle;
  final String muscleCategory; // 'chest', 'back', 'legs', 'shoulders', 'arms', 'abs', 'cardio'
  final List<String> secondaryMuscles;
  final String equipment; // 'barbell', 'dumbbell', 'cable', 'machine', 'bodyweight', 'band'
  final List<String> images; // URLs de imagens sequenciais para animação da execução
  final String preparation;
  final String execution;
  final List<String> safetyTips;

  Exercise({
    required this.id,
    required this.name,
    required this.targetMuscle,
    required this.muscleCategory,
    required this.secondaryMuscles,
    required this.equipment,
    required this.images,
    required this.preparation,
    required this.execution,
    required this.safetyTips,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      targetMuscle: json['targetMuscle'] ?? 'Geral',
      muscleCategory: (json['muscleCategory'] ?? 'all').toString().toLowerCase(),
      secondaryMuscles: List<String>.from(json['secondaryMuscles'] ?? []),
      equipment: json['equipment'] ?? 'Peso Corporal',
      images: List<String>.from(json['images'] ?? []),
      preparation: json['preparation'] ?? 'Posicione-se adequadamente.',
      execution: json['execution'] ?? 'Realize o movimento com amplitude controlada.',
      safetyTips: List<String>.from(json['safetyTips'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'targetMuscle': targetMuscle,
      'muscleCategory': muscleCategory,
      'secondaryMuscles': secondaryMuscles,
      'equipment': equipment,
      'images': images,
      'preparation': preparation,
      'execution': execution,
      'safetyTips': safetyTips,
    };
  }
}

class ExerciseSetLog {
  final String id;
  final DateTime date;
  final double weightKg;
  final int reps;
  final int durationSeconds;

  ExerciseSetLog({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.reps,
    this.durationSeconds = 45,
  });

  factory ExerciseSetLog.fromJson(Map<String, dynamic> json, String id) {
    return ExerciseSetLog(
      id: id,
      date: DateTime.tryParse(json['date'] ?? '') ?? DateTime.now(),
      weightKg: (json['weightKg'] ?? 0.0).toDouble(),
      reps: json['reps'] ?? 0,
      durationSeconds: json['durationSeconds'] ?? 45,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'weightKg': weightKg,
      'reps': reps,
      'durationSeconds': durationSeconds,
    };
  }
}