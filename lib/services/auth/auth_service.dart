import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/auth_user.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';

class AppAuthService implements AppAuthProvider {
  final AppAuthProvider appAuthProvider;

  const AppAuthService({required this.appAuthProvider});

  factory AppAuthService.firebase() =>
      AppAuthService(appAuthProvider: FirebaseAppAuthProvider());

  @override
  AppAuthUser? get currentUser => appAuthProvider.currentUser;

  @override
  Future<AppAuthUser> login(
          {required String email, required String password}) =>
      appAuthProvider.login(email: email, password: password);

  @override
  Future<void> logout() => appAuthProvider.logout();

  @override
  Future<AppAuthUser> register(
          {required String email, required String password}) =>
      appAuthProvider.register(email: email, password: password);

  @override
  Future<void> sendEmailVerification() =>
      appAuthProvider.sendEmailVerification();

  @override
  Future<void> initialize() => appAuthProvider.initialize();

  @override
  Future<void> sendPasswordReset({required String toEmail}) =>
      appAuthProvider.sendEmailVerification();
}
