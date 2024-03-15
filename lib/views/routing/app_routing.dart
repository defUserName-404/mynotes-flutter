import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/views/auth_view/account_settings_view.dart';
import 'package:mynotes/views/auth_view/forget_password_view.dart';
import 'package:mynotes/views/auth_view/register_view.dart';
import 'package:mynotes/views/auth_view/verify_email_view.dart';
import 'package:mynotes/views/home_view.dart';

import '../../services/auth/bloc/auth_event.dart';
import '../auth_view/login_view.dart';

class AppRouting extends StatelessWidget {
  const AppRouting({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AppAuthBloc>().add(const AppAuthEventInitialize());
    return BlocBuilder<AppAuthBloc, AppAuthState>(builder: (event, state) {
      switch (state) {
        case AppAuthStateLoggedIn():
          return const HomeView();
        case AppAuthStateNeedsEmailVerification():
          return const VerifyEmailView();
        case AppAuthStateLoggedOut():
          return const LoginView();
        case AppAuthStateRegistering():
          return const RegisterView();
        case AppAuthStateForgettingPassword():
          return const ForgetPasswordView();
        case AppAuthStateAccountSettings():
          return const AccountSettingsView();
        default:
          return const Scaffold(
            body: GFLoader(
              type: GFLoaderType.square,
            ),
          );
      }
    });
  }
}
