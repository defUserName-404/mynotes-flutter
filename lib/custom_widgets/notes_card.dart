import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotesCard extends StatefulWidget {
  final String title;
  final String? content;
  final Color color;
  final bool borderOnForeground;
  final Color shadowColor;
  final bool isFavorite;

  const NotesCard(
      {super.key,
      required this.title,
      this.content,
      this.color = Colors.white,
      this.borderOnForeground = false,
      this.shadowColor = Colors.grey,
      this.isFavorite = false});

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  late bool _isFavoriteSelected;

  @override
  void initState() {
    _isFavoriteSelected = widget.isFavorite;
    super.initState();
  }

  void _onLikePressed() {
    setState(() {
      _isFavoriteSelected = !_isFavoriteSelected;
    });

    Fluttertoast.showToast(msg: 'Like pressed', backgroundColor: widget.color);
  }

  void _onEditPressed() {
    Fluttertoast.showToast(msg: 'Edit pressed', backgroundColor: widget.color);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.color,
      borderOnForeground: widget.borderOnForeground,
      shadowColor: widget.shadowColor,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (widget.content != null) Text(widget.content!),
                  const SizedBox(height: 10.0),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_note_rounded),
                    onPressed: _onEditPressed,
                  ),
                  const Spacer(),
                  IconButton(
                    icon: _isFavoriteSelected
                        ? const Icon(Icons.favorite_rounded)
                        : const Icon(Icons.favorite_outline_rounded),
                    onPressed: _onLikePressed,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
