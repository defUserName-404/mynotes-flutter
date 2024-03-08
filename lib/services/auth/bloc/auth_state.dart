import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:equatable/equatable.dart' show EquatableMixin;

@immutable
abstract class AppAuthState {
  const AppAuthState();
}

class AppAuthStateUninitialized extends AppAuthState {
  const AppAuthStateUninitialized();
}

class AppAuthStateLoggedIn extends AppAuthState {
  final AppAuthUser user;

  const AppAuthStateLoggedIn({required this.user});
}

class AppAuthStateNeedsEmailVerification extends AppAuthState {
  const AppAuthStateNeedsEmailVerification();
}

class AppAuthStateLoggedOut extends AppAuthState with EquatableMixin {
  final Exception? exception;
  final bool isLoading;

  const AppAuthStateLoggedOut({this.exception, required this.isLoading});

  @override
  List<Object?> get props => [exception, isLoading];
}

class AppAuthStateRegistering extends AppAuthState {
  final Exception? exception;

  const AppAuthStateRegistering({this.exception});
}
