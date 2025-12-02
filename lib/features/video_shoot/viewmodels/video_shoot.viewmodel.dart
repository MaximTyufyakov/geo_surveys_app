import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A ViewModel of the video shoot page.
class VideoShootViewModel extends ChangeNotifier {
  VideoShootViewModel() : controller = _initController();

  /// The camera controller.
  Future<CameraController> controller;

  /// Initialize camera controller.
  ///
  /// Return [Future] of the [CameraController] initialize.
  static Future<CameraController> _initController() async {
    try {
      /// Create a CameraController.
      final cameras = await availableCameras();
      final CameraDescription camera = cameras.first;
      CameraController localController = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: true,
      );
      await localController.initialize();
      return localController;
    } catch (err) {
      return Future.error('Не удаётся получить доступ к камере.');
    }
  }

  /// Opens a page with information about task.
  void exit(File video, BuildContext context) {
    Navigator.pop(
      context,
      video,
    );
  }

  /// Press shoot button.
  Future<void> shootPressed(BuildContext context) async {
    await controller.then((value) async {
      if (!value.value.isRecordingVideo) {
        await value.startVideoRecording();
        notifyListeners();
      } else {
        final XFile video = await value.stopVideoRecording();
        notifyListeners();
        context.mounted ? exit(File(video.path), context) : null;
      }
    }).catchError((err) {});
  }
}
