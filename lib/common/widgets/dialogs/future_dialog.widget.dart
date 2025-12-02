import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/dialogs/abstract_dialog.widget.dart';

/// Dialog with a FutureBuilder and choice between two actions.
/// Returns true when GreenBtn is clicked.
/// Returns false when RedBtn is clicked.
/// If title is null, there will be no button.
///
/// The [title] parameter is a dialog name.
/// The [futureText] parameter is the [Future] content (Strings) of the dialog.
/// The [greenTitle] parameter is the title of the green button.
/// The [redTitle] parameter is the title of the red button.
class FutureDialog extends AbstractDialog {
  FutureDialog({
    super.key,
    required super.title,
    required this.futureText,
    required super.greenTitle,
    required super.redTitle,
  }) : super(
          content: FutureBuilder(
            future: futureText,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                /// Data is received.
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: snapshot.data!.map(Text.new).toList(),
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
        );

  /// Content of the dialog.
  final Future<List<String>> futureText;
}
