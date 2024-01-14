import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:getwidget/size/gf_size.dart';
import 'package:getwidget/types/gf_button_type.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "My Notes",
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final signOut = await showLogOutDialog(context);
              if (signOut) {
                await FirebaseAuth.instance.signOut();
                SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil("/login", (route) => false);
                });
              }
            },
          ),
        ],
      ),
    );
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign out"),
            content: const Text("Are you sure you want to sign out?"),
            actions: [
              GFButton(
                text: "Yes, log out",
                icon: const Icon(Icons.outbond),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                type: GFButtonType.outline2x,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                size: GFSize.LARGE,
              ),
              GFButton(
                text: "Cancel",
                icon: const Icon(Icons.outbond),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                type: GFButtonType.outline2x,
                color: Theme.of(context).buttonTheme.colorScheme!.primary,
                size: GFSize.LARGE,
              ),
            ],
          );
        }).then((value) => value ?? false);
  }
}