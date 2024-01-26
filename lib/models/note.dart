import 'dart:ui';

class Note {
  final String title;
  String? content;
  final Color color;
  final bool isFavorite;

  Note(
      {required this.title,
      this.content,
      required this.color,
      required this.isFavorite});
}
