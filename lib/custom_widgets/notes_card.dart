import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mynotes/models/note.dart';

class NotesCard extends StatefulWidget {
  final Note note;

  const NotesCard({super.key, required this.note});

  @override
  State<NotesCard> createState() => _NotesCardState();
}

class _NotesCardState extends State<NotesCard> {
  late bool _isFavoriteSelected;

  @override
  void initState() {
    _isFavoriteSelected = widget.note.isFavorite;
    super.initState();
  }

  void _onLikePressed() {
    setState(() {
      _isFavoriteSelected = !_isFavoriteSelected;
    });

    Fluttertoast.showToast(
        msg: 'Like pressed', backgroundColor: widget.note.color);
  }

  void _onEditPressed() {
    Fluttertoast.showToast(
        msg: 'Edit pressed', backgroundColor: widget.note.color);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: widget.note.color,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.note.title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  if (widget.note.content != null) Text(widget.note.content!),
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
