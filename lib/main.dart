import "package:flutter/material.dart";
import "package:mynotes/pages/home_page.dart";
import "package:mynotes/util/theme/app_theme.dart";
import "package:mynotes/views/login_view.dart";
import "package:mynotes/views/notes_view.dart";
import "package:mynotes/views/register_view.dart";
import "package:mynotes/views/verify_email_view.dart";

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyNotesApp());
}

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MyNotes",
      themeMode: ThemeMode.system,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      home: const HomePage(),
      routes: {
        "/login": (context) => const LoginView(),
        "/register": (context) => const RegisterView(),
        "/verify-email": (context) => const VerifyEmailView(),
        "/notes": (context) => const NotesView()
      },
    );
  }
}
