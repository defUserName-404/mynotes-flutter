import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';
import 'package:mynotes/services/crud/note.dart';

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

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then(
              (value) => value.docs.map((doc) => CloudNote.fromSnapshot(doc)));
    } catch (error) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

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
