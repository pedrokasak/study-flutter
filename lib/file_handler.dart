import 'dart:io';
import 'package:file_picker/file_picker.dart';

// Método para selecionar o arquivo
Future<String?> pickFile() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles();

  if (result != null && result.files.single.path != null) {
    return result.files.single.path;
  }
  return null;
}

// Método para ler o arquivo como String
Future<String> readFile(String filePath) async {
  File file = File(filePath);
  return await file.readAsString(); // Lê o arquivo como String
}

// Método para limpar o conteúdo RTF
String cleanRtf(String rtfContent) {
  return rtfContent
      .replaceAll(RegExp(r'\\[a-z]+\d*'), '')
      .replaceAll(RegExp(r'[{}]'), '')
      .replaceAll(RegExp(r';'), '')
      .replaceAll(RegExp(r'\*'), '')
      .trim();
}
