import 'package:flutter/material.dart';
import 'notes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;
  void _toggleDarkMode() => setState(() => _isDarkMode = !_isDarkMode);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peninsight',
      theme: _isDarkMode
          ? ThemeData.dark().copyWith(
              primaryColor: Colors.deepOrange,
              colorScheme: ColorScheme.dark(primary: Colors.deepOrange),
            )
          : ThemeData(
              primarySwatch: Colors.deepOrange,
              brightness: Brightness.light,
            ),
      home: NotesPage(
        isDarkMode: _isDarkMode,
        onToggleDarkMode: _toggleDarkMode,
      ),
    );
  }
}
