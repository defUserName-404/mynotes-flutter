import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/services/auth/bloc/auth_bloc.dart';
import 'package:mynotes/services/auth/firebase_auth_provider.dart';
import 'package:mynotes/services/crud/notes/note_editing_mode.dart';
import 'package:mynotes/util/constants/routes.dart';
import 'package:mynotes/util/theme/app_theme.dart';
import 'package:mynotes/views/auth_view/change_password_view.dart';
import 'package:mynotes/views/notes_view/notes_editor_view.dart';
import 'package:mynotes/views/routing/app_routing.dart';

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
      home: BlocProvider<AppAuthBloc>(
          create: (context) =>
              AppAuthBloc(appAuthProvider: FirebaseAppAuthProvider()),
          child: const AppRouting()),
      routes: {
        noteEditorExistingNoteRoute: (context) =>
            const NoteEditorView(noteEditingMode: NoteEditingMode.existingNote),
        noteEditorNewNoteRoute: (context) =>
            const NoteEditorView(noteEditingMode: NoteEditingMode.newNote),
        changePasswordRoute: (context) => const ChangePasswordView()
      },
    );
  }
}
