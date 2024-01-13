import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

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
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil("/login", (route) => false);
                    // Navigator.of(context).pushNamedAndRemoveUntil(
                    //     "/verify-email", (route) => false);
                  });
                } else {
                  if (loggedInUser.emailVerified) {
                    print("Email verified");
                  } else {
                    print("Email Not verified");
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/verify-email", (route) => false);
                    });
                  }
                  print(loggedInUser);
                }
                return Column(
                  children: [
                    const Text("done"),
                    GFButton(
                      text: "Logout",
                      icon: const Icon(Icons.outbond),
                      onPressed: () async {
                        FirebaseAuth.instance.signOut();
                      },
                      type: GFButtonType.outline2x,
                      color: Theme.of(context).buttonTheme.colorScheme!.primary,
                      size: GFSize.LARGE,
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
