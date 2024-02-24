import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/services/crud/notes_service.dart';

import '../custom_widgets/notes_card.dart';
import '../services/auth/auth_service.dart';
import '../services/crud/database_note.dart';
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
                    if (snapshot.hasData) {
                      final allNotes = snapshot.data as List<DatabaseNote>;
                      return NotesCard(
                        notes: allNotes,
                        onTap: (note) {
                          Navigator.of(context).pushNamed(
                            noteEditorExistingNoteRoute,
                            arguments: {'updatedNote': note},
                          );
                        },
                      );
                    } else {
                      return GFProgressBar(
                        animation: true,
                        percentage: 1,
                        leading: const Text('Loading'),
                      );
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
            );
          default:
            return const CircularProgressIndicator();
        }
      },
    );
  }
}
