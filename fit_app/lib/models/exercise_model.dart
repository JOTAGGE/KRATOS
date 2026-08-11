class Exercise {
  final String id;
  final String name;
  final String targetMuscle; // ex: 'Peitoral', 'Dorsal', 'Quadríceps'
  final String muscleCategory; // ex: 'chest', 'back', 'legs', 'arms', 'shoulders', 'abs', 'cardio'
  final List<String> secondaryMuscles;
  final String equipment; // ex: 'Halteres', 'Barra', 'Polia', 'Peso Corporal'
  final String gifUrl;
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
    required this.gifUrl,
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
      gifUrl: json['gifUrl'] ?? '',
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
      'gifUrl': gifUrl,
      'preparation': preparation,
      'execution': execution,
      'safetyTips': safetyTips,
    };
  }
}

// Modelo para o Histórico de Cargas e Séries no Exercício
class ExerciseSetLog {
  final DateTime date;
  final double weightKg;
  final int reps;
  final int durationSeconds;

  ExerciseSetLog({
    required this.date,
    required this.weightKg,
    required this.reps,
    this.durationSeconds = 45,
  });
}