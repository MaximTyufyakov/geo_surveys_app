import 'package:flutter/material.dart';

/// A widget with a message in the center.
///
/// The [mes] parameter is a display message.
class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.mes});

  /// Message.
  final String mes;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(mes,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      );
}
