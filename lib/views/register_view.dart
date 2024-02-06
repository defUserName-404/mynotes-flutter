import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../custom_widgets/button.dart';
import '../custom_widgets/reused_widgets.dart';
import '../custom_widgets/textfield.dart';
import '../util/constants/routes.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late bool _isPasswordVisible;

  Future<void> _handleRegistration() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final backgroundColor = Theme.of(context).buttonTheme.colorScheme!.primary;
    final textColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    try {
      final userCredentials = await AppAuthService.firebase()
          .register(email: email, password: password);
      devtools.log(userCredentials.toString());
      showToast('Successfully registered', backgroundColor, textColor);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(homeRoute, (route) => false);
      });
    } on EmailAlreadyExistsException {
      showToast(
          'Already registered with the provided email. Try logging in instead.',
          backgroundColor,
          textColor);
    } on WeakPasswordAuthException {
      showToast('Weak password provided. Try a stronger one.', backgroundColor,
          textColor);
    } on InvalidEmailAuthException {
      showToast('Invalid email!', backgroundColor, textColor);
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
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        'Register',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return Container(
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
              text: 'Register',
              icon: const Icon(Icons.directions),
              onPressed: () async {
                _handleRegistration();
              }),
          AppButton(
              text: 'Already registered? Login here!',
              icon: const Icon(Icons.account_circle),
              onPressed: () {
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                });
              }),
        ],
      ),
    );
  }
}
