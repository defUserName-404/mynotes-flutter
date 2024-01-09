import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/verify_email_view.dart';

import '../firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: FutureBuilder(
          future: Firebase.initializeApp(
              options: DefaultFirebaseOptions.currentPlatform),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final loggedInUser = FirebaseAuth.instance.currentUser;
                if (loggedInUser == null) {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()),
                    );
                  });
                } else {
                  print(loggedInUser);
                }
                if (loggedInUser!.emailVerified) {
                  print("Email verified");
                } else {
                  print("Email Not verified");
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const VerifyEmailView(),
                    ));
                  });
                }
                return Column(
                  children: [
                    const Text("done"),
                    ElevatedButton(
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                      },
                      child: const Text("Logout"),
                    ),
                  ],
                );
              default:
                return const Loader(
                  radius: 10,
                  color: Colors.red,
                );
            }
          }),
    );
  }
}
