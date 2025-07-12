import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

/// A ViewModel of the video shoot page.
///
/// The [context] is the context of the video shoot page.
class VideoShootViewModel extends ChangeNotifier {
  VideoShootViewModel({
    required this.context,
  }) : controller = _initController();

  /// The context of the video shoot page.
  final BuildContext context;

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

  /// ViewModel dispose.
  @override
  void dispose() async {
    // Dispose of the controller when the widget is disposed.
    await controller.then((value) {
      value.dispose();
    }).catchError((err) {});
    super.dispose();
  }

  /// Opens a page with information about task.
  void exit() async {}

  /// Press shoot button.
  Future<void> shootPressed() async {
    await controller.then((value) async {
      if (!value.value.isRecordingVideo) {
        await value.startVideoRecording();
        notifyListeners();
      } else {
        final XFile video = await value.stopVideoRecording();
        notifyListeners();
        final Directory docDir = await getApplicationDocumentsDirectory();
        final Directory videosDir = Directory('${docDir.path}/videos');
        await videosDir.create(recursive: true);
        final String videoPath =
            '${videosDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
        final File videoFile = await File(video.path).rename(videoPath);
      }
    }).catchError((err) {});
  }
}
