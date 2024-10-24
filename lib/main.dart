import 'package:flutter/material.dart';
import 'package:flutter_application_1/form.dart';
import 'package:flutter_application_1/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isDarkMode = false; // Define o estado para o tema

  void toggleTheme() {
    setState(() {
      isDarkMode = !isDarkMode; // Alterna entre claro e escuro
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Reader Example',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: MyHomePage(
          title: 'Open File Explorer and Read File', toggleTheme: toggleTheme),
      routes: {
        '/form': (context) => const MyCustomForm(),
      },
    );
  }
}
