import 'package:flutter/material.dart';

/// Dialog with a FutureBuilder and choice between two actions.
/// Returns true when GreenBtn is clicked.
/// Returns false when RedBtn is clicked.
/// If title is null, there will be no button.
///
/// The [title] parameter is a dialog name.
/// The [messages] parameter is the [Future] content of the dialog.
/// The [greenTitle] parameter is the title of the green button.
/// The [redTitle] parameter is the title of the red button.
///
/// Throws an ArgumentError when both titles is null.
class FutureDialog extends StatelessWidget {
  FutureDialog({
    super.key,
    required this.title,
    required this.messages,
    required this.greenTitle,
    required this.redTitle,
  });

  /// Dialog name.
  final String title;

  /// Content of the dialog.
  final Future<List<String>> messages;

  /// Title of the green button.
  final String? greenTitle;

  /// Title of the red button.
  final String? redTitle;

  final List<FilledButton> buttons = [];

  @override
  Widget build(BuildContext context) {
    if (greenTitle == null && redTitle == null) {
      throw ArgumentError(
        'redTitle and greenTitle cannot be null at the same time',
        'ChoiceDialog Error',
      );
    }
    if (greenTitle != null) {
      buttons.add(
        FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.lightGreen[200],
            ),
          ),
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(greenTitle!),
        ),
      );
    }
    if (redTitle != null) {
      buttons.add(
        FilledButton(
          style: ButtonStyle(
            backgroundColor: WidgetStateProperty.all(
              Colors.red[200],
            ),
          ),
          onPressed: () {
            Navigator.pop(context, false);
          },
          child: Text(redTitle!),
        ),
      );
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder(
              future: messages,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  /// Data is received.
                  if (snapshot.hasData) {
                    List<Widget> texts = [];
                    for (String text in snapshot.data!) {
                      texts.add(Text(text));
                    }
                    return Column(
                      children: texts,
                    );

                    /// Error.
                  } else if (snapshot.hasError) {
                    return Text(
                      snapshot.error.toString(),
                    );
                  }
                }

                /// Loading.
                return Center(
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                );
              },
            ),
          ],
        ),
      ),
      actions: buttons,
    );
  }
}
