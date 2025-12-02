import 'package:geo_surveys_app/common/widgets/dialogs/text_dialog.widget.dart';

/// Dialog with unsaved message.
///
/// Returns true when GreenBtn is clicked.
/// Returns false when RedBtn is clicked.
class UnsavedDialog extends TextDialog {
  UnsavedDialog({
    super.key,
  }) : super(
          title: 'Внимание',
          text: [
            'Имеются несохранённые данные.',
            'Сохранить?',
          ],
          greenTitle: 'Да',
          redTitle: 'Нет',
        );
}
