import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/body_metrics_model.dart';

class BodyMetricsService {
  static final List<BodyMetrics> _localMetrics = [
    BodyMetrics(
      id: '1',
      date: DateTime.now().subtract(const Duration(days: 30)),
      weight: 82.5,
      height: 178,
      targetWeight: 78.0,
      bodyFatPercentage: 21.0,
      muscleMassKg: 38.5,
      chestCm: 102,
      waistCm: 88,
      leftArmCm: 37,
      rightArmCm: 37.5,
    ),
    BodyMetrics(
      id: '2',
      date: DateTime.now(),
      weight: 80.2,
      height: 178,
      targetWeight: 78.0,
      bodyFatPercentage: 19.2,
      muscleMassKg: 39.1,
      chestCm: 103,
      waistCm: 85,
      leftArmCm: 38,
      rightArmCm: 38.2,
    ),
  ];

  Future<void> saveMetrics(BodyMetrics metrics) async {
    if (!kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('body_metrics')
            .doc(metrics.id.isEmpty ? null : metrics.id)
            .set(metrics.toJson());
        return;
      }
    }
    _localMetrics.add(metrics);
  }

  Future<List<BodyMetrics>> getMetricsHistory() async {
    if (!kIsWeb) {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('body_metrics')
            .orderBy('date', descending: true)
            .get();

        return snapshot.docs
            .map((doc) => BodyMetrics.fromJson(doc.data(), doc.id))
            .toList();
      }
    }
    return _localMetrics;
  }
}