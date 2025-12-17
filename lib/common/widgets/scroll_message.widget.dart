import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';

/// A widget with a scrollable message and icon in the center.
///
/// The [mes] parameter is a display message.
/// The [icon] parameter is a display icon.
class ScrollMessageWidget extends StatelessWidget {
  const ScrollMessageWidget({super.key, required this.mes, required this.icon});

  /// Message.
  final String mes;

  /// Icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) =>
      // For scroll in RefreshIndicator.
      CustomScrollView(
        slivers: [
          SliverFillRemaining(
            hasScrollBody: false,
            child: MessageWidget(
              mes: mes,
              icon: icon,
            ),
          ),
        ],
      );
}
