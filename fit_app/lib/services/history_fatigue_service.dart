import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/workout_log_model.dart';

class HistoryFatigueService {
  static final List<WorkoutLog> _localLogs = [
    // Treino de exemplo recente para visualização inicial
    WorkoutLog(
      id: '1',
      routineName: 'Treino A - Peito e Tríceps',
      completedAt: DateTime.now().subtract(const Duration(hours: 18)),
      durationMinutes: 50,
      targetedMuscles: ['chest', 'triceps', 'shoulders'],
    ),
    WorkoutLog(
      id: '2',
      routineName: 'Treino B - Costas e Bíceps',
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      durationMinutes: 55,
      targetedMuscles: ['back', 'biceps'],
    ),
  ];

  // Salvar registro de treino concluído
  Future<void> logWorkout(WorkoutLog log) async {
    if (!kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('workout_history')
            .doc(log.id.isEmpty ? null : log.id)
            .set(log.toJson());
        return;
      }
    }
    _localLogs.add(log);
  }

  // Buscar todos os registros do histórico
  Future<List<WorkoutLog>> getHistory() async {
    if (!kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('workout_history')
            .orderBy('completedAt', descending: true)
            .get();

        return snapshot.docs
            .map((doc) => WorkoutLog.fromJson(doc.data(), doc.id))
            .toList();
      }
    }
    return _localLogs;
  }

  // Algoritmo de Cálculo de Fadiga Muscular (0.0 = Recuperado, 1.0 = Fadigado)
  // Considera regeneração biológica de ~48h a 72h
  Map<String, double> calculateMuscleFatigue(List<WorkoutLog> logs) {
    final Map<String, double> fatigueMap = {
      'Peitoral': 0.0,
      'Costas': 0.0,
      'Ombros': 0.0,
      'Bíceps': 0.0,
      'Tríceps': 0.0,
      'Quadríceps/Pernas': 0.0,
      'Abdômen': 0.0,
    };

    final now = DateTime.now();

    for (var log in logs) {
      final hoursAgo = now.difference(log.completedAt).inHours;

      // Desconsidera treinos de mais de 72h atrás (recuperação completa)
      if (hoursAgo > 72) continue;

      // Fator de impacto regressivo com base no tempo decorrido
      double impact = (72 - hoursAgo) / 72.0;

      for (var muscle in log.targetedMuscles) {
        final mLower = muscle.toLowerCase();
        if (mLower.contains('chest') || mLower.contains('peito')) {
          fatigueMap['Peitoral'] = (fatigueMap['Peitoral']! + impact).clamp(0.0, 1.0);
        } else if (mLower.contains('back') || mLower.contains('costas')) {
          fatigueMap['Costas'] = (fatigueMap['Costas']! + impact).clamp(0.0, 1.0);
        } else if (mLower.contains('shoulder') || mLower.contains('ombro')) {
          fatigueMap['Ombros'] = (fatigueMap['Ombros']! + impact).clamp(0.0, 1.0);
        } else if (mLower.contains('biceps')) {
          fatigueMap['Bíceps'] = (fatigueMap['Bíceps']! + impact).clamp(0.0, 1.0);
        } else if (mLower.contains('triceps')) {
          fatigueMap['Tríceps'] = (fatigueMap['Tríceps']! + impact).clamp(0.0, 1.0);
        } else if (mLower.contains('leg') || mLower.contains('quad') || mLower.contains('perna')) {
          fatigueMap['Quadríceps/Pernas'] = (fatigueMap['Quadríceps/Pernas']! + impact).clamp(0.0, 1.0);
        }
      }
    }

    return fatigueMap;
  }
}