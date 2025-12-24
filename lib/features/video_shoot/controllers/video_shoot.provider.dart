import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// A ViewModel of the video shoot page.
class VideoShootProvider extends ChangeNotifier {
  VideoShootProvider({required this.goBack})
    : cameraController = _initController();

  /// The camera controller.
  Future<CameraController> cameraController;

  /// Opens a page with information about task.
  final ValueSetter<File?> goBack;

  @override
  Future<void> dispose() async {
    /// Release camera controller.
    await cameraController
        .then((value) {
          value.dispose();
        })
        .catchError((err) {});
    super.dispose();
  }

  /// Initialize camera controller.
  ///
  /// Return [Future] of the [CameraController] initialize.
  static Future<CameraController> _initController() async {
    try {
      /// Create a CameraController.
      final cameras = await availableCameras();
      final CameraDescription camera = cameras.first;
      final CameraController localController = CameraController(
        camera,
        ResolutionPreset.medium,
      );
      await localController.initialize();
      return localController;
    } catch (err) {
      return Future.error('Не удаётся получить доступ к камере.');
    }
  }

  /// Press shoot button.
  Future<void> shootPressed() async {
    await cameraController
        .then((value) async {
          if (!value.value.isRecordingVideo) {
            await value.startVideoRecording();
            notifyListeners();
          } else {
            final XFile video = await value.stopVideoRecording();
            notifyListeners();
            goBack(File(video.path));
          }
        })
        .catchError((Object err) {
          if (kDebugMode) {
            debugPrint('Ошибка инициализации контроллера камеры: $err');
          }
        });
  }

  /// Press back button.
  Future<void> onExit() async {
    await cameraController
        .then((value) async {
          if (!value.value.isRecordingVideo) {
            goBack(null);
          } else {
            final XFile video = await value.stopVideoRecording();
            goBack(File(video.path));
          }
        })
        .catchError((err) {
          goBack(null);
        });
  }
}
