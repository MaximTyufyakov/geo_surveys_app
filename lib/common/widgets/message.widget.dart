import 'package:flutter/material.dart';

/// A widget with a message and icon in the center.
///
/// The [mes] parameter is a display message.
/// The [icon] parameter is a display icon.
class MessageWidget extends StatelessWidget {
  const MessageWidget({super.key, required this.mes, required this.icon});

  /// Message.
  final String mes;

  /// Icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 72,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 20),
              Text(
                mes,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
            ],
          ),
        ),
      );
}
