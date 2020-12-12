import 'dart:io';
import 'package:image/image.dart';

String convertImage(FileSystemEntity selectedFile, String format) {
  final List<int> rawImage = (selectedFile as File).readAsBytesSync();
  final Image image = decodeImage(rawImage);

  var newImage;
  if (format == 'jpeg') {
    newImage = encodeJpg(image);
  } else if (format == 'png') {
    newImage = encodePng(image);
  } else {
    stdout.writeln('Error: Unsupported file type.');
  }
  final String newPath = replaceExtension(selectedFile.path, format);
  File(newPath).writeAsBytesSync(newImage);
  return newPath;
}

String replaceExtension(String path, String newExtension) {
  // path with every occurence of old extension replaced
  return path.replaceAll(RegExp(r'(png|jpg|jpeg)'), newExtension);
}
