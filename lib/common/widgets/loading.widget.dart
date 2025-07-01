import 'package:flutter/material.dart';
import 'package:geo_surveys_app/main.dart';

/// A widget with a CircularProgressIndicator in the center.
///
/// {@category Widgets}
class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: MainApp.displayColor),
          ],
        ),
      );
}
