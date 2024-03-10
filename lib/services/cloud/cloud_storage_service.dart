import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes/services/crud/notes/note.dart';

class CloudStorageService {
  static final CloudStorageService _shared =
      CloudStorageService._sharedInstance();

  CloudStorageService._sharedInstance();

  factory CloudStorageService() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  Future<CloudNote> createNewNote(
      {required String ownerUserId, required NoteDto note}) async {
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: note.title,
      contentFieldName: note.content,
      colorFieldName: note.color.value,
      isFavoriteFieldName: note.isFavorite
    });
    final fetchedNote = await document.get();
    final fetchedNoteData = fetchedNote.data();
    return CloudNote(
        documentId: fetchedNote.id,
        ownerUserId: fetchedNoteData?[ownerUserIdFieldName],
        title: fetchedNoteData?[titleFieldName],
        content: fetchedNoteData?[contentFieldName],
        color: fetchedNoteData?[colorFieldName],
        isFavorite: fetchedNoteData?[isFavoriteFieldName]);
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) => event.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    return allNotes;
  }

  Future<CloudNote> updateNote(
      {required String documentId, required NoteDto note}) async {
    try {
      await notes.doc(documentId).update({
        titleFieldName: note.title,
        contentFieldName: note.content,
        colorFieldName: note.color.value,
        isFavoriteFieldName: note.isFavorite
      });
      final updatedNote = await notes.doc(documentId).get();
      final updatedNoteData = updatedNote.data();
      return CloudNote(
          documentId: updatedNote.id,
          ownerUserId: updatedNoteData?[ownerUserIdFieldName],
          title: updatedNoteData?[titleFieldName],
          content: updatedNoteData?[contentFieldName],
          color: updatedNoteData?[colorFieldName],
          isFavorite: updatedNoteData?[isFavoriteFieldName]);
    } catch (error) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (error) {
      throw CouldNotDeleteNoteException();
    }
  }
}
