import 'package:flutter/foundation.dart';
import 'package:health/health.dart';

class HealthSyncService {
  final Health _health = Health();

  // Tipos de dados de saúde solicitados
  final List<HealthDataType> _types = [
    HealthDataType.STEPS,
    HealthDataType.ACTIVE_ENERGY_BURNED,
    HealthDataType.WORKOUT,
  ];

  bool _isAuthorized = false;
  bool get isAuthorized => _isAuthorized;

  // Solicitar permissões ao usuário
  Future<bool> requestPermissions() async {
    if (kIsWeb) {
      // Na Web simula concessão para desenvolvimento
      _isAuthorized = true;
      return true;
    }

    try {
      final List<HealthDataAccess> permissions = _types.map((_) => HealthDataAccess.READ_WRITE).toList();
      _isAuthorized = await _health.requestAuthorization(_types, permissions: permissions);
      return _isAuthorized;
    } catch (e) {
      debugPrint('Erro ao solicitar permissões de saúde: $e');
      return false;
    }
  }

  // Buscar contagem de passos de hoje
  Future<int> getTodaySteps() async {
    if (kIsWeb) return 7420; // Valor demonstrativo em desenvolvimento Web

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      int? steps = await _health.getTotalStepsInInterval(midnight, now);
      return steps ?? 0;
    } catch (e) {
      debugPrint('Erro ao buscar passos: $e');
      return 0;
    }
  }

  // Buscar calorias queimadas hoje
  Future<double> getTodayCalories() async {
    if (kIsWeb) return 485.0; // Valor demonstrativo na Web

    final now = DateTime.now();
    final midnight = DateTime(now.year, now.month, now.day);

    try {
      List<HealthDataPoint> healthData = await _health.getHealthDataFromTypes(
        startTime: midnight,
        endTime: now,
        types: [HealthDataType.ACTIVE_ENERGY_BURNED],
      );

      double totalCalories = 0.0;
      for (var p in healthData) {
        if (p.value is NumericHealthValue) {
          totalCalories += (p.value as NumericHealthValue).numericValue.toDouble();
        }
      }
      return totalCalories;
    } catch (e) {
      debugPrint('Erro ao buscar calorias: $e');
      return 0.0;
    }
  }

  // Gravar treino concluído no Health Connect / Google Fit
  Future<bool> writeWorkoutToHealthConnect({
    required String workoutName,
    required DateTime startTime,
    required DateTime endTime,
    required int caloriesBurned,
  }) async {
    if (kIsWeb) return true;

    try {
      return await _health.writeWorkoutData(
        activityType: HealthWorkoutActivityType.STRENGTH_TRAINING,
        title: workoutName,
        start: startTime,
        end: endTime,
        totalEnergyBurned: caloriesBurned,
        totalEnergyBurnedUnit: HealthDataUnit.KILOCALORIE,
      );
    } catch (e) {
      debugPrint('Erro ao registrar treino na saúde: $e');
      return false;
    }
  }
}