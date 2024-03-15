part of 'note_action.dart';

class NoteActionService with NoteAction {
  static final NoteActionService _shared = NoteActionService._sharedInstance();

  NoteActionService._sharedInstance();

  factory NoteActionService() => _shared;

  final CloudStorageService _notesService = CloudStorageService();

  @override
  void saveNote(
      {required NoteDto note,
      required NoteEditingMode noteEditingMode,
      required CloudNote? existingNote}) {
    if (note.title.isNotEmpty || note.content.isNotEmpty) {
      noteEditingMode == NoteEditingMode.newNote
          ? _createNewNote(note)
          : _updateExistingNote(note, existingNote!.documentId);
    }
  }

  @override
  void deleteNote({required String noteId}) {
    _deleteNote(noteId);
  }

  @override
  void shareNote({required NoteDto note}) {
    final text = '${note.title}\n${note.content}';
    Share.share(text);
  }

  @override
  bool toggleFavoriteNote({required bool isFavorite}) {
    return !isFavorite;
  }

  void _createNewNote(NoteDto newNote) {
    final currentUser = AppAuthService.firebase().currentUser!;
    _notesService.createNewNote(ownerUserId: currentUser.id, note: newNote);
  }

  void _updateExistingNote(NoteDto updatedNote, String noteId) {
    _notesService.updateNote(note: updatedNote, documentId: noteId);
  }

  void _deleteNote(String noteId) {
    _notesService.deleteNote(documentId: noteId);
  }
}
