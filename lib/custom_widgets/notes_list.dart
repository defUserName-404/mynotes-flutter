import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes_service.dart';

typedef NoteCallback = void Function(DatabaseNote note);

// TODO: this is temporary
class NotesListView extends StatelessWidget {
  final Iterable<DatabaseNote> notes;

  // final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    super.key,
    required this.notes,
    // required this.onDeleteNote,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes.elementAt(index);
        return ListTile(
          onTap: () {
            onTap(note);
          },
          title: Text(
            note.title,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            onPressed: () async {
              // final shouldDelete = await showDeleteDialog(context);
              // if (shouldDelete) {
              //   onDeleteNote(note);
              // }
            },
            icon: const Icon(Icons.delete),
          ),
        );
      },
    );
  }
}
