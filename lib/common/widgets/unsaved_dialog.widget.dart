import 'package:geo_surveys_app/common/widgets/choice_dialog.widget.dart';

/// Dialog with unsaved message.
class UnsavedDialog extends ChoiceDialog {
  UnsavedDialog({
    super.key,
  }) : super(
          title: 'Внимание',
          messages: [
            'Несохранённые данные будут удалены.',
            'Вы уверены?',
          ],
          greenTitle: 'Да',
          redTitle: 'Отмена',
        );
}
