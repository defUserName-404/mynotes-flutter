import "package:flutter/material.dart";
import "package:flutter/scheduler.dart";
import "package:mynotes/custom_widgets/notes_card.dart";
import "package:mynotes/services/auth/auth_service.dart";
import "package:mynotes/util/constants/routes.dart";

import "../custom_widgets/button.dart";
import "../custom_widgets/reused_widgets.dart";

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    final backgroundColor = Theme.of(context).buttonTheme.colorScheme!.primary;
    final textColor = Theme.of(context).buttonTheme.colorScheme!.onPrimary;
    final List<NotesCard> notes = [
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
      const NotesCard(
        title: "Hello",
        color: Colors.brown,
      ),
    ];

    return Scaffold(
        appBar: AppBar(
          title: Text(
            "My Notes",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          centerTitle: true,
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () async {
                final signOut = await showLogOutDialog(context);
                if (signOut) {
                  await AppAuthService.firebase().logout();
                  showToast(
                      "Successfully logged out", backgroundColor, textColor);
                  SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                    Navigator.of(context)
                        .pushNamedAndRemoveUntil(loginRoute, (route) => false);
                  });
                } else {
                  showToast("Log out cancelled", backgroundColor, textColor);
                }
              },
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  showToast("Hello", backgroundColor, textColor);
                  notes.add(const NotesCard(
                    title: "Hello",
                    color: Colors.red,
                    isFavorite: true,
                  ));
                },
                label: const Text("New"),
                icon: const Icon(Icons.add_box),
                tooltip: "Add a new note",
              ),
              const SizedBox(
                height: 10.0,
              ),
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  children: notes,
                ),
              ),
            ],
          ),
        ));
  }

  Future<bool> showLogOutDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Sign out"),
            content: const Text("Are you sure you want to sign out?"),
            actions: [
              AppButton(
                  text: "Yes, sign out",
                  icon: const Icon(Icons.outbond),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  }),
              AppButton(
                  text: "Cancel",
                  icon: const Icon(Icons.outbond),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  }),
            ],
          );
        }).then((value) => value ?? false);
  }
}
