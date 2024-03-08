import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';

import '../services/auth/bloc/auth_bloc.dart';
import '../services/auth/bloc/auth_event.dart';
import '../util/constants/routes.dart';
import 'custom_widgets/button.dart';

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
      elevation: 10,
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
              onPressed: () =>
                  context.read<AppAuthBloc>().add(const AppAuthEventLogout())),
        ],
      ),
    );
  }
}
