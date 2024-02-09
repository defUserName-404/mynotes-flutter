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

  @override
  String toString() {
    return "title = $title, content = $content, color = $color, isFavorite = $isFavorite";
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
      'color': color.value,
      'isFavorite': isFavorite
    };
  }

  factory Note.fromJson(Map<String, dynamic> json) => Note(
        title: json['title'],
        content: json['content'] ?? '',
        color: Color(json['color']),
        isFavorite: json['isFavorite'],
      );
}
