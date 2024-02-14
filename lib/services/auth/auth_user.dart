import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppAuthUser {
  final bool isEmailVerified;
  final String email;

  const AppAuthUser({required this.isEmailVerified, required this.email});

  factory AppAuthUser.fromFirebase(User user) =>
      AppAuthUser(isEmailVerified: user.emailVerified, email: user.email!);
}
