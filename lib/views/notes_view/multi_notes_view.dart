import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/crud/notes/note.dart';
import 'package:mynotes/services/crud/notes/note_editing_mode.dart';
import 'package:mynotes/util/constants/colors.dart';
import 'package:mynotes/views/custom_widgets/menu_options.dart';

import '../../services/crud/notes/note_action.dart';
import '../../util/constants/routes.dart';
import '../custom_widgets/dialogs.dart';
import '../custom_widgets/icon.dart';
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
  late final NoteActionService _noteActionService;

  @override
  void initState() {
    _noteActionService = NoteActionService();
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
    return Scaffold(appBar: _appBar(), body: _body());
  }

  PreferredSizeWidget? _appBar() {
    if (_isSelecting) {
      return AppBar(
          elevation: 2,
          title: _title != null ? Text(_title!) : null,
          leading: _isSelecting
              ? const CloseButton(color: CustomColors.primary)
              : Container(),
          actions: menuOptions
              .where((menuOption) =>
                  menuOption['action'] as MenuItem != MenuItem.save)
              .map((menuOption) => IconButton(
                  onPressed: () {
                    switch (menuOption['action'] as MenuItem) {
                      case MenuItem.toggleFavorite:
                        _onToggleFavoriteButtonPressed();
                        break;
                      case MenuItem.delete:
                        _onDeleteButtonPressed();
                        break;
                      case MenuItem.share:
                        _onShareButtonPressed();
                        break;
                      default:
                        break;
                    }
                    _dragSelectGridViewController.clear();
                  },
                  icon: AppIcon(icon: menuOption['icon'] as IconData),
                  tooltip: menuOption['text'] as String))
              .toList());
    }
    return null;
  }

  void _onToggleFavoriteButtonPressed() {
    for (var index in _dragSelectGridViewController.value.selectedIndexes) {
      final currentNote = widget.allNotes.elementAt(index);
      final isFavorite = _noteActionService.toggleFavoriteNote(
          isFavorite: currentNote.isFavorite);
      final updatedNote = NoteDto(
          title: currentNote.title,
          content: currentNote.content,
          color: Color(currentNote.color),
          isFavorite: isFavorite);
      _noteActionService.saveNote(
          note: updatedNote,
          noteEditingMode: NoteEditingMode.existingNote,
          existingNote: currentNote);
    }
  }

  void _onDeleteButtonPressed() async {
    final shouldDeleteNote = await AppDialog.showConfirmationDialog(
        buildContext: context,
        title: 'Delete Notes',
        content:
            'Do you really want to delete ${_dragSelectGridViewController.value.amount} notes?',
        confirmIcon: Icons.delete_rounded,
        cancelIcon: Icons.cancel);
    if (shouldDeleteNote && mounted) {
      for (var index in _dragSelectGridViewController.value.selectedIndexes) {
        final currentNote = widget.allNotes.elementAt(index);
        final noteId = currentNote.documentId;
        _noteActionService.deleteNote(noteId: noteId);
      }
    }
  }

  void _onShareButtonPressed() {
    final titleText = StringBuffer();
    final contentText = StringBuffer();
    for (var index in _dragSelectGridViewController.value.selectedIndexes) {
      final currentNote = widget.allNotes.elementAt(index);
      titleText.writeAll(currentNote.title.characters);
      titleText.writeAll(currentNote.content.characters);
    }
    final sharingNote = NoteDto(
        title: titleText.toString(),
        content: contentText.toString(),
        color: CustomColors.secondary,
        isFavorite: false);
    _noteActionService.shareNote(note: sharingNote);
  }

  Widget _body() {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: DragSelectGridView(
        gridController: _dragSelectGridViewController,
        itemCount: widget.allNotes.length,
        gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
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
