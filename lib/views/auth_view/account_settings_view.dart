import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/views/custom_widgets/dialogs.dart';

import '../../services/auth/bloc/auth_bloc.dart';
import '../../services/auth/bloc/auth_event.dart';
import '../../util/constants/routes.dart';
import '../custom_widgets/icon.dart';

class AccountSettingsView extends StatefulWidget {
  const AccountSettingsView({super.key});

  @override
  State<AccountSettingsView> createState() => _AccountSettingsViewState();
}

enum AccountsMenuAction { changePassword, logout, deleteAccount }

class _AccountSettingsViewState extends State<AccountSettingsView> {
  final _options = [
    {
      'icon': Icons.lock,
      'text': 'Change Password',
      'action': AccountsMenuAction.changePassword
    },
    {
      'icon': Icons.logout,
      'text': 'Logout',
      'action': AccountsMenuAction.logout
    },
    {
      'icon': Icons.account_circle,
      'text': 'Delete Account',
      'action': AccountsMenuAction.deleteAccount
    },
  ];

  void _handleAction({required AccountsMenuAction action}) async {
    switch (action) {
      case AccountsMenuAction.changePassword:
        SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
          Navigator.of(context).pushNamed(changePasswordRoute);
        });
        break;
      case AccountsMenuAction.logout:
        final shouldLogout = await AppDialog.showConfirmationDialog(
            buildContext: context,
            title: 'Log Out',
            content: 'Are you sure you want to log out?',
            confirmIcon: Icons.outbond_rounded,
            cancelIcon: Icons.cancel);
        if (shouldLogout && mounted) {
          context.read<AppAuthBloc>().add(const AppAuthEventLogout());
        }
        break;
      case AccountsMenuAction.deleteAccount:
        AppDialog.showErrorDialog(context: context, title: 'Delete Account');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      elevation: 10,
      leading: const BackButton(),
      title: Text(
        'Accounts Settings',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _body() {
    return ListView.builder(
        itemCount: _options.length,
        itemBuilder: (context, index) {
          final option = _options[index];
          return ListTile(
            leading: AppIcon(icon: option['icon'] as IconData),
            title: Text(option['text'] as String),
            onTap: () async =>
                _handleAction(action: option['action'] as AccountsMenuAction),
          );
        });
  }
}
