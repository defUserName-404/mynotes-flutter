import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppAuthUser {
  final bool isEmailVerified;

  const AppAuthUser(this.isEmailVerified);

  factory AppAuthUser.fromFirebase(User user) =>
      AppAuthUser(user.emailVerified);
}
