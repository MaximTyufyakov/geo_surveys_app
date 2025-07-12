import 'package:flutter/material.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';

/// A ViewModel of the point.
class PointViewModel extends ChangeNotifier {
  PointViewModel({
    required this.model,
  });

  /// Model with point.
  final PointModel model;

  /// Tap on the point CheckBox.
  void onPointTap() {
    model.comletedInverse();
    notifyListeners();
  }
}
