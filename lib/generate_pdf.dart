import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

class GeneratePDF extends StatefulWidget {
  const GeneratePDF({super.key});

  @override
  State<GeneratePDF> createState() => _GeneratePDFState();
}

class _GeneratePDFState extends State<GeneratePDF> {
  String? _fileContent;

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }

  Future<void> _generatePdf() async {
    if (_fileContent == null || _fileContent!.isEmpty) {
      // Mostra um aviso se o arquivo não foi lido
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Nenhum conteúdo disponível para gerar o PDF!')),
      );
      return;
    }

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text(_fileContent!),
          );
        },
      ),
    );
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
