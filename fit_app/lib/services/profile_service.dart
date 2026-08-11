import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/user_profile_model.dart';

class ProfileService extends ChangeNotifier {
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  UserProfile _profile = UserProfile(
    uid: '',
    name: 'Atleta Kratos',
    nickname: '@atleta',
    email: '',
    phone: '',
    bio: 'Foco no processo!',
    photoUrl: '',
    seedColorValue: Colors.deepPurple.value,
    isDarkMode: true,
    themeStyle: AppThemeStyle.standard,
  );

  UserProfile get profile => _profile;

  // Carrega os dados reais do Firestore vinculados ao UID ativo
  Future<void> loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        final newProfile = UserProfile.fromJson(doc.data()!, user.uid);
        if (_profile.name != newProfile.name || _profile.photoUrl != newProfile.photoUrl) {
          _profile = newProfile;
          notifyListeners();
        }
      } else {
        _profile = UserProfile(
          uid: user.uid,
          name: user.displayName ?? 'Atleta Kratos',
          nickname: '@${user.uid.substring(0, 6)}',
          email: user.email ?? '',
          phone: user.phoneNumber ?? '',
          bio: 'Foco no processo!',
          photoUrl: user.photoURL ?? '',
          seedColorValue: Colors.deepPurple.value,
          isDarkMode: true,
          themeStyle: AppThemeStyle.standard,
        );

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          _profile.toJson(),
          SetOptions(merge: true),
        );
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Aviso Firestore: $e');
    }
  }

  void clearProfile() {
    _profile = UserProfile(
      uid: '',
      name: 'Atleta Kratos',
      nickname: '@atleta',
      email: '',
      phone: '',
      bio: 'Foco no processo!',
      photoUrl: '',
      seedColorValue: Colors.deepPurple.value,
      isDarkMode: true,
      themeStyle: AppThemeStyle.standard,
    );
    notifyListeners();
  }

  // Atualiza no estado reativo e salva direto no Cloud Firestore
  Future<void> updateProfile(UserProfile updated) async {
    _profile = updated;
    notifyListeners();

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set(
          updated.toJson(),
          SetOptions(merge: true),
        );
      } catch (e) {
        debugPrint('Erro ao salvar atualização de perfil no Firestore: $e');
      }
    }
  }

  ThemeData getThemeData(bool isDark) {
    Color seed = Color(_profile.seedColorValue);

    switch (_profile.themeStyle) {
      case AppThemeStyle.cyberpunk:
        seed = Colors.cyanAccent;
        break;
      case AppThemeStyle.synthwave:
        seed = Colors.pinkAccent;
        break;
      case AppThemeStyle.rockMetal:
        seed = Colors.redAccent;
        break;
      case AppThemeStyle.standard:
      default:
        break;
    }

    return ThemeData(
      useMaterial3: true,
      colorSchemeSeed: seed,
      brightness: isDark ? Brightness.dark : Brightness.light,
    );
  }
}