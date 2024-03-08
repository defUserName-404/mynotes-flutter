import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_validation.dart';
import 'package:mynotes/services/auth/bloc/auth_event.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../custom_widgets/button.dart';
import '../custom_widgets/dialogs.dart';
import '../custom_widgets/icon.dart';
import '../custom_widgets/textfield.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late bool _isPasswordVisible;

  @override
  void initState() {
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _isPasswordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) async {
        if (state is AppAuthStateRegistering) {
          if (state.exception is WeakPasswordAuthException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'Weak Password',
                content:
                    'The password entered is weak. Stronger password recommended.');
          } else if (state.exception is EmailAlreadyExistsException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'Email Already Exists',
                content:
                    'The email you entered already has an account associated with it. Please try logging in instead.');
          } else if (state.exception is InvalidEmailAuthException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'Invalid Email',
                content:
                    'Email is invalid. Please try again with a valid one.');
          } else if (state.exception is GenericAuthException) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'Authentication Error',
                content:
                    'An error occurred while trying to register. Please try again.');
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
        'Register',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 4.0),
            AppTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Enter your email here',
              labelText: 'Email',
              validator: (email) =>
                  AppAuthenticationValidator.validateEmail(email!),
              prefixIcon: const Icon(Icons.email_rounded),
            ),
            const SizedBox(height: 4.0),
            AppTextField(
              controller: _passwordController,
              hintText: 'Enter your password here',
              labelText: 'Password',
              prefixIcon: const Icon(Icons.lock),
              validator: (password) =>
                  AppAuthenticationValidator.validatePassword(password!),
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
            const SizedBox(height: 4.0),
            AppTextField(
              controller: _confirmPasswordController,
              hintText: 'Enter your password again',
              labelText: 'Confirm Password',
              validator: (retypedPassword) =>
                  AppAuthenticationValidator.validateConfirmPassword(
                      _passwordController.text, retypedPassword!),
              prefixIcon: const Icon(Icons.lock),
              obscureText: true,
              enableSuggestions: false,
              autoCorrect: false,
            ),
            const SizedBox(height: 16.0),
            AppButton(
                text: 'Register',
                icon: const Icon(Icons.directions),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final email = _emailController.text;
                    final password = _passwordController.text;
                    context.read<AppAuthBloc>().add(
                          AppAuthEventRegister(
                            email: email,
                            password: password,
                          ),
                        );
                  }
                }),
            AppButton(
                text: 'Already registered? Login here!',
                icon: const Icon(Icons.account_circle),
                onPressed: () => context
                    .read<AppAuthBloc>()
                    .add(const AppAuthEventLogout())),
          ],
        ),
      ),
    );
  }
}
