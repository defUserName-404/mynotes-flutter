import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/loader/gf_loader.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../util/constants/routes.dart';

class HomePageRouting extends StatelessWidget {
  const HomePageRouting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: AppAuthService.firebase().initialize(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final loggedInUser = AppAuthService.firebase().currentUser;
                if (loggedInUser == null) {
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  });
                } else {
                  if (loggedInUser.isEmailVerified) {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil(homeRoute, (route) => false);
                    });
                  } else {
                    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          verifyEmailRoute, (route) => false);
                    });
                  }
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
