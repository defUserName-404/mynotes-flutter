import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:mynotes/custom_widgets/reused_widgets.dart';
import 'package:mynotes/models/note.dart';

import '../util/constants/routes.dart';
import 'icon.dart';

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

    showToast('Like pressed');
  }

  void _onEditPressed() {
    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      Navigator.of(context).pushNamed(noteCreateOrUpdateRoute);
    });
  }

  void _onDeletePressed() {
    showToast('Delete pressed');
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: const AppIcon(icon: Icons.edit_note_rounded),
                    onPressed: _onEditPressed,
                  ),
                  IconButton(
                    icon: _isFavoriteSelected
                        ? const AppIcon(icon: Icons.favorite_rounded)
                        : const AppIcon(icon: Icons.favorite_outline_rounded),
                    onPressed: _onLikePressed,
                  ),
                  IconButton(
                      onPressed: _onDeletePressed,
                      icon: const AppIcon(icon: Icons.delete))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
