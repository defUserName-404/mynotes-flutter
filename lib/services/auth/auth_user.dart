import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppAuthUser {
  final String id;
  final bool isEmailVerified;
  final String email;

  const AppAuthUser(
      {required this.id, required this.isEmailVerified, required this.email});

  factory AppAuthUser.fromFirebase(User user) => AppAuthUser(
      id: user.uid, isEmailVerified: user.emailVerified, email: user.email!);
}
