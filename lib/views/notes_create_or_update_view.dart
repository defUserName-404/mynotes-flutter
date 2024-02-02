import 'package:flutter/material.dart';
import 'package:mynotes/custom_widgets/textfield.dart';

class NotesCreateOrUpdateView extends StatefulWidget {
  const NotesCreateOrUpdateView({super.key});

  @override
  State<NotesCreateOrUpdateView> createState() =>
      _NotesCreateOrUpdateViewState();
}

class _NotesCreateOrUpdateViewState extends State<NotesCreateOrUpdateView> {
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
                  labelText: 'Title'),
            ),
            Expanded(
              child: AppTextField(
                  controller: _contentController,
                  hintText: 'Start typing your note here',
                  expands: true,
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  labelText: 'Content'),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.brown,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.cyan,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.teal,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.blueGrey,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
