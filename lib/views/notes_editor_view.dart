import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/custom_widgets/textfield.dart';
import 'package:mynotes/models/note.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/util/constants/colors.dart';

import '../custom_widgets/button.dart';
import '../custom_widgets/icon.dart';
import '../custom_widgets/reused_widgets.dart';
import '../util/constants/note_editing_mode.dart';

class NoteEditorView extends StatefulWidget {
  final NoteEditingMode noteEditingMode;

  const NoteEditorView({super.key, required this.noteEditingMode});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  DatabaseNote? _passedNote;
  late final NotesService _notesService;
  TextEditingController? _titleController;
  TextEditingController? _contentController;
  late bool _isFavorite;
  late Color _backgroundColor;
  late final NoteEditingMode _noteEditingMode;

  @override
  void initState() {
    _notesService = NotesService();
    _notesService.open();
    _noteEditingMode = widget.noteEditingMode;
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _isFavorite = false;
    _backgroundColor = colorSwatchForNote[0];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_noteEditingMode == NoteEditingMode.exitingNote) {
      final arguments = (ModalRoute.of(context)?.settings.arguments ??
          <String, DatabaseNote>{}) as Map<String, DatabaseNote>;
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
    _titleController!.dispose();
    _contentController!.dispose();
    _notesService.close();
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
      leading: const BackButton(),
      actions: [
        if (_noteEditingMode == NoteEditingMode.exitingNote) ...[
          IconButton(
              icon: const AppIcon(icon: Icons.delete),
              onPressed: () async {
                final delete = await _showDeleteConfirmationDialog(context);
                if (delete) {
                  _deleteNote(_passedNote!.id);
                  if (context.mounted) Navigator.maybePop(context);
                }
              }),
        ],
        IconButton(
          icon: _isFavorite
              ? const AppIcon(icon: Icons.favorite_rounded)
              : const AppIcon(icon: Icons.favorite_outline_rounded),
          onPressed: () {
            setState(() {
              _isFavorite = !_isFavorite;
            });
          },
        ),
        IconButton(
            onPressed: () async {
              final note = Note(
                  title: _titleController!.text,
                  content: _contentController!.text,
                  color: _backgroundColor,
                  isFavorite: _isFavorite);
              final pushedNoteInDatabase =
                  _noteEditingMode == NoteEditingMode.newNote
                      ? await _createNewNote(note)
                      : await _updateExistingNote(note, _passedNote!.id);
              log(pushedNoteInDatabase.toString());
              if (context.mounted) Navigator.maybePop(context);
            },
            icon: const AppIcon(icon: Icons.check))
      ],
    );
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: AppTextField(
                  controller: _titleController!,
                  hintText: 'Title',
                  borderColor: Theme.of(context).brightness == Brightness.dark
                      ? CustomColors.dark
                      : CustomColors.light,
                  labelText: ''),
            ),
            Expanded(
              child: AppTextField(
                  controller: _contentController!,
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

  Future<DatabaseNote> _createNewNote(Note newNote) async {
    final email = AppAuthService.firebase().currentUser!.email;
    final owner = await _notesService.getUser(email: email);
    return await _notesService.createNote(owner: owner, note: newNote);
  }

  Future<DatabaseNote> _updateExistingNote(Note updatedNote, int noteId) async {
    return await _notesService.updateNote(note: updatedNote, id: noteId);
  }

  Future<void> _deleteNote(int noteId) async {
    _notesService.deleteNote(id: noteId);
  }

  Future<bool> _showDeleteConfirmationDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Delete Note'),
            content: const Text('Do you really want to delete this note?'),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  AppButton(
                      text: 'Yes, delete this note',
                      icon: const Icon(Icons.outbond),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      }),
                  AppButton(
                      text: 'Cancel',
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                        showToast('Delete cancelled');
                      }),
                ],
              )
            ],
          );
        }).then((value) => value ?? false);
  }
}
