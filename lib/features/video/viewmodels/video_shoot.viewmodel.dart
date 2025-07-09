import 'dart:developer' as dev;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// A ViewModel of the task page.
///
/// The [context] is the context of the task page.
class VideoShootViewModel extends ChangeNotifier {
  VideoShootViewModel({
    required this.context,
  });

  /// The context of the task page.
  final BuildContext context;
  static late CameraController controller;

  Future<void> init() async {
    final cameras = await availableCameras();
    final CameraDescription camera = cameras.first;
    // To display the current output from the Camera,
    // create a CameraController.
    controller = CameraController(
      // Get a specific camera from the list of available cameras.
      camera,
      // Define the resolution to use.
      ResolutionPreset.high,
    );

    return controller.initialize();
  }

  /// Opens a page with information about task.
  void exit() async {}

  Future<void> shootPressed(BuildContext context) async {
    // Take the Picture in a try / catch block. If anything goes wrong,
    // catch the error.
    try {
      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await controller.takePicture();

      if (!context.mounted) return;

      // If the picture was taken, display it on a new screen.
      // await Navigator.of(context).push(
      //   MaterialPageRoute<dynamic>(
      //     builder: (context) => DisplayPictureScreen(
      //       // Pass the automatically generated path to
      //       // the DisplayPictureScreen widget.
      //       imagePath: image.path,
      //     ),
      //   ),
      // );
    } catch (e) {
      // If an error occurs, log the error to the console.
      dev.log('{$e}');
    }
  }
}
