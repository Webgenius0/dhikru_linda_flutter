// ignore_for_file: constant_identifier_names

import 'dart:developer';
import 'package:dhikru_linda_flutter/constants/app_constants.dart';
import 'package:dhikru_linda_flutter/helpers/di.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

const String GoogleUserId = 'google_user_id';

class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  Stream<User?> get userChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// Sign in with Google, authenticate with Firebase, store tokens & return tokens map
  Future<Map<String, String>?> signInWithGoogle({String? serverClientId}) async {
    try {
      // Clear any previous session
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final GoogleSignIn googleSignInInstance = serverClientId != null
          ? GoogleSignIn(scopes: ['email'], serverClientId: serverClientId)
          : _googleSignIn;

      final googleUser = await googleSignInInstance.signIn();
      if (googleUser == null) {
        log('Google Sign-In was canceled by user');
        return null;
      }

      final googleAuth = await googleUser.authentication;

      log('Google idToken: ${googleAuth.idToken != null ? "Present" : "Null"}');
      log('Google accessToken: ${googleAuth.accessToken != null ? "Present" : "Null"}');

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      final user = userCredential.user;
      if (user == null) return null;

      final firebaseToken = await user.getIdToken();

      // Save user details & tokens to GetStorage appData
      appData.write(GoogleUserId, user.uid);
      if (firebaseToken != null) {
        appData.write('firebaseIdToken', firebaseToken);
      }
      if (googleAuth.accessToken != null) {
        appData.write('googleAccessToken', googleAuth.accessToken);
      }
      if (user.displayName != null) {
        appData.write(kKeyName, user.displayName);
      }
      if (user.email != null) {
        appData.write(kKeyEmail, user.email);
      }

      log('=== Google Sign-In Tokens ===');
      log('✅ User UID: ${user.uid}');
      log('Firebase ID Token: $firebaseToken');
      log('Google Access Token: ${googleAuth.accessToken}');

      return {
        "firebaseIdToken": firebaseToken ?? "",
        "googleAccessToken": googleAuth.accessToken ?? "",
      };
    } catch (e, stackTrace) {
      log('Google login error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Sign out from Firebase and Google Sign-In, clear saved tokens
  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();

      appData.remove(GoogleUserId);
      appData.remove('firebaseIdToken');
      appData.remove('googleAccessToken');
      appData.remove('appleUserId');

      log('User logged out');
    } catch (e) {
      log('Logout error: $e');
      rethrow;
    }
  }
}

// Class alias for compatibility
typedef GoogleAuthService = AuthService;
