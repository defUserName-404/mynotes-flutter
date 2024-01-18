import 'dart:async';

import 'package:mynotes/services/auth/auth_user.dart';

abstract class AppAuthProvider {
  AppAuthUser? get currentUser;

  Future<void> initialize();

  Future<AppAuthUser> login({required String email, required String password});

  Future<AppAuthUser> register(
      {required String email, required String password});

  Future<void> logout();

  Future<void> sendEmailVerification();
}
