import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';

import '../custom_widgets/notes_card.dart';
import '../services/auth/auth_service.dart';
import '../util/constants/routes.dart';

class AllNotesView extends StatelessWidget {
  AllNotesView({super.key});

  final NotesService _notesService = NotesService();

  String get userEmail => AppAuthService.firebase().currentUser!.email;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _notesService.getOrCreateUser(email: userEmail),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              return StreamBuilder(
                  stream: _notesService.allNotes,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                      case ConnectionState.active:
                        final allNotes =
                            snapshot.data as Iterable<DatabaseNote>;
                        return NotesCard(
                          notes: allNotes,
                          onTap: (note) {
                            Navigator.of(context).pushNamed(
                                noteEditorExistingNoteRoute,
                                arguments: {'updatedNote': note});
                          },
                        );
                      default:
                        return const CircularProgressIndicator(
                          color: Colors.red,
                        );
                    }
                  });
            default:
              return const CircularProgressIndicator(
                color: Colors.green,
              );
          }
        });
  }
}
