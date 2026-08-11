class WorkoutLog {
  final String id;
  final String routineName;
  final DateTime completedAt;
  final int durationMinutes;
  final List<String> targetedMuscles; // ex: ['chest', 'triceps']

  WorkoutLog({
    required this.id,
    required this.routineName,
    required this.completedAt,
    required this.durationMinutes,
    required this.targetedMuscles,
  });

  factory WorkoutLog.fromJson(Map<String, dynamic> json, String id) {
    return WorkoutLog(
      id: id,
      routineName: json['routineName'] ?? 'Treino Avulso',
      completedAt: DateTime.tryParse(json['completedAt'] ?? '') ?? DateTime.now(),
      durationMinutes: json['durationMinutes'] ?? 0,
      targetedMuscles: List<String>.from(json['targetedMuscles'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'routineName': routineName,
      'completedAt': completedAt.toIso8601String(),
      'durationMinutes': durationMinutes,
      'targetedMuscles': targetedMuscles,
    };
  }
}