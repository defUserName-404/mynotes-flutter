import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';
import 'package:mynotes/views/custom_widgets/dialogs.dart';

import '../services/auth/bloc/auth_state.dart';
import 'custom_widgets/button.dart';
import 'custom_widgets/icon.dart';
import 'custom_widgets/textfield.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool _isPasswordVisible;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _isPasswordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) async {
        if (state is AppAuthStateLoggedOut) {
          if (state.exception is UserNotFoundAuthException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'User Not Found',
                content:
                    'Email you entered does not belong any existing user. Please try registering instead.');
          } else if (state.exception is WrongPasswordAuthException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'Wrong Password Entered',
                content:
                    'Password you entered is incorrect. Please try again.');
          } else if (state.exception is GenericAuthException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'Authentication Error',
                content:
                    'An error occurred while trying to login. Please try again.');
          }
        }
      },
      child: Scaffold(appBar: _appBar(), body: _body()),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 10,
      title: Text(
        'Login',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return Container(
        margin: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            const SizedBox(height: 4.0),
            AppTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter your email here',
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_rounded)),
            const SizedBox(height: 4.0),
            AppTextField(
              controller: _passwordController,
              hintText: 'Enter your password here',
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              suffixIcon: IconButton(
                  icon: AppIcon(
                      icon: _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
                    });
                  }),
              obscureText: !_isPasswordVisible,
              enableSuggestions: false,
              autoCorrect: false,
            ),
            const SizedBox(height: 16.0),
            AppButton(
                text: 'Login',
                icon: const Icon(Icons.directions),
                onPressed: () async {
                  final email = _emailController.text;
                  final password = _passwordController.text;
                  context
                      .read<AppAuthBloc>()
                      .add(AppAuthEventLogin(email: email, password: password));
                }),
            AppButton(
                text: 'Don\'t have an account? Register here!',
                icon: const Icon(Icons.account_circle),
                onPressed: () => context
                    .read<AppAuthBloc>()
                    .add(const AppAuthEventShouldRegister())
            ),
          ],
        ));
  }
}
