import 'package:cli_wizard_avs/cli_wizard_avs.dart'; // my dart cli package
import 'dart:io';
import 'package:Image_Conv_CLI/src/converter.dart';

void main() {
  final Prompter prompter = Prompter();
  final bool choice = prompter.askBinary('Are you here to convert an image?');
  if (!choice) {
    exit(0);
  }

  final String format =
      prompter.askMultiple('Select format:', buildFormatOptions());

  String filterFormat = format == 'png' ? 'jpeg|jpg' : 'png';
  final List<Option> fileOptions = buildFileOptions(filterFormat);
  if (fileOptions.isEmpty) {
    stdout.writeln(
        'Error: No file can be converted in current working directory.');
    exit(0);
  }
  final FileSystemEntity selectedFile =
      prompter.askMultiple('Select an image to convert:', fileOptions);
  final String newPath = convertImage(selectedFile, format);

  final bool shouldOpen =
      prompter.askBinary('Conversion complete. Open the image?');

  if (shouldOpen) {
    Process.run('explorer', [newPath]);
  }
}

List<Option> buildFormatOptions() {
  //returns the format options
  return [
    Option(label: 'Convert png to jpeg', value: 'jpeg'),
    Option(label: 'Convert jpeg or jpg to png', value: 'png')
  ];
}

List<Option> buildFileOptions(String fileType) {
  // all the possible image files (in the cwd) that can be converted
  return Directory.current.listSync().where((entity) {
    return FileSystemEntity.isFileSync(entity.path) &&
        entity.path.contains(RegExp(r'\.(' + fileType + ')'));
  }).map((entity) {
    final String filename = entity.path.split(Platform.pathSeparator).last;
    return Option(label: filename, value: entity);
  }).toList();
}
