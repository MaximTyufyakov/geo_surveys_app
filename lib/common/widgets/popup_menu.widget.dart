import 'package:flutter/material.dart';

/// The main page with a list of all tasks in the database.
class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({
    super.key,
    required this.onLogout,
    required this.onMap,
  });

  /// Logout operation.
  final VoidCallback onLogout;

  /// Map opening operation.
  final VoidCallback onMap;

  @override
  Widget build(BuildContext context) => PopupMenuButton(
    itemBuilder: (context) => [
      // Map.
      const PopupMenuItem(
        value: 1,
        // onTap: () {},
        child: Row(
          children: [
            Icon(Icons.wifi_off_outlined),
            SizedBox(width: 10),
            Text('Оффлайн-режим'),
          ],
        ),
      ),
      // Map.
      PopupMenuItem(
        value: 1,
        onTap: onMap,
        child: const Row(
          children: [
            Icon(Icons.map),
            SizedBox(width: 10),
            Text('Открыть карту'),
          ],
        ),
      ),
      // Exit.
      PopupMenuItem(
        value: 2,
        onTap: onLogout,
        child: const Row(
          children: [Icon(Icons.logout), SizedBox(width: 10), Text('Выход')],
        ),
      ),
    ],
  );
}
