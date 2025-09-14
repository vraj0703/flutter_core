import 'dart:io';

abstract class IFileStorage {
  bool write({required String content, required String filename});

  String read({required String filename});

  bool fileExists(String filename);

  FileStat? fileInfo(String filename);

  removeFile(String filename);
}
