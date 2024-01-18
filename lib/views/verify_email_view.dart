import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../util/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Verify Email",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
          alignment: Alignment.center,
          child: Column(
            children: [
              const Text("Please verify your email address"),
              GFButton(
                text: "Send Email Verification",
                icon: const Icon(Icons.notification_add),
                onPressed: () async {
                  await AppAuthService.firebase().sendEmailVerification();
                },
                type: GFButtonType.outline2x,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                size: GFSize.LARGE,
              ),
              GFButton(
                text: "Restart",
                icon: const Icon(Icons.restart_alt),
                onPressed: () async {
                  await AppAuthService.firebase().logout();
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
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
