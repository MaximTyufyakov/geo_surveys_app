import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/video_shoot/controllers/video_shoot.provider.dart';
import 'package:provider/provider.dart';

// A screen that allows users to take a picture using a given camera.
class VideoShootPage extends StatelessWidget {
  const VideoShootPage({super.key});

  /// Back system button push.
  Future<void> _onPopInvoked(bool didPop, VideoShootProvider provider) async {
    if (!didPop) {
      await provider.onExit();
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) => ChangeNotifierProvider<VideoShootProvider>(
    create: (BuildContext context) =>
        VideoShootProvider(goBack: (video) => Navigator.of(context).pop(video)),
    child: Consumer<VideoShootProvider>(
      builder: (context, provider, child) => Scaffold(
        backgroundColor: Colors.black,

        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) =>
              _onPopInvoked(didPop, provider),
          child: FutureBuilder<CameraController>(
            future: provider.cameraController,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Expanded(
                        flex: 6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [CameraPreview(snapshot.data!)],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              style: ButtonStyle(
                                backgroundColor: WidgetStateProperty.all<Color>(
                                  Colors.white,
                                ),
                                foregroundColor: WidgetStateProperty.all<Color>(
                                  Colors.red,
                                ),
                              ),
                              onPressed: () => provider.shootPressed(),
                              icon: snapshot.data!.value.isRecordingVideo
                                  ? const Icon(Icons.square)
                                  : const Icon(Icons.circle),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else if (snapshot.hasError) {
                  return MessageWidget(
                    mes: snapshot.error.toString(),
                    icon: Icons.error,
                  );
                }
              }
              return const LoadingWidget();
            },
          ),
        ),
      ),
    ),
  );
}
