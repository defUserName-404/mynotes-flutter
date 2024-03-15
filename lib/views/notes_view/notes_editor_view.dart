import 'package:flutter/material.dart';
import 'package:mynotes/services/crud/notes/note.dart';
import 'package:mynotes/services/crud/notes/note_action.dart';
import 'package:mynotes/util/constants/colors.dart';

import '../../services/cloud/cloud_note.dart';
import '../../services/crud/notes/note_editing_mode.dart';
import '../custom_widgets/dialogs.dart';
import '../custom_widgets/icon.dart';
import '../custom_widgets/menu_options.dart';
import '../custom_widgets/textfield.dart';

class NoteEditorView extends StatefulWidget {
  final NoteEditingMode noteEditingMode;

  const NoteEditorView({super.key, required this.noteEditingMode});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  CloudNote? _passedNote;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isFavorite;
  late Color _backgroundColor;
  late final NoteEditingMode _noteEditingMode;
  late final NoteActionService _noteActionService;

  @override
  void initState() {
    _noteEditingMode = widget.noteEditingMode;
    _noteActionService = NoteActionService();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _isFavorite = false;
    _backgroundColor = colorSwatchForNote[0];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_noteEditingMode == NoteEditingMode.existingNote) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, CloudNote>{}) as Map<String, CloudNote>;
      _passedNote = arguments['updatedNote'];
      setState(() {
        _titleController = TextEditingController(text: _passedNote!.title);
        _contentController = TextEditingController(text: _passedNote!.content);
        _isFavorite = _passedNote!.isFavorite;
        _backgroundColor = Color(_passedNote!.color);
      });
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: _appBar(),
          body: _body(),
          backgroundColor: _backgroundColor,
          bottomNavigationBar: _bottomNavBar()),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
        leading: BackButton(
            color: CustomColors.primary,
            onPressed: () {
              _onSaveOrBackButtonPressed();
            }),
        elevation: 10,
        actions: menuOptions
            .where((menuOption) =>
                (menuOption['action'] as MenuItem) != MenuItem.delete ||
                _noteEditingMode != NoteEditingMode.newNote)
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
                      case MenuItem.save:
                        _onSaveOrBackButtonPressed();
                        break;
                      default:
                        break;
                    }
                  },
                  icon: _setIconsForMenuItems(menuOption),
                  tooltip: menuOption['text'] as String,
                ))
            .toList());
  }

  void _onToggleFavoriteButtonPressed() {
    setState(() => _isFavorite =
        _noteActionService.toggleFavoriteNote(isFavorite: _isFavorite));
  }

  void _onShareButtonPressed() {
    final sharingNote = NoteDto(
        title: _titleController.text,
        content: _contentController.text,
        color: _backgroundColor,
        isFavorite: _isFavorite);
    _noteActionService.shareNote(note: sharingNote);
  }

  void _onDeleteButtonPressed() async {
    final shouldDeleteNote = await AppDialog.showConfirmationDialog(
        buildContext: context,
        title: 'Delete Note',
        content: 'Do you really want to delete this note?',
        confirmIcon: Icons.delete_rounded,
        cancelIcon: Icons.cancel);
    if (shouldDeleteNote && mounted) {
      _noteActionService.deleteNote(noteId: _passedNote!.documentId);
      Navigator.pop(context);
    }
  }

  void _onSaveOrBackButtonPressed() {
    final note = NoteDto(
        title: _titleController.text,
        content: _contentController.text,
        color: _backgroundColor,
        isFavorite: _isFavorite);
    _noteActionService.saveNote(
        note: note,
        noteEditingMode: _noteEditingMode,
        existingNote: _passedNote);
    Navigator.pop(context);
  }

  Widget _setIconsForMenuItems(Map<String, dynamic> menuOption) {
    return AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: (menuOption['action'] as MenuItem) == MenuItem.toggleFavorite
            ? AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                switchInCurve: Curves.easeIn,
                switchOutCurve: Curves.easeOut,
                child: _isFavorite
                    ? const AppIcon(icon: Icons.favorite_rounded)
                    : const AppIcon(icon: Icons.favorite_outline_rounded),
              )
            : AppIcon(icon: menuOption['icon'] as IconData));
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppTextField(
                  controller: _titleController,
                  hintText: 'Title',
                  borderColor: Theme.of(context).brightness == Brightness.dark
                      ? CustomColors.dark
                      : CustomColors.light,
                  labelText: ''),
            ),
            Expanded(
              child: AppTextField(
                  controller: _contentController,
                  hintText: 'Start typing your note here',
                  borderColor: Theme.of(context).brightness == Brightness.dark
                      ? CustomColors.dark
                      : CustomColors.light,
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  labelText: ''),
            ),
          ],
        ));
  }

  Widget _bottomNavBar() {
    return BottomAppBar(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          for (Color color in colorSwatchForNote)
            GestureDetector(
              onTap: () {
                setState(() {
                  _backgroundColor = color;
                });
              },
              child: CircleAvatar(
                backgroundColor: color,
              ),
            ),
        ],
      ),
    );
  }
}
