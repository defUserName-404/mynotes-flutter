import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppAuthEvent {
  const AppAuthEvent();
}

class AppAuthEventInitialize extends AppAuthEvent {
  const AppAuthEventInitialize();
}

class AppAuthEventLogin extends AppAuthEvent {
  final String email;
  final String password;

  const AppAuthEventLogin({required this.email, required this.password});
}

class AppAuthEventLogout extends AppAuthEvent {
  const AppAuthEventLogout();
}

class AppAuthEventRegister extends AppAuthEvent {
  final String email;
  final String password;

  const AppAuthEventRegister({required this.email, required this.password});
}