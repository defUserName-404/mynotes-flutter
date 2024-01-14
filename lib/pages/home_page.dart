import 'dart:developer' as devtools show log;

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/loader/gf_loader.dart';

import '../firebase_options.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
                  devtools.log("Hello");
                  if (loggedInUser.emailVerified) {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil("/notes", (route) => false);
                    });
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/verify-email", (route) => false);
                    });
                  }
                  // print(loggedInUser);
                }
                return const Column();
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
