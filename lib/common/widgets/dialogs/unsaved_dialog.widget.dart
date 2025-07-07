import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/abstract_dialog.widget.dart';

/// Dialog with unsaved message.
///
/// Returns true when GreenBtn is clicked.
/// Returns false when RedBtn is clicked.
class UnsavedDialog extends AbstractDialog {
  UnsavedDialog({
    super.key,
  }) : super(
          title: 'Внимание',
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Имеются несохранённые данные.'),
              Text('Сохранить?')
            ],
          ),
          greenTitle: 'Да',
          redTitle: 'Нет',
        );
}
