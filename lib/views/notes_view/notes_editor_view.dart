import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_storage_service.dart';
import 'package:mynotes/services/crud/notes/note.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/util/constants/colors.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/cloud/cloud_note.dart';
import '../../services/crud/notes/note_editing_mode.dart';
import '../custom_widgets/dialogs.dart';
import '../custom_widgets/icon.dart';
import '../custom_widgets/textfield.dart';

class NoteEditorView extends StatefulWidget {
  final NoteEditingMode noteEditingMode;

  const NoteEditorView({super.key, required this.noteEditingMode});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  CloudNote? _passedNote;
  late final CloudStorageService _notesService;
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late bool _isFavorite;
  late Color _backgroundColor;
  late final NoteEditingMode _noteEditingMode;

  @override
  void initState() {
    _notesService = CloudStorageService();
    _noteEditingMode = widget.noteEditingMode;
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
      leading: const BackButton(),
      elevation: 10,
      actions: [
        if (_noteEditingMode == NoteEditingMode.existingNote) ...[
          IconButton(
              icon: const AppIcon(icon: Icons.delete),
              onPressed: () async {
                final shouldDeleteNote = await AppDialog.showConfirmationDialog(
                    buildContext: context,
                    title: 'Delete Note',
                    content: 'Do you really want to delete this note?',
                    confirmIcon: Icons.delete_rounded,
                    cancelIcon: Icons.cancel);
                if (shouldDeleteNote) {
                  _deleteNote(noteId: _passedNote!.documentId);
                  if (mounted) Navigator.maybePop(context);
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
            onPressed: () {
              final text =
                  '${_titleController.text}\n${_contentController.text}';
              Share.share(text);
            },
            icon: const AppIcon(icon: Icons.share)),
        IconButton(
            onPressed: () async {
              final note = NoteDto(
                  title: _titleController.text,
                  content: _contentController.text,
                  color: _backgroundColor,
                  isFavorite: _isFavorite);
              final pushedNoteInDatabase =
                  _noteEditingMode == NoteEditingMode.newNote
                      ? await _createNewNote(newNote: note)
                      : await _updateExistingNote(
                          updatedNote: note, noteId: _passedNote!.documentId);
              log(pushedNoteInDatabase.toString());
              if (mounted) Navigator.maybePop(context);
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

  Future<CloudNote> _createNewNote({required NoteDto newNote}) async {
    final currentUser = AppAuthService.firebase().currentUser!;
    return await _notesService.createNewNote(
        ownerUserId: currentUser.id, note: newNote);
  }

  Future<CloudNote> _updateExistingNote(
      {required NoteDto updatedNote, required String noteId}) async {
    return await _notesService.updateNote(
        note: updatedNote, documentId: noteId);
  }

  Future<void> _deleteNote({required String noteId}) async {
    _notesService.deleteNote(documentId: noteId);
  }
}
