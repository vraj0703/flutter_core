import 'package:camera/camera.dart';

extension CameraControllerExtension on CameraController? {
  void toggleFlash(bool enableFlash) async {
    final CameraController? cameraController = this;

    if (cameraController == null ||
        !cameraController.value.isInitialized ||
        (cameraController.value.flashMode == FlashMode.torch) == enableFlash) {
      return;
    }

    try {
      await cameraController.setFlashMode(
        enableFlash ? FlashMode.torch : FlashMode.off,
      );
    } on CameraException catch (e) {
      rethrow;
    }
  }

  void togglePauseResume(bool playFeed) async {
    final CameraController? cameraController = this;

    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    try {
      if (playFeed) {
        await cameraController.resumePreview();
      } else {
        await cameraController.pausePreview();
      }
    } on CameraException catch (e) {
      rethrow;
    }
  }

  Future<XFile?> takePicture() async {
    final CameraController? cameraController = this;
    if (cameraController == null || !cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      return await cameraController.takePicture();
    } on CameraException catch (e) {
      rethrow;
    }
  }
}
