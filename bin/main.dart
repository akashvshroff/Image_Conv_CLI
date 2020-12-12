import 'package:cli_wizard_avs/cli_wizard_avs.dart';
import 'dart:io';

void main() {
  final Prompter prompter = Prompter();
  final bool choice = prompter.askBinary('Are you here to convert an image?');
  if (!choice) {
    exit(0);
  }

  final String format =
      prompter.askMultiple('Select format:', buildFormatOptions());

  final image =
      prompter.askMultiple('Select an image to convert:', buildFileOptions());
  print(image);

  // print(buildFileOptions());
}

List<Option> buildFormatOptions() {
  return [
    Option(label: 'Convert to jpeg', value: 'jpeg'),
    Option(label: 'Convert to png', value: 'png')
  ];
}

List<Option> buildFileOptions() {
  return Directory.current.listSync().where((entity) {
    return FileSystemEntity.isFileSync(entity.path) &&
        entity.path.contains(RegExp(r'\.(png|jpg|jpeg)'));
  }).map((entity) {
    final String filename = entity.path.split(Platform.pathSeparator).last;
    return Option(label: filename, value: entity);
  }).toList();
}
