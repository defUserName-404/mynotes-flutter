import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/services/auth/auth_exceptions.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../util/constants/routes.dart';
import 'custom_widgets/button.dart';
import 'custom_widgets/dialogs.dart';
import 'custom_widgets/icon.dart';
import 'custom_widgets/textfield.dart';

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
    try {
      final userCredentials = await AppAuthService.firebase()
          .register(email: email, password: password);
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(homeRoute, (route) => false);
      });
    } on EmailAlreadyExistsException {
      AppDialog.showErrorDialog(
          context: context,
          title: 'User Not Found',
          content:
              'Email you entered does not belong any existing user. Try Registering.');
    } on WeakPasswordAuthException {
      AppDialog.showErrorDialog(
          context: context,
          title: 'User Not Found',
          content:
              'Email you entered does not belong any existing user. Try Registering.');
    } on InvalidEmailAuthException {
      AppDialog.showErrorDialog(
          context: context,
          title: 'User Not Found',
          content:
              'Email you entered does not belong any existing user. Try Registering.');
    } on GenericAuthException {
      AppDialog.showErrorDialog(
          context: context,
          title: 'User Not Found',
          content:
              'Email you entered does not belong any existing user. Try Registering.');
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
      child: Column(
        children: [
          const SizedBox(height: 4.0),
          AppTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter your email here',
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_rounded),
          ),
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
