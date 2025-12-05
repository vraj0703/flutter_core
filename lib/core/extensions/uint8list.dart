import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'file.dart';
import 'image.dart';

extension Uint8ListExtention on Uint8List {
  Future<File?> cropAndOrResizeImageByRect({
    double? widgetWidth,
    Rect? cropRect,
    int? maxSize,
    String fileSuffix = '/temp/cropped_resized_image',
  }) async {
    // Load the image file
    img.Image? originalImage = img.decodeImage(this);
    if (originalImage == null) {
      return null;
    }

    img.Image croppedImage;
    if (cropRect != null && widgetWidth != null) {
      croppedImage = originalImage.cropByRect(cropRect, widgetWidth);
    } else {
      croppedImage = originalImage;
    }

    if (maxSize != null) {
      // Determine whether to resize based on maxSize
      croppedImage = croppedImage.resizeToMaxSize(maxSize);
    }

    final finalFile = await getTemporaryFileWithSuffix(fileSuffix);

    // Write the cropped (and optionally resized) image to the file
    await finalFile.writeAsBytes(img.encodeJpg(croppedImage));

    return finalFile;
  }
}
