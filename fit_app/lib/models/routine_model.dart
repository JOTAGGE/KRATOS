class RoutineExercise {
  final String exerciseId;
  final String exerciseName;
  final int sets;
  final int reps;
  final int restSeconds;

  RoutineExercise({
    required this.exerciseId,
    required this.exerciseName,
    this.sets = 3,
    this.reps = 12,
    this.restSeconds = 60,
  });

  factory RoutineExercise.fromJson(Map<String, dynamic> json) {
    return RoutineExercise(
      exerciseId: json['exerciseId'] ?? '',
      exerciseName: json['exerciseName'] ?? 'Exercício',
      sets: json['sets'] ?? 3,
      reps: json['reps'] ?? 12,
      restSeconds: json['restSeconds'] ?? 60,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exerciseId': exerciseId,
      'exerciseName': exerciseName,
      'sets': sets,
      'reps': reps,
      'restSeconds': restSeconds,
    };
  }
}

class WorkoutRoutine {
  final String id;
  final String name;
  final List<int> weekDays; // 1 = Seg, 7 = Dom
  final List<RoutineExercise> exercises;

  WorkoutRoutine({
    required this.id,
    required this.name,
    required this.weekDays,
    required this.exercises,
  });

  factory WorkoutRoutine.fromJson(Map<String, dynamic> json, String id) {
    return WorkoutRoutine(
      id: id,
      name: json['name'] ?? 'Treino',
      weekDays: List<int>.from(json['weekDays'] ?? []),
      exercises: (json['exercises'] as List<dynamic>?)
              ?.map((e) => RoutineExercise.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'weekDays': weekDays,
      'exercises': exercises.map((e) => e.toJson()).toList(),
    };
  }
}