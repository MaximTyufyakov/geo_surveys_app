import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/choice_dialog.widget.dart';

// Диалог с предупреждением о несохранённых данных
class UnsavedDialogWidget extends StatelessWidget {
  const UnsavedDialogWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) => const ChoiceDialogWidget(
      title: 'Внимание',
      contentList: [
        Text('Несохранённые данные будут удалены.'),
        Text('Вы уверены?')
      ],
      greenTitle: 'Да',
      redTitle: 'Отмена');
}
