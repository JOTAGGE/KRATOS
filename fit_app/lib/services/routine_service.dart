import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/routine_model.dart';
import '../models/exercise_model.dart';
import 'exercise_service.dart';

class RoutineService {
  final ExerciseService _exerciseService = ExerciseService();

  static final List<WorkoutRoutine> _localRoutines = [];

  Future<List<WorkoutRoutine>> getRoutines() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !kIsWeb) {
      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('routines')
            .get();

        return snapshot.docs
            .map((doc) => WorkoutRoutine.fromJson(doc.data(), doc.id))
            .toList();
      } catch (e) {
        debugPrint('Erro ao buscar rotinas no Firestore: $e');
      }
    }
    return _localRoutines;
  }

  WorkoutRoutine? getTodayWorkout(List<WorkoutRoutine> routines) {
    final today = DateTime.now().weekday; // 1 = Segunda, 7 = Domingo
    for (var routine in routines) {
      if (routine.weekDays.contains(today)) {
        return routine;
      }
    }
    return null;
  }

  Future<void> saveRoutine(WorkoutRoutine routine) async {
    _localRoutines.add(routine);

    final user = FirebaseAuth.instance.currentUser;
    if (user != null && !kIsWeb) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('routines')
            .doc(routine.id)
            .set(routine.toJson());
      } catch (e) {
        debugPrint('Erro ao salvar treino no Firestore: $e');
      }
    }
  }

  /// Gerador de Treino Express (Módulo 3)
  Future<WorkoutRoutine> generateRandomWorkout({
    required String bodyRegion,
    required int durationMinutes,
    required bool onlyBodyweight,
  }) async {
    // Busca os exercícios correspondentes à região escolhida
    final allExercises = await _exerciseService.getExercises(
      category: bodyRegion == 'all' ? null : bodyRegion,
    );

    var filtered = allExercises;
    if (onlyBodyweight) {
      filtered = allExercises
          .where((e) =>
              e.equipment.toLowerCase().contains('corporal') ||
              e.equipment.toLowerCase().contains('paralela'))
          .toList();
    }

    // Fallback caso a busca com filtro seja muito restrita
    if (filtered.isEmpty) filtered = allExercises;
    if (filtered.isEmpty) filtered = await _exerciseService.getExercises();

    // Estima a quantidade de exercícios com base no tempo livre (1 exercício para cada ~8-10 minutos)
    final int exerciseCount = max(2, (durationMinutes / 8).round());

    final random = Random();
    filtered.shuffle(random);

    final selectedExercises = filtered.take(exerciseCount).toList();

    final List<RoutineExercise> routineItems = selectedExercises.map((e) {
      return RoutineExercise(
        exerciseId: e.id,
        exerciseName: e.name,
        sets: 4,
        reps: 12,
        restSeconds: 60,
      );
    }).toList();

    return WorkoutRoutine(
      id: 'express_${DateTime.now().millisecondsSinceEpoch}',
      name: 'Treino Express (${durationMinutes} min)',
      weekDays: [],
      exercises: routineItems,
    );
  }
}