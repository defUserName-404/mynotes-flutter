import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  AppAuthBloc({required AppAuthProvider appAuthProvider})
      : super(const AppAuthStateLoading()) {
    // ? initialization
    on<AppAuthEventInitialize>((event, emit) async {
      await appAuthProvider.initialize();
      final user = appAuthProvider.currentUser;
      if (user == null) {
        emit(const AppAuthStateLoggedOut());
      } else if (!user.isEmailVerified) {
        emit(const AppAuthStateNeedsEmailVerification());
      } else {
        emit(AppAuthStateLoggedIn(user: user));
      }
    });
    // ? login
    on<AppAuthEventLogin>((event, emit) async {
      emit(const AppAuthStateLoading());
      final email = event.email;
      final password = event.password;
      try {
        final user =
            await appAuthProvider.login(email: email, password: password);
        emit(AppAuthStateLoggedIn(user: user));
      } on Exception catch (e) {
        emit(AppAuthStateLoggedOut(exception: e));
      }
    });
    // ? logout
    on<AppAuthEventLogout>((event, emit) async {
      try {
        emit(const AppAuthStateLoading());
        await appAuthProvider.logout();
        emit(const AppAuthStateLoggedOut());
      } on Exception catch (e) {
        emit(AppAuthStateLogoutFailure(exception: e));
      }
    });
  }
}
