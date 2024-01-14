import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<StatefulWidget> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late bool _isPasswordVisible;

  Future<void> _handleRegistration() async {
    final email = _email.text;
    final password = _password.text;
    try {
      final userCredentials = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      devtools.log(userCredentials.toString());
      SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil("/notes", (route) => false);
      });
    } on FirebaseAuthException catch (error) {
      if (error.code == "wrong-password") {
        devtools.log("Wrong password");
      } else if (error.code == "email-already-in-use") {
        devtools.log("Email already in use, try logging in instead");
      }
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
            "Register",
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
                        color: Theme.of(context).iconTheme.color,
                      ),
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
                text: "Register",
                icon: const Icon(Icons.directions),
                onPressed: () async {
                  _handleRegistration();
                },
                type: GFButtonType.outline2x,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                size: GFSize.LARGE,
              ),
              GFButton(
                text: "Already registered? Login here!",
                icon: const Icon(Icons.account_circle),
                onPressed: () {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/login", (route) => false);
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
