import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/video/viewmodels/video_shoot.viewmodel.dart';
import 'package:provider/provider.dart';

// A screen that allows users to take a picture using a given camera.
class VideoShootPage extends StatefulWidget {
  const VideoShootPage({
    super.key,
  });

  @override
  VideoShootPageState createState() => VideoShootPageState();
}

class VideoShootPageState extends State<VideoShootPage> {
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    VideoShootViewModel.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<VideoShootViewModel>(
        create: (BuildContext context) => VideoShootViewModel(
          context: context,
        ),
        child: Consumer<VideoShootViewModel>(
          builder: (context, provider, child) => Scaffold(
            // You must wait until the controller is initialized before displaying
            // the camera preview. Use a FutureBuilder to display a loading spinner
            // until the controller has finished initializing.
            body: FutureBuilder<void>(
              future: provider.init(),
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.done
                      ?
                      // If the Future is complete, display the preview.
                      Center(
                          child: CameraPreview(
                            VideoShootViewModel.controller,
                          ),
                        )
                      :
                      // Otherwise, display a loading indicator.
                      const Center(child: CircularProgressIndicator()),
            ),
            floatingActionButton: FloatingActionButton(
              // Provide an onPressed callback.
              onPressed: () => provider.shootPressed(context),
              child: const Icon(Icons.camera_alt),
            ),
          ),
        ),
      );
}
