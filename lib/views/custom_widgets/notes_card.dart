import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:mynotes/util/constants/colors.dart';

import '../../services/cloud/cloud_note.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesCard extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onTap;

  const NotesCard({super.key, required this.notes, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: notes.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        final note = notes.elementAt(index);
        return GestureDetector(
          onTap: () => onTap(note),
          child: GFCard(
              padding: const EdgeInsets.all(2.0),
              margin: const EdgeInsets.all(8.0),
              color: Color(note.color),
              elevation: 20,
              title: GFListTile(
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(2.0),
                avatar: const Icon(
                  Icons.note,
                  color: CustomColors.onPrimary,
                ),
                title: Text(
                  note.title,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: CustomColors.onPrimary),
                ),
              ),
              titlePosition: GFPosition.start,
              content: Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(4.0), // Adjust padding as needed
                child: Text(
                  note.content,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: CustomColors.light),
                ),
              ),
              clipBehavior: Clip.antiAlias),
        );
      },
    );
  }
}
