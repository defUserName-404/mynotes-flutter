import 'constants.dart';

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
