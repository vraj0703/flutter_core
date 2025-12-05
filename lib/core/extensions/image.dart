import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;

extension ImageExtension on img.Image {
  img.Image cropByRect(Rect rect, double screenWidth) {
    // Calculate the crop area
    double scale = this.width / screenWidth;

    int left = (rect.left * scale).toInt();
    int top = (rect.top * scale).toInt();
    int width = (rect.width * scale).toInt();
    int height = (rect.height * scale).toInt();

    // Crop the image
    return img.copyCrop(this, x: left, y: top, width: width, height: height);
  }

  img.Image resizeToMaxSize(int maxSize) {
    final double aspectRatio = width / height;
    int newWidth, newHeight;

    if (width > maxSize || height > maxSize) {
      if (aspectRatio > 1) {
        // Landscape or square image: width is the larger dimension
        newWidth = maxSize;
        newHeight = (maxSize / aspectRatio).round();
      } else {
        // Portrait image: height is the larger dimension
        newWidth = (maxSize * aspectRatio).round();
        newHeight = maxSize;
      }
      return img.copyResize(this, width: newWidth, height: newHeight);
    }
    return this;
  }
}
