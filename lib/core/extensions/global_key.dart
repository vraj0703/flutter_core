import 'package:flutter/material.dart';

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final renderObject = currentContext?.findRenderObject();
    final matrix = renderObject?.getTransformTo(null);

    if (matrix != null && renderObject?.paintBounds != null) {
      final rect = MatrixUtils.transformRect(matrix, renderObject!.paintBounds);
      return rect;
    }
    return null;
  }

  Rect? localPaintBounds(GlobalKey ancestorKey) {
    final renderObject = currentContext?.findRenderObject();
    final ancestorRenderObject = ancestorKey.currentContext?.findRenderObject();

    if (renderObject != null && ancestorRenderObject != null) {
      final matrix = renderObject.getTransformTo(ancestorRenderObject);
      final rect = MatrixUtils.transformRect(matrix, renderObject.paintBounds);
      return rect;
    }
    return null;
  }
}
