import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/choice_dialog.widget.dart';

/// Dialog with unsaved message.
class UnsavedDialog extends ChoiceDialog {
  UnsavedDialog({
    super.key,
  }) : super(
          title: 'Внимание',
          contentList: [
            const Text('Несохранённые данные будут удалены.'),
            const Text('Вы уверены?')
          ],
          greenTitle: 'Да',
          redTitle: 'Отмена',
        );
}
