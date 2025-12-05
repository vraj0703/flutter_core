import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'uint8list.dart';

extension XFileExtension on XFile {
  Future<File?> cropAndResizeImageByRect({
    double? screenWidth,
    Rect? cropRect,
    int? maxSize,
    String fileSuffix = '/temp/cropped_resized_image',
  }) async {
    return (await readAsBytes()).cropAndOrResizeImageByRect(
      widgetWidth: screenWidth,
      cropRect: cropRect,
      maxSize: maxSize,
      fileSuffix: fileSuffix,
    );
  }
}

extension FileExtension on File {
  Future<File?> cropAndResizeImageByRect({
    double? screenWidth,
    Rect? cropRect,
    int? maxSize,
    String fileSuffix = '/temp/cropped_resized_image',
  }) async {
    return (await readAsBytes()).cropAndOrResizeImageByRect(
      widgetWidth: screenWidth,
      cropRect: cropRect,
      maxSize: maxSize,
      fileSuffix: fileSuffix,
    );
  }
}

Future<File> getTemporaryFileWithSuffix(String fileSuffix) async {
  // Determine the directory and file name for the new image
  final directory = await getTemporaryDirectory();
  final finalImagePath = '${directory.path}$fileSuffix.jpg';
  File croppedFile = File(finalImagePath);
  // Check if the file already exists and delete it if so
  if (await croppedFile.exists()) {
    await croppedFile.delete(recursive: true);
  }
  final finalFile = File(finalImagePath);

  finalFile.createSync(recursive: true);
  return finalFile;
}

String getGoogleDocsPdfViewerUrl(String url) {
  const String googleDocsBase = 'https://docs.google.com/gview?embedded=true&url=';
  if (url.contains('.pdf') && !url.contains('docs.google.com')) {
    return googleDocsBase + url;
  }
  return url;
}

