import 'package:share_plus/share_plus.dart';

import '../../auth/auth_service.dart';
import '../../cloud/cloud_note.dart';
import '../../cloud/cloud_storage_service.dart';
import 'note.dart';
import 'note_editing_mode.dart';

part 'note_action_service.dart';

mixin NoteAction {
  void saveNote(
      {required NoteDto note,
      required NoteEditingMode noteEditingMode, required
      CloudNote? existingNote});

  void deleteNote({required String noteId});

  void shareNote({required NoteDto note});

  bool toggleFavoriteNote({required bool isFavorite});
}
