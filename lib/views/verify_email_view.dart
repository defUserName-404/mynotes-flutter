import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../custom_widgets/button.dart';
import '../util/constants/routes.dart';

class VerifyEmailView extends StatefulWidget {
  const VerifyEmailView({super.key});

  @override
  State<VerifyEmailView> createState() => _VerifyEmailViewState();
}

class _VerifyEmailViewState extends State<VerifyEmailView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      title: Text(
        'Verify Email',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Text('Please verify your email address'),
          AppButton(
              text: 'Send Email Verification',
              icon: const Icon(Icons.notification_add),
              onPressed: () async {
                await AppAuthService.firebase().sendEmailVerification();
              }),
          AppButton(
              text: 'Restart',
              icon: const Icon(Icons.restart_alt),
              onPressed: () async {
                await AppAuthService.firebase().logout();
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
