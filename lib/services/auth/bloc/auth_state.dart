import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';

@immutable
abstract class AppAuthState {
  const AppAuthState();
}

class AppAuthStateLoading extends AppAuthState {
  const AppAuthStateLoading();
}

class AppAuthStateLoggedIn extends AppAuthState {
  final AppAuthUser user;

  const AppAuthStateLoggedIn({required this.user});
}

class AppAuthStateNeedsEmailVerification extends AppAuthState {
  const AppAuthStateNeedsEmailVerification();
}

class AppAuthStateLoggedOut extends AppAuthState {
  final Exception? exception;

  const AppAuthStateLoggedOut({this.exception});
}

class AppAuthStateLogoutFailure extends AppAuthState {
  final Exception exception;

  const AppAuthStateLogoutFailure({required this.exception});
}
