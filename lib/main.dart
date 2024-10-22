import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Reader Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Open File Explorer and Read File'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedFile;
  String? _fileContent;

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null && result.files.single.path != null) {
      String filePath = result.files.single.path!;

      File file = File(filePath);
      String content = await file.readAsString(); // Lê o arquivo como String

      if (filePath.endsWith('.rtf')) {
        content = _cleanRtf(content);
      }
      setState(() {
        _selectedFile = result.files.single.name;
        _fileContent = content;
      });
    } else {
      setState(() {
        _selectedFile = null;
        _fileContent = null;
      });
    }
  }

  String _cleanRtf(String rtfContent) {
    return rtfContent
        .replaceAll(RegExp(r'\\[a-z]+\d*'), '')
        .replaceAll(RegExp(r'[{}]'), '')
        .replaceAll(RegExp(r';'), '')
        .replaceAll(RegExp(r'\*'), '')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(
                  'Clique no botão "+" para selecionar um arquivo e ler o conteúdo',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            if (_selectedFile != null) ...[
              const SizedBox(height: 20),
              Text(
                'Arquivo selecionado: $_selectedFile',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Conteúdo do arquivo:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Text(
                    _fileContent ?? 'Erro ao ler o arquivo',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ]
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        tooltip: 'Open File Explorer',
        child: const Icon(Icons.add),
      ),
    );
  }
}
