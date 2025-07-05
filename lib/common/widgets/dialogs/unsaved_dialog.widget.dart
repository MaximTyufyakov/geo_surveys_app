import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/abstract_dialog.widget.dart';

/// Dialog with unsaved message.
class UnsavedDialog extends AbstractDialog {
  UnsavedDialog({
    super.key,
  }) : super(
          title: 'Внимание',
          content: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Несохранённые данные будут удалены.'),
              Text('Вы уверены?'),
            ],
          ),
          greenTitle: 'Да',
          redTitle: 'Отмена',
        );
}
