import 'package:flutter/material.dart';

class NotesCreateOrUpdateView extends StatefulWidget {
  const NotesCreateOrUpdateView({super.key});

  @override
  State<NotesCreateOrUpdateView> createState() =>
      _NotesCreateOrUpdateViewState();
}

class _NotesCreateOrUpdateViewState extends State<NotesCreateOrUpdateView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(),
    ));
  }
}
