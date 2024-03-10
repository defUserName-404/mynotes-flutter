import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class AppAuthEvent {
  const AppAuthEvent();
}

final class AppAuthEventInitialize extends AppAuthEvent {
  const AppAuthEventInitialize();
}

final class AppAuthEventLogin extends AppAuthEvent {
  final String email;
  final String password;

  const AppAuthEventLogin({required this.email, required this.password});
}

final class AppAuthEventLogout extends AppAuthEvent {
  const AppAuthEventLogout();
}

final class AppAuthEventShouldRegister extends AppAuthEvent {
  const AppAuthEventShouldRegister();
}

final class AppAuthEventRegister extends AppAuthEvent {
  final String email;
  final String password;

  const AppAuthEventRegister({required this.email, required this.password});
}

final class AppAuthEventSendEmailVerification extends AppAuthEvent {
  const AppAuthEventSendEmailVerification();
}

final class AppAuthEventForgetPassword extends AppAuthEvent {
  final String? email;

  const AppAuthEventForgetPassword({this.email});
}
