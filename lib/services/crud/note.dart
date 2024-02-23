import 'dart:ui';

class NoteDto {
  final String title;
  String? content;
  final Color color;
  final bool isFavorite;

  NoteDto(
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

  factory NoteDto.fromJson(Map<String, dynamic> json) => NoteDto(
        title: json['title'],
        content: json['content'] ?? '',
        color: Color(json['color']),
        isFavorite: json['isFavorite'],
      );
}
