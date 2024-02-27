import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();

  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final notes = FirebaseFirestore.instance.collection('notes');

  void createNewNote({required String ownerUserId, required CloudNote note}) async {
    notes.add({
      ownerUserIdFieldName: ownerUserId,
      titleFieldName: '',
      contentFieldName: '',
    });
  }

  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes
          .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
          .get()
          .then((value) => value.docs.map((doc) => CloudNote(
              documentId: doc.id,
              ownerUserId: doc.data()[ownerUserIdFieldName] as String,
              title: doc.data()[titleFieldName] as String,
              content: doc.data()[contentFieldName] as String,
              color: doc.data()[colorFieldName] as int,
              isFavorite: doc.data()[isFavoriteFieldName] as bool)));
    } catch (error) {
      throw CouldNotGetAllNotesException();
    }
  }

  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) => event.docs
          .map((doc) => CloudNote.fromSnapshot(doc))
          .where((note) => note.ownerUserId == ownerUserId));

  Future<void> updateNote(
      {required documentId, required CloudNote note}) async {
    try {
      await notes.doc(documentId).update({
        titleFieldName: note.title,
        contentFieldName: note.content,
        colorFieldName: note.color,
        isFavoriteFieldName: note.isFavorite
      });
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
