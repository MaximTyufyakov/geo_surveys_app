import 'package:flutter/material.dart';

/// The main page with a list of all tasks in the database.
class PopupMenuWidget extends StatelessWidget {
  const PopupMenuWidget({super.key, required this.beforeExit});

  /// Operations before exit.
  /// Returns true if access exit.
  final ValueGetter<Future<bool>>? beforeExit;

  @override
  Widget build(BuildContext context) => PopupMenuButton(
        itemBuilder: (context) => [
          // Map.
          PopupMenuItem(
            value: 1,
            onTap: () {},
            child: const Row(
              children: [
                Icon(Icons.wifi_off_outlined),
                SizedBox(
                  width: 10,
                ),
                Text('Оффлайн-режим')
              ],
            ),
          ),
          // Map.
          PopupMenuItem(
            value: 1,
            onTap: () {},
            child: const Row(
              children: [
                Icon(Icons.map),
                SizedBox(
                  width: 10,
                ),
                Text('Открыть карту')
              ],
            ),
          ),
          // Exit.
          PopupMenuItem(
            value: 2,
            onTap: () async {
              bool exit = true;
              if (beforeExit != null) {
                exit = await beforeExit!();
              }
              if (exit && context.mounted) {
                Navigator.of(context).popUntil(
                  ModalRoute.withName(
                    '/',
                  ),
                );
              }
            },
            child: const Row(
              children: [
                Icon(Icons.logout),
                SizedBox(
                  width: 10,
                ),
                Text('Выход')
              ],
            ),
          ),
        ],
      );
}
