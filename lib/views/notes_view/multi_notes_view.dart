import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';

import '../../util/constants/routes.dart';
import '../custom_widgets/note_card.dart';

class MultiNotesView extends StatefulWidget {
  final Iterable<CloudNote> allNotes;

  const MultiNotesView({super.key, required this.allNotes});

  @override
  State<MultiNotesView> createState() => _MultiNotesViewState();
}

class _MultiNotesViewState extends State<MultiNotesView> {
  final _dragSelectGridViewController = DragSelectGridViewController();
  bool _isSelecting = false;
  String? _title;

  @override
  void initState() {
    _dragSelectGridViewController.addListener(_scheduleRebuild);
    super.initState();
  }

  @override
  void dispose() {
    _dragSelectGridViewController.removeListener(_scheduleRebuild);
    super.dispose();
  }

  void _scheduleRebuild() {
    setState(() {
      _isSelecting = _dragSelectGridViewController.value.isSelecting;
      _title = _isSelecting
          ? '${_dragSelectGridViewController.value.amount} notes selected'
          : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _isSelecting
          ? AppBar(
              elevation: 2,
              title: _title != null ? Text(_title!) : null,
              leading: _isSelecting ? const CloseButton() : Container(),
            )
          : null,
      body: DragSelectGridView(
        gridController: _dragSelectGridViewController,
        itemCount: widget.allNotes.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, mainAxisSpacing: 4.0, crossAxisSpacing: 2.0),
        itemBuilder: (BuildContext context, int index, bool selected) {
          final note = widget.allNotes.elementAt(index);
          return NoteCard(
            note: note,
            onTap: () => Navigator.of(context).pushNamed(
                noteEditorExistingNoteRoute,
                arguments: {'updatedNote': note}),
            isSelected: selected,
          );
        },
        impliesAppBarDismissal: false,
      ),
    );
  }
}
