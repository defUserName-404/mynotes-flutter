import 'package:flutter/material.dart';
import 'package:mynotes/routing/home_page_routing.dart';
import 'package:mynotes/util/constants/routes.dart';
import 'package:mynotes/util/constants/note_editing_mode.dart';
import 'package:mynotes/util/theme/app_theme.dart';
import 'package:mynotes/views/home_view.dart';
import 'package:mynotes/views/login_view.dart';
import 'package:mynotes/views/register_view.dart';
import 'package:mynotes/views/verify_email_view.dart';
import 'package:mynotes/views/notes_editor_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyNotes',
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomePageRouting(),
      routes: {
        loginRoute: (context) => const LoginView(),
        registerRoute: (context) => const RegisterView(),
        verifyEmailRoute: (context) => const VerifyEmailView(),
        homeRoute: (context) => const HomeView(),
        noteEditorExistingNoteRoute: (context) =>
            const NoteEditorView(noteEditingMode: NoteEditingMode.exitingNote),
        noteEditorNewNoteRoute: (context) =>
            const NoteEditorView(noteEditingMode: NoteEditingMode.newNote),
      },
    );
  }
}
