import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:leashapp/src/shared/providers/auth.dart';

class UserBuilder extends StatelessWidget {
  const UserBuilder({Key? key, required this.builder}) : super(key: key);

  final Widget Function(BuildContext context, User? user) builder;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<User?>(
        valueListenable: AuthProvider.instance,
        builder: (context, value, _) {
          return builder(context, value);
        });
  }
}
