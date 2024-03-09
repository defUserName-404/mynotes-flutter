import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/views/custom_widgets/textfield.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';
import '../../services/auth/bloc/auth_state.dart';
import '../custom_widgets/button.dart';
import '../custom_widgets/dialogs.dart';

class ForgetPasswordView extends StatefulWidget {
  const ForgetPasswordView({super.key});

  @override
  State<ForgetPasswordView> createState() => _ForgetPasswordViewState();
}

class _ForgetPasswordViewState extends State<ForgetPasswordView> {
  late final TextEditingController _emailController;

  @override
  void initState() {
    _emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AppAuthBloc, AppAuthState>(
      listener: (context, state) {
        if (state is AppAuthStateForgettingPassword) {
          if (state.hasSentEmail) {
            _emailController.clear();
            AppDialog.showErrorDialog(
                context: context,
                title: 'Password Reset Email Sent',
                content:
                    'A link to reset your password has been sent to your email. Please use that link to reset your password');
          }
          if (state.exception != null) {
            AppDialog.showErrorDialog(
                context: context,
                title: 'User Not Found',
                content:
                    'Email you entered does not belong any existing user. Please try registering instead.');
          }
        }
      },
      child: Scaffold(appBar: _appBar(), body: _body()),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 10,
      leading: BackButton(
          onPressed: () =>
              context.read<AppAuthBloc>().add(const AppAuthEventLogout())),
      title: Text(
        'Forget Password',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        children: [
          AppTextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Enter your email address',
            labelText: 'Email',
            prefixIcon: const Icon(Icons.email_rounded),
          ),
          const SizedBox(height: 16.0),
          AppButton(
              text: 'Send forget password link to your email',
              icon: const Icon(Icons.notification_add),
              onPressed: () async => context.read<AppAuthBloc>().add(
                  AppAuthEventForgetPassword(email: _emailController.text)))
        ],
      ),
    );
  }
}
