import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_service.dart';

import '../../services/auth/auth_service.dart';
import '../../util/constants/routes.dart';
import '../custom_widgets/notes_card.dart';

class AllNotesView extends StatelessWidget {
  AllNotesView({super.key});

  final CloudStorageService _notesService = CloudStorageService();

  String get userId => AppAuthService.firebase().currentUser!.id;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _notesService.allNotes(ownerUserId: userId),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
          case ConnectionState.active:
            if (snapshot.hasData) {
              final allNotes = snapshot.data as Iterable<CloudNote>;
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
              return const GFLoader(
                type: GFLoaderType.square,
              );
            }
          default:
            return const GFLoader(
              type: GFLoaderType.square,
            );
        }
      },
    );
  }
}
