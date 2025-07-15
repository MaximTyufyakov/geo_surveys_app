import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/video_shoot/viewmodels/video_shoot.viewmodel.dart';
import 'package:provider/provider.dart';

// A screen that allows users to take a picture using a given camera.
class VideoShootPage extends StatelessWidget {
  const VideoShootPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<VideoShootViewModel>(
        create: (BuildContext context) => VideoShootViewModel(),
        child: Consumer<VideoShootViewModel>(
          builder: (context, provider, child) => Scaffold(
            backgroundColor: Colors.black,
            // You must wait until the controller is initialized before displaying
            // the camera preview. Use a FutureBuilder to display a loading spinner
            // until the controller has finished initializing.
            body: FutureBuilder<CameraController>(
              future: provider.controller,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Expanded(
                          flex: 5,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              CameraPreview(
                                snapshot.data!,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              iconSize: 40,
                              style: Theme.of(context)
                                  .iconButtonTheme
                                  .style!
                                  .copyWith(
                                    backgroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.white,
                                    ),
                                    foregroundColor:
                                        WidgetStateProperty.all<Color>(
                                      Colors.red,
                                    ),
                                  ),
                              onPressed: () {
                                provider.shootPressed(context);
                              },
                              icon: snapshot.data!.value.isRecordingVideo
                                  ? const Icon(Icons.square)
                                  : const Icon(Icons.circle),
                            ),
                          ],
                        ))
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return MessageWidget(
                      mes: snapshot.error.toString(),
                    );
                  }
                }
                return const LoadingWidget();
              },
            ),
          ),
        ),
      );
}
