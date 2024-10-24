import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class MyCustomForm extends StatefulWidget {
  const MyCustomForm({super.key});

  @override
  MyCustomFormState createState() {
    return MyCustomFormState();
  }
}

const List<String> list = <String>['One', 'Two', 'Three', 'Four'];

class MyCustomFormState extends State<MyCustomForm> {
  final _formKey = GlobalKey<FormState>();

  // Variáveis para capturar os dados preenchidos no formulário
  String _name = '';
  String _dropdownValue = list.first;
  SingingCharacter? _radioValue = SingingCharacter.the_beatles;
  final TextEditingController _ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Screen'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            // Campo de nome
            TextFormField(
              decoration: const InputDecoration(
                  hintText: 'Enter your name', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            const SizedBox(height: 16),

            // Campo de idade
            TextFormField(
              controller: _ageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                  hintText: 'Enter your age', border: OutlineInputBorder()),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your age';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),

            // Dropdown
            const Text('Dropdown Example'),
            DropdownButton<String>(
              value: _dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                setState(() {
                  _dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // RadioButton
            const Text('Radio Button Example'),
            ListTile(
              title: const Text('The Beatles'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.the_beatles,
                groupValue: _radioValue,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _radioValue = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('The Rolling Stones'),
              leading: Radio<SingingCharacter>(
                value: SingingCharacter.the_rolling_stone,
                groupValue: _radioValue,
                onChanged: (SingingCharacter? value) {
                  setState(() {
                    _radioValue = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),

            // GridView Example
            const Text('GridView Example'),
            SizedBox(
              height: 150,
              child: GridView.count(
                crossAxisCount: 2,
                children: List.generate(2, (index) {
                  return Center(
                    child: Text(
                      'Item $index',
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),

            // Botão para gerar PDF
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _generatePdf();
                }
              },
              child: const Text('Generate PDF'),
            ),
            const SizedBox(height: 20),

            // Botão para mostrar valores preenchidos
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _showFormValues();
                }
              },
              child: const Text('Mostrar valores'),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Função para gerar o PDF
  Future<void> _generatePdf() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Text('Name: $_name', style: const pw.TextStyle(fontSize: 20)),
              pw.Text('Selected Dropdown: $_dropdownValue',
                  style: const pw.TextStyle(fontSize: 20)),
              pw.Text(
                'Radio Selection: ${_radioValue == SingingCharacter.the_beatles ? 'The Beatles' : 'The Rolling Stones'}',
                style: const pw.TextStyle(fontSize: 20),
              ),
            ],
          );
        },
      ),
    );

    // Abre a visualização de impressão para o PDF
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  void _showFormValues() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Valores do Formulário'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Name: $_name'),
              Text('Age: ${_ageController.text}'),
              Text('Selected Dropdown: $_dropdownValue'),
              Text(
                'Radio Selection: ${_radioValue == SingingCharacter.the_beatles ? 'The Beatles' : 'The Rolling Stones'}',
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Fechar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class DropdownButtonExample extends StatefulWidget {
  const DropdownButtonExample({super.key});

  @override
  State<DropdownButtonExample> createState() => _DropdownButtonExampleState();
}

class _DropdownButtonExampleState extends State<DropdownButtonExample> {
  String dropdownValue = list.first;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: dropdownValue,
      icon: const Icon(Icons.arrow_downward),
      elevation: 16,
      style: const TextStyle(color: Colors.deepPurple),
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
        });
      },
      items: list.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
    );
  }
}

// ignore: constant_identifier_names
enum SingingCharacter { the_beatles, the_rolling_stone }

class RadioExample extends StatefulWidget {
  const RadioExample({super.key});

  @override
  State<RadioExample> createState() => _RadioExampleState();
}

class _RadioExampleState extends State<RadioExample> {
  SingingCharacter? _character = SingingCharacter.the_beatles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
          title: const Text('The Beatles'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.the_beatles,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
        ListTile(
          title: const Text('The Rolling Stones'),
          leading: Radio<SingingCharacter>(
            value: SingingCharacter.the_rolling_stone,
            groupValue: _character,
            onChanged: (SingingCharacter? value) {
              setState(() {
                _character = value;
              });
            },
          ),
        ),
      ],
    );
  }
}
