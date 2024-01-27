import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/custom_widgets/reused_widgets.dart';
import 'package:mynotes/custom_widgets/textfield.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/util/constants/routes.dart';

import '../custom_widgets/button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool _isPasswordVisible;

  Future<void> _handleLogin() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final backgroundColor = Theme.of(context).buttonTheme.colorScheme!.primary;
    final textColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    try {
      final userCredentials = await AppAuthService.firebase()
          .login(email: email, password: password);
      devtools.log(userCredentials.toString());
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(homeRoute, (route) => false);
        showToast('Successfully logged in', backgroundColor, textColor);
      });
    } on UserNotFoundAuthException {
      showToast('User not found', backgroundColor, textColor);
    } on WrongPasswordAuthException {
      showToast('Wrong password entered.', backgroundColor, textColor);
    } on GenericAuthException {
      showToast('Authentication error.', backgroundColor, textColor);
    }
  }

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
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Login',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              AppTextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Enter your email here',
                labelText: 'Email',
                prefixIcon: const Icon(Icons.email_rounded),
              ),
              AppTextField(
                controller: _passwordController,
                hintText: 'Enter your password here',
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                    icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Theme.of(context).iconTheme.color),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    }),
                obscureText: !_isPasswordVisible,
                enableSuggestions: false,
                autoCorrect: false,
              ),
              AppButton(
                  text: 'Login',
                  icon: const Icon(Icons.directions),
                  onPressed: () async {
                    _handleLogin();
                  }),
              AppButton(
                  text: 'Don\'t have an account? Register here!',
                  icon: const Icon(Icons.account_circle),
                  onPressed: () {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          registerRoute, (route) => false);
                    });
                  }),
            ],
          ),
        ));
  }
}
