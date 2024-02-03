import 'package:flutter/material.dart';
import 'package:mynotes/custom_widgets/reused_widgets.dart';
import 'package:mynotes/custom_widgets/textfield.dart';
import 'package:mynotes/util/constants/colors.dart';

class NoteEditorView extends StatefulWidget {
  const NoteEditorView({super.key});

  @override
  State<NoteEditorView> createState() => _NoteEditorViewState();
}

class _NoteEditorViewState extends State<NoteEditorView> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
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
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {},
            ),
            IconButton(
              icon: const Icon(Icons.favorite_rounded),
              onPressed: () {},
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.check))
          ],
        ),
        body: Padding(
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
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    for (Color color in colorSwatchForNote)
                      GestureDetector(
                        onTap: () {
                          showToast('hello', color, Colors.black);
                        },
                        child: CircleAvatar(
                          backgroundColor: color,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
