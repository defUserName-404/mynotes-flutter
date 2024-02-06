import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mynotes/custom_widgets/textfield.dart';
import 'package:mynotes/models/note.dart';
import 'package:mynotes/util/constants/colors.dart';

import '../custom_widgets/icon.dart';

class NoteEditorView extends StatefulWidget {
  const NoteEditorView({super.key});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  late bool _isFavorite;
  late Color _backgroundColor;

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    _isFavorite = false;
    _backgroundColor =
        WidgetsBinding.instance.window.platformBrightness == Brightness.light
            ? CustomColors.light
            : CustomColors.dark;
    super.initState();
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
      actions: [
        IconButton(
          icon: const AppIcon(icon: Icons.delete),
          onPressed: () {},
        ),
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
              final note = Note(
                  title: _titleController.text,
                  content: _contentController.text,
                  color: Colors.red,
                  isFavorite: _isFavorite);
              log(note.toString());
            },
            icon: const AppIcon(icon: Icons.check))
      ],
    );
  }

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: AppTextField(
                  controller: _titleController,
                  hintText: 'Title',
                  labelText: ''),
            ),
            Expanded(
              child: AppTextField(
                  controller: _contentController,
                  hintText: 'Start typing your note here',
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
