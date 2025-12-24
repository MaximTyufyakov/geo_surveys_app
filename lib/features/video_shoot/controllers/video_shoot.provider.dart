import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

/// A provider of the video shoot page.
class VideoShootProvider extends ChangeNotifier {
  VideoShootProvider({required this.goBack})
    : cameraController = _initController();

  /// The camera controller.
  final Future<CameraController> cameraController;

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
  ///
  /// Throws a [Future.error] with [String] message if initialization failed.
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
          /// Start.
          if (!value.value.isRecordingVideo) {
            await value.startVideoRecording();
            notifyListeners();

            /// Stop.
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

  /// Back button handler.
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
