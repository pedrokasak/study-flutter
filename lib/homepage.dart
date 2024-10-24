import 'package:flutter/material.dart';
import 'package:flutter_application_1/file_handler.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title, required this.toggleTheme});

  final String title;
  final Function toggleTheme; // Função para alternar o tema

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String? _selectedFile;
  String? _fileContent;

  Future<void> _pickFile() async {
    String? filePath = await pickFile();

    if (filePath != null) {
      String content = await readFile(filePath); // Lê o arquivo
      if (filePath.endsWith('.rtf')) {
        content = cleanRtf(content);
      }
      if (filePath.endsWith('.pdf')) {
        const SnackBar(
            content: Text('Não é possivel ler conteudo de arquivo PDF'));
        return;
      }
      setState(() {
        _selectedFile = filePath.split('/').last;
        _fileContent = content;
      });
    } else {
      setState(() {
        _selectedFile = null;
        _fileContent = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.black), // Estilo de texto padrão
                    children: [
                      TextSpan(
                        text:
                            'Clique no botão "+" para selecionar um arquivo e ler o conteúdo.\n\n',
                      ),
                      TextSpan(
                        text: 'Clique no botão ',
                      ),
                      WidgetSpan(
                        child:
                            Icon(Icons.newspaper, size: 18), // Ícone de jornal
                      ),
                      TextSpan(
                        text:
                            ' para Preencher um formulário e gerar o PDF. \n\n',
                      ),
                      TextSpan(
                        text: 'Clique no botão ',
                      ),
                      WidgetSpan(
                        child: Icon(Icons.dark_mode,
                            size: 18), // Ícone de modo escuro
                      ),
                      TextSpan(
                        text: ' para Alterar o tema padrão. \n\n',
                      ),
                    ],
                  ),
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {
              setState(() {
                Navigator.pushNamed(context, '/form');
              });
            },
            tooltip: 'New Form',
            child: const Icon(Icons.newspaper),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: _pickFile,
            tooltip: 'Open File Explorer',
            child: const Icon(Icons.add),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              widget.toggleTheme(); // Alterna o tema ao clicar
            },
            tooltip: 'Alterar tema',
            backgroundColor: Colors.blueAccent,
            child: const Icon(Icons.dark_mode, color: Colors.amber),
          ),
          const SizedBox(width: 16),
          FloatingActionButton(
            onPressed: () {
              setState(() {
                _selectedFile = null;
                _fileContent = null;
              });
            },
            tooltip: 'Clear',
            backgroundColor: Colors.redAccent,
            child: const Icon(Icons.clear, color: Colors.black),
          ),
        ],
      ),
    );
  }
}
