import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/tasks/models/point.model.dart';
import 'package:geo_surveys_app/features/tasks/models/task.model.dart';
import 'package:geo_surveys_app/features/tasks/widgets/point.widget.dart';

/// A widget with task information.
/// The [task] parameter is a model with task information.
class TaskWidget extends StatelessWidget {
  const TaskWidget({super.key, required this.task});

  /// Model with task information.
  final Task task;

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SelectableText(
              task.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Описание',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(
              color: Theme.of(context).primaryColorDark,
            ),
            SelectableText(
              task.description,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(
              height: 20,
            ),
            Text(
              'Ход работы',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Divider(
              color: Theme.of(context).primaryColorDark,
            ),
            FutureBuilder(
              future: task.points,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  /// Data from the database is received.
                  if (snapshot.hasData) {
                    List<Widget> pointsCards = [];
                    for (Point point in snapshot.data!) {
                      pointsCards.add(
                        PointWidget(
                          point: point,
                        ),
                      );
                    }
                    return Column(
                      children: pointsCards,
                    );

                    /// Error.
                  } else if (snapshot.hasError) {
                    return MessageWidget(mes: snapshot.error.toString());
                  }
                }

                /// Loading.
                return const LoadingWidget();
              },
            ),
          ],
        ),
      );
}
