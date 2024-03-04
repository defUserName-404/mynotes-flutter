import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/types/gf_loader_type.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_state.dart';
import 'package:mynotes/views/home_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import '../../services/auth/bloc/auth_event.dart';

class HomePageRouting extends StatelessWidget {
  const HomePageRouting({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<AppAuthBloc>().add(const AppAuthEventInitialize());
    return BlocBuilder<AppAuthBloc, AppAuthState>(builder: (event, state) {
      if (state is AppAuthStateLoggedIn) {
        return const HomeView();
      } else if (state is AppAuthStateNeedsEmailVerification) {
        return const VerifyEmailView();
      } else if (state is AppAuthStateLoggedOut) {
        return const LoginView();
      } else {
        return const Scaffold(
          body: GFLoader(
            type: GFLoaderType.square,
          ),
        );
      }
    });
  }
}
