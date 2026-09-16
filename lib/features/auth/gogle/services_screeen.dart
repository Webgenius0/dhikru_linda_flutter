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

  // Web Client ID from google-services.json (client_type: 3)
  static const String defaultServerClientId =
      '388524370985-p5hml61a7bv5ctb5umg1ttc40bo4323u.apps.googleusercontent.com';

  late final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: defaultServerClientId,
  );

  Stream<User?> get userChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  /// Sign in with Google, authenticate with Firebase, store tokens & return tokens map
  Future<Map<String, String>?> signInWithGoogle({String? serverClientId}) async {
    try {
      // Clear any previous session
      try {
        await _googleSignIn.signOut();
      } catch (_) {}

      final effectiveClientId = serverClientId ?? defaultServerClientId;
      final GoogleSignIn googleSignInInstance = GoogleSignIn(
        scopes: ['email'],
        serverClientId: effectiveClientId,
      );

      final googleUser = await googleSignInInstance.signIn();
      if (googleUser == null) {
        log('Google Sign-In was canceled by user');
        return null;
      }

      final googleAuth = await googleUser.authentication;

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
      if (googleAuth.idToken != null) {
        appData.write('googleIdToken', googleAuth.idToken);
      }
      if (googleAuth.accessToken != null) {
        appData.write('googleAccessToken', googleAuth.accessToken);
      }
      if (googleUser.serverAuthCode != null) {
        appData.write('googleServerAuthCode', googleUser.serverAuthCode);
      }
      if (firebaseToken != null) {
        appData.write('firebaseIdToken', firebaseToken);
      }
      if (user.displayName != null) {
        appData.write(kKeyName, user.displayName);
      }
      if (user.email != null) {
        appData.write(kKeyEmail, user.email);
      }

      // -------------------------------------------------------------
      // PRINT ALL TOKENS (Google ID Token, Google Access Token, Firebase ID Token, etc.)
      // -------------------------------------------------------------
      _logTokenHeader('GOOGLE & FIREBASE AUTH TOKENS');
      log('User UID           : ${user.uid}');
      log('Google User ID (sub): ${googleUser.id}');
      log('Email              : ${user.email}');
      log('Display Name       : ${user.displayName}');
      log('Server Auth Code   : ${googleUser.serverAuthCode ?? "[None]"}');

      _printFullToken('1. GOOGLE ID TOKEN (OIDC JWT - Use this if backend verifies with Google)', googleAuth.idToken);
      _printFullToken('2. GOOGLE ACCESS TOKEN (OAuth2 Bearer Token)', googleAuth.accessToken);
      if (googleUser.serverAuthCode != null) {
        _printFullToken('3. GOOGLE SERVER AUTH CODE', googleUser.serverAuthCode);
      }
      _printFullToken('4. FIREBASE ID TOKEN (Firebase Auth JWT)', firebaseToken);
      _logTokenFooter();

      return {
        "googleIdToken": googleAuth.idToken ?? "",
        "googleAccessToken": googleAuth.accessToken ?? "",
        "googleServerAuthCode": googleUser.serverAuthCode ?? "",
        "firebaseIdToken": firebaseToken ?? "",
        "userUid": user.uid,
        "email": user.email ?? "",
        "displayName": user.displayName ?? "",
        "photoUrl": user.photoURL ?? "",
      };
    } catch (e, stackTrace) {
      log('Google login error: $e', stackTrace: stackTrace);
      rethrow;
    }
  }

  /// Helper to print tokens without truncation
  void _printFullToken(String label, String? token) {
    if (token == null || token.isEmpty) {
      log('$label: [NULL / EMPTY]');
      return;
    }
    log('\n================== $label (Length: ${token.length}) ==================');
    // Print chunked so logcat or Flutter console never truncates
    const int chunkSize = 800;
    for (int i = 0; i < token.length; i += chunkSize) {
      final end = (i + chunkSize < token.length) ? i + chunkSize : token.length;
      log(token.substring(i, end));
    }
    log('================== END OF $label ==================\n');
  }

  void _logTokenHeader(String title) {
    log('╔══════════════════════════════════════════════════════════════════════');
    log('║ 🔑 $title');
    log('╠══════════════════════════════════════════════════════════════════════');
  }

  void _logTokenFooter() {
    log('╚══════════════════════════════════════════════════════════════════════');
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
