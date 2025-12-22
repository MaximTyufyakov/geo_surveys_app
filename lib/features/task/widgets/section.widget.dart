import 'package:flutter/material.dart';

/// Widget with section title, divider, content and vspace.
class SectionWidget extends StatelessWidget {
  const SectionWidget({super.key, required this.title, required this.content});

  /// Section name.
  final String title;

  /// Section content.
  final Widget content;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(title, style: Theme.of(context).textTheme.titleMedium),
      const Divider(),
      content,
      const SizedBox(height: 20),
    ],
  );
}
