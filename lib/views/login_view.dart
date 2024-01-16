import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/custom_widgets/reused_widgets.dart';
import 'package:mynotes/util/constants/routes.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<StatefulWidget> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool _isPasswordVisible;

  Future<void> _handleLogin() async {
    final email = _email.text;
    final password = _password.text;
    final backgroundColor = Theme.of(context).buttonTheme.colorScheme!.primary;
    final textColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    try {
      final userCredentials = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      devtools.log(userCredentials.toString());
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil(notesRoute, (route) => false);
        showToast("Successfully logged in", backgroundColor, textColor);
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == "wrong-password") {
        devtools.log("Wrong password");
      } else if (error.code == "invalid-email") {
        devtools.log("Invalid email");
      }
      showToast("Failed to log in", backgroundColor, textColor);
    }
  }

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _isPasswordVisible = false;
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Login",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              TextField(
                  controller: _email,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter your email here",
                    labelText: "Email",
                    floatingLabelAlignment: FloatingLabelAlignment.center,
                    border: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    ),
                    prefixIcon: Icon(
                      Icons.email_rounded,
                      color: Theme.of(context).iconTheme.color,
                    ),
                  )),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                  hintText: "Enter your password here",
                  labelText: "Password",
                  floatingLabelAlignment: FloatingLabelAlignment.center,
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Theme.of(context).iconTheme.color,
                  ),
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
                ),
                obscureText: !_isPasswordVisible,
                enableSuggestions: false,
                autocorrect: false,
              ),
              GFButton(
                text: "Login",
                icon: const Icon(Icons.directions),
                onPressed: () async {
                  _handleLogin();
                },
                type: GFButtonType.outline2x,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                size: GFSize.LARGE,
              ),
              GFButton(
                text: "Don't have an account? Register here!",
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute, (route) => false);
                  });
                },
                type: GFButtonType.outline2x,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                size: GFSize.LARGE,
              ),
            ],
          ),
        ));
  }
}
