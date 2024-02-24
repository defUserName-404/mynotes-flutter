import 'dart:async';

import 'package:mynotes/extensions/filter.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'note.dart';
import 'constants.dart';
import 'crud_exceptions.dart';
import 'database_note.dart';
import 'database_user.dart';

class NotesService {
  static final NotesService _shared = NotesService._sharedInstance();

  factory NotesService() => _shared;

  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }

  Database? _db;
  List<DatabaseNote> _notes = [];
  DatabaseUser? _user;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Future<DatabaseUser> getOrCreateUser(
      {required String email, bool setAsCurrentUser = true}) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on UserCannotBeFoundException {
      final createdUser = await createUser(email: email);
      if (setAsCurrentUser) {
        _user = createdUser;
      }
      return createdUser;
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter((note) {
        final currentUser = _user;
        if (currentUser != null) {
          return note.userId == currentUser.id;
        } else {
          throw UserShouldBeSetReadingAllNotes();
        }
      });

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    }
    return db;
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (results.isNotEmpty) {
      throw UserAlreadyExistsException();
    }
    final userId =
        await db.insert(userTable, {emailColumn: email.toLowerCase()});
    return DatabaseUser(id: userId, email: email);
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(userTable,
        limit: 1, where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (results.isEmpty) {
      throw UserCannotBeFoundException();
    }
    return DatabaseUser.fromRow(results.first);
  }

  Future<void> deleteUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(userTable,
        where: 'email = ?', whereArgs: [email.toLowerCase()]);
    if (deletedCount != 1) {
      throw UserDeleteNotSuccessfulException();
    }
  }

  Future<DatabaseNote> createNote(
      {required DatabaseUser owner, required NoteDto note}) async {
    final db = _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw UserCannotBeFoundException();
    }
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      titleColumn: note.title,
      contentColumn: note.content,
      colorColumn: note.color.value,
      isFavoriteColumn: note.isFavorite ? 1 : 0,
      isSyncWithCloudColumn: 0
    });
    final newNote = DatabaseNote(
        id: noteId,
        userId: owner.id,
        title: note.title,
        content: note.content!,
        isFavorite: note.isFavorite,
        color: note.color.value,
        isSyncWithCloud: false);
    _notes.add(newNote);
    _notesStreamController.add(_notes);
    return newNote;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes =
        await db.query(noteTable, limit: 1, where: 'id = ?', whereArgs: [id]);
    if (notes.isEmpty) {
      throw NoteCannotBeFoundException();
    }
    final note = DatabaseNote.fromRow(notes.first);
    _notes.removeWhere((note) => note.id == id);
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<Iterable<DatabaseNote>> _getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote(
      {required NoteDto note, required int id}) async {
    final db = _getDatabaseOrThrow();
    final existingNote = await getNote(id: id);
    final updateCount = await db.update(
        noteTable,
        {
          titleColumn: note.title,
          contentColumn: note.content,
          colorColumn: note.color.value,
          isFavoriteColumn: note.isFavorite,
          isSyncWithCloudColumn: 0,
        },
        where: 'id = ?',
        whereArgs: [existingNote.id]);
    if (updateCount == 0) {
      throw NoteCannotBeUpdatedException();
    }
    final updatedNote = await getNote(id: id);
    _notes.removeWhere((note) => note.id == updatedNote.id);
    _notes.add(updatedNote);
    _notesStreamController.add(_notes);
    return updatedNote;
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount =
        await db.delete(noteTable, where: 'id = ?', whereArgs: [id]);
    if (deletedCount == 0) {
      throw NoteDeleteNotSuccessfulException();
    }
    _notes.removeWhere((note) => note.id == id);
    _notesStreamController.add(_notes);
  }

  Future<void> _cacheNotes() async {
    final allNotes = await _getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      await db.execute(createUserTable);
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) {
      throw DatabaseNotOpenException();
    }
    db.close();
    _db = null;
  }
}
