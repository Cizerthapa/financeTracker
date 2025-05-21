import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signUpWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      log('Attempting sign-up for email: $email');
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('Sign-up successful for UID: ${credential.user?.uid}');
      return credential.user;
    } catch (e) {
      log('Sign-up error: ${e.toString()}', level: 1000);
      rethrow;
    }
  }

  Future<User?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      log('FirebaseAuth: Signing in with $email');
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      log('FirebaseAuth: Login success for $email');
      return credential.user;
    } on FirebaseAuthException catch (e) {
      log('FirebaseAuthException: ${e.code} | ${e.message}');
      rethrow;
    } catch (e) {
      log('Login Error: ${e.toString()}');
      rethrow;
    }
  }
}
