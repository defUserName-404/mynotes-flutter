import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/note.dart';
import 'crud_exceptions.dart';

class NotesService {
  static final NotesService _shared = NotesService._sharedInstance();

  factory NotesService() => _shared;

  NotesService._sharedInstance();

  Database? _db;
  List<DatabaseNote> _notes = [];

  final _notesStreamController =
      StreamController<List<DatabaseNote>>.broadcast();

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try {
      final user = await getUser(email: email);
      return user;
    } on UserCannotBeFoundException {
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (error) {
      rethrow;
    }
  }

  Stream<List<DatabaseNote>> get allNotes => _notesStreamController.stream;

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
      {required DatabaseUser owner, required Note note}) async {
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
    log(newNote.toString());
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

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  Future<DatabaseNote> updateNote({required Note note, required int id}) async {
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
    final allNotes = await getAllNotes();
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
      // const dropNoteTable = '''
      // DROP TABLE IF EXISTS "note";
      // ''';
      // await db.execute(dropNoteTable);
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

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => 'Person, ID = $id, email = $email';

  @override
  bool operator ==(covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String title;
  final String content;
  final bool isFavorite;
  final int color;
  final bool isSyncWithCloud;

  DatabaseNote(
      {required this.id,
      required this.userId,
      required this.title,
      required this.content,
      required this.isFavorite,
      required this.color,
      required this.isSyncWithCloud});

  DatabaseNote.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        title = map[titleColumn] as String,
        content = map[contentColumn] as String,
        isFavorite = map[isFavoriteColumn] as int == 1 ? true : false,
        color = map[colorColumn] as int,
        isSyncWithCloud = map[isSyncWithCloudColumn] as int == 1 ? true : false;

  @override
  String toString() =>
      'Note, id = $id, userId = $userId title = $title, content = $content, isFavorite = $isFavorite, color = $color, isSyncWithCloud = $isSyncWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

const dbName = 'notes.db';
const noteTable = 'note';
const userTable = 'user';
const idColumn = 'id';
const emailColumn = 'email';
const userIdColumn = 'user_id';
const titleColumn = 'title';
const contentColumn = 'content';
const isFavoriteColumn = 'is_favorite';
const colorColumn = 'color';
const isSyncWithCloudColumn = 'is_sync_with_cloud';

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user"(
        "id" INTEGER NOT NULL,
        "email" TEXT NOT NULL UNIQUE,
        PRIMARY KEY ("id" AUTOINCREMENT)
      );''';

const createNoteTable = '''CREATE TABLE IF NOT EXISTS "note"(
        "id" INTEGER NOT NULL,
        "user_id" INTEGER NOT NULL,
        "title" TEXT,
        "content" TEXT,
        "color" INTEGER,
        "is_favorite" INTEGER DEFAULT 0,
        "is_sync_with_cloud" INTEGER NOT NULL DEFAULT 0,
        PRIMARY KEY("id" AUTOINCREMENT),
        FOREIGN KEY("user_id") REFERENCES "user"("id")
      );''';
