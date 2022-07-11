
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class AuthProvider extends ValueNotifier<User?> {
  static final AuthProvider _instance = AuthProvider._internal(FirebaseAuth.instance);
  static AuthProvider get instance => _instance;

  AuthProvider._internal(this._auth): super(null) {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) {
        _setUser(user);
      } else {
        if (kDebugMode) {
          print('AuthProvider: user is null, creating anonymous user');
          _createAnonymousUser();
        }
      }
    });
  }

  final FirebaseAuth _auth;
  User? _user;
  User? get user => _user;

  void _createAnonymousUser() {
    _auth.signInAnonymously().asStream().listen((UserCredential? userCredential) {
      _setUser(userCredential?.user);
    });
  }

  void _setUser(User? user) {
    _user = user;
    if (kDebugMode) {
      print('AuthProvider: user set to $user');
    }

    notifyListeners();
  }

  @override
  User? get value => _user;
}