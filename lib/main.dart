import "package:flutter/material.dart";
import "package:mynotes/pages/home_page.dart";
import "package:mynotes/util/theme/app_theme.dart";

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
    );
  }
}
