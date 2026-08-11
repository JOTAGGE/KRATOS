import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  User? get currentUser => _auth.currentUser;
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Salva dados reais do usuário no Firestore
  Future<void> saveUserData(User user, {String? name, String? nickname}) async {
    try {
      final userRef = _firestore.collection('users').doc(user.uid);
      final doc = await userRef.get();

      if (!doc.exists) {
        await userRef.set({
          'uid': user.uid,
          'email': user.email ?? '',
          'name': name ?? user.displayName ?? 'Atleta Kratos',
          'nickname': nickname ?? '@${user.uid.substring(0, 6)}',
          'phone': user.phoneNumber ?? '',
          'photoUrl': user.photoURL ?? '',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      } else {
        Map<String, dynamic> updates = {
          'updatedAt': FieldValue.serverTimestamp(),
        };
        if (name != null && name.isNotEmpty) updates['name'] = name;
        if (nickname != null && nickname.isNotEmpty) updates['nickname'] = nickname;
        await userRef.update(updates);
      }
    } catch (e) {
      debugPrint('Erro ao gravar no Firestore: $e');
    }
  }

  // Cadastro Real com Email e Senha
  Future<UserCredential> signUpWithEmail(
    String email,
    String password,
    String name,
    String nickname,
  ) async {
    UserCredential res = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (res.user != null) {
      await res.user!.updateDisplayName(name);
      await saveUserData(res.user!, name: name, nickname: nickname);
    }
    return res;
  }

  // Login Real com Email e Senha
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login Real com Google (forçando seletor de contas)
  Future<UserCredential> signInWithGoogle() async {
    GoogleAuthProvider googleProvider = GoogleAuthProvider();
    googleProvider.addScope('email');
    googleProvider.addScope('profile');
    googleProvider.setCustomParameters({'prompt': 'select_account'});

    UserCredential res;
    if (kIsWeb) {
      res = await _auth.signInWithPopup(googleProvider);
    } else {
      res = await _auth.signInWithProvider(googleProvider);
    }

    if (res.user != null) {
      await saveUserData(res.user!);
    }
    return res;
  }

  // SMS Real por Telefone
  Future<void> verifyPhone({
    required String phoneNumber,
    required Function(PhoneAuthCredential) onVerificationCompleted,
    required Function(FirebaseAuthException) onVerificationFailed,
    required Function(String verificationId, int? resendToken) onCodeSent,
    required Function(String verificationId) onCodeAutoRetrievalTimeout,
  }) async {
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: onVerificationCompleted,
      verificationFailed: onVerificationFailed,
      codeSent: onCodeSent,
      codeAutoRetrievalTimeout: onCodeAutoRetrievalTimeout,
    );
  }

  // Confirmação de SMS Real
  Future<UserCredential> signInWithSMSCode(
    String verificationId,
    String smsCode,
  ) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );
    UserCredential res = await _auth.signInWithCredential(credential);
    if (res.user != null) {
      await saveUserData(res.user!);
    }
    return res;
  }

  // Logout Real
  Future<void> signOut() async {
    await _auth.signOut();
  }
}