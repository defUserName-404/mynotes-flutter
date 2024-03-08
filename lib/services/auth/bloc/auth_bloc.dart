import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_provider.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';

class AppAuthBloc extends Bloc<AppAuthEvent, AppAuthState> {
  AppAuthBloc({required AppAuthProvider appAuthProvider})
      : super(const AppAuthStateUninitialized()) {
    // ? initialization
    on<AppAuthEventInitialize>((event, emit) async {
      await appAuthProvider.initialize();
      final user = appAuthProvider.currentUser;
      if (user == null) {
        emit(const AppAuthStateLoggedOut(isLoading: false));
      } else if (!user.isEmailVerified) {
        emit(const AppAuthStateNeedsEmailVerification());
      } else {
        emit(AppAuthStateLoggedIn(user: user));
      }
    });
    // ? login
    on<AppAuthEventLogin>((event, emit) async {
      emit(
        const AppAuthStateLoggedOut(
          exception: null,
          isLoading: true,
        ),
      );
      final email = event.email;
      final password = event.password;
      try {
        final user =
            await appAuthProvider.login(email: email, password: password);
        emit(AppAuthStateLoggedIn(user: user));
        if (!user.isEmailVerified) {
          emit(
            const AppAuthStateLoggedOut(isLoading: false),
          );
          emit(const AppAuthStateNeedsEmailVerification());
        } else {
          emit(
            const AppAuthStateLoggedOut(isLoading: false),
          );
          emit(AppAuthStateLoggedIn(user: user));
        }
      } on Exception catch (e) {
        emit(AppAuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    // ? logout
    on<AppAuthEventLogout>((event, emit) async {
      try {
        await appAuthProvider.logout();
        emit(
          const AppAuthStateLoggedOut(isLoading: false),
        );
      } on Exception catch (e) {
        emit(AppAuthStateLoggedOut(exception: e, isLoading: false));
      }
    });
    // ? send email verification
    on<AppAuthEventSendEmailVerification>((event, emit) async {
      await appAuthProvider.sendEmailVerification();
      emit(state);
    });
    // ? register
    on<AppAuthEventRegister>((event, emit) async {
      final email = event.email;
      final password = event.password;
      try {
        await appAuthProvider.register(
          email: email,
          password: password,
        );
        await appAuthProvider.sendEmailVerification();
        emit(const AppAuthStateNeedsEmailVerification());
      } on Exception catch (e) {
        emit(AppAuthStateRegistering(exception: e));
      }
    });
    on<AppAuthEventShouldRegister>((event, emit) async {
      emit(const AppAuthStateRegistering());
    });
  }
}
