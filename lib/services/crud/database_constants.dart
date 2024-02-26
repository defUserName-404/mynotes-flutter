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

const dropNoteTable = '''
      DROP TABLE IF EXISTS "note";
''';
