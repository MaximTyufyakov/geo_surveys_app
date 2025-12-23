import 'package:flutter/material.dart';

/// The main page with a list of all tasks in the database.
class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key, required this.logout});

  /// Logout operation.
  final VoidCallback logout;

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
      const PopupMenuItem(
        value: 1,
        // onTap: () {},
        child: Row(
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
        onTap: logout,
        child: const Row(
          children: [Icon(Icons.logout), SizedBox(width: 10), Text('Выход')],
        ),
      ),
    ],
  );
}
