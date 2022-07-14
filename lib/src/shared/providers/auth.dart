import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../services/logger.dart';

class UpgradeUserException implements Exception {
  final String? message;
  final String code;

  const UpgradeUserException({required this.code, required this.message});

  UpgradeUserException.fromFirebase(FirebaseAuthException exception)
      : this(
          code: exception.code,
          message: exception.message,
        );
}

class LoginException implements Exception {
  final String message;
  final String code;

  const LoginException({required this.code, required this.message});

  LoginException.fromFirebase(FirebaseAuthException exception)
      : this(
          code: exception.code,
          message: exception.message!,
        );
}

class AuthProvider extends ValueNotifier<User?> {
  static final AuthProvider _instance =
      AuthProvider._internal(FirebaseAuth.instance);

  static AuthProvider get instance => _instance;

  final LoggerService _logger = LoggerService(AuthProvider);

  AuthProvider._internal(this._auth) : super(null) {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _setUser(user);
      } else {
        _createAnonymousUser();
        _logger.log('User is null, creating anonymous user');
      }
    });
  }

  final FirebaseAuth _auth;
  User? _user;

  User? get user => _user;

  void _createAnonymousUser() {
    _auth.signInAnonymously().then((UserCredential? userCredential) {
      _setUser(userCredential?.user);
    }).catchError((err) {
      _logger.log('Error creating anonymous user: $err');
    });
  }

  void _setUser(User? user) {
    _user = user;
    if (kDebugMode) {
      _logger.log('User set to $user');
    }

    notifyListeners();
  }

  @override
  User? get value => _user;

  Future<User> _upgradeUser(AuthCredential credential) async {
    try {
      final result = await _user!.linkWithCredential(credential);
      if (result.user != null) {
        _setUser(result.user);
      }
      return result.user!;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'provider-already-linked':
          _logger.log('Provider already linked');
          break;
        case 'invalid-credential':
          _logger.log('The provider\'s credential is not valid');
          break;
        case 'credential-already-in-use':
          _logger.log(
              'The account corresponding to the credential already exists.');
          break;
        case 'weak-password':
          _logger.log('The password is too weak.');
          break;
        default:
          _logger.log('Unknown error: ${e.code}');
          break;
      }
      throw UpgradeUserException.fromFirebase(e);
    }
  }

  AuthCredential _emailAuthCredential(String email, String password) {
    return EmailAuthProvider.credential(email: email, password: password);
  }

  Future<User> upgradeWithEmailPassword(String email, String password) async {
    final credential = _emailAuthCredential(email, password);
    return await _upgradeUser(credential);
  }

  Future<User?> signInWithEmailPassword(String email, String password) async {
    try {
      return await _auth
          .signInWithEmailAndPassword(email: email, password: password)
          .then((UserCredential creds) {
        _setUser(creds.user);
        return creds.user;
      });
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'user-not-found':
          _logger.log('User not found');
          break;
        case 'wrong-password':
          _logger.log('Wrong password');
          break;
        default:
          _logger.log('Unknown error: ${e.code}');
          break;
      }
      throw LoginException.fromFirebase(e);
    }
  }
}
