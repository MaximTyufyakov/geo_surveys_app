import 'package:flutter/material.dart';
import 'package:geo_surveys_app/common/widgets/loading.widget.dart';
import 'package:geo_surveys_app/common/widgets/message.widget.dart';
import 'package:geo_surveys_app/features/task/viewmodels/task.viewmodel.dart';
import 'package:geo_surveys_app/features/task/widgets/photos.widget.dart';
import 'package:geo_surveys_app/features/task/widgets/task.widget.dart';
import 'package:provider/provider.dart';

/// A page with BottomNavigationBar and task's widgets.
class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

/// A state of task page.
class _TaskPageState extends State<TaskPage> {
  /// The selected index of BottomNavigationBar.
  int _selectedIndex = 0;

  /// The widgets on the page.
  late List<Widget> _widgets;

  /// The arguments from the previous page.
  late Map<String, dynamic> _arguments;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    /// Decoding arguments.
    _arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map<String, dynamic>;

    return ChangeNotifierProvider<TaskViewModel>(
      create: (BuildContext context) => TaskViewModel(
        context: context,
        taskid: _arguments['taskid'] as int,
      ),
      child: Consumer<TaskViewModel>(
        builder: (context, provider, child) => Scaffold(
          appBar: AppBar(
            title: Text(
              'Задание',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            leading: BackButton(
              onPressed: () {
                provider.exit();
              },
            ),
            actions: [
              /// Page reload.
              IconButton(
                onPressed: () async {
                  provider.reloadPage();
                },
                icon: const Icon(Icons.replay_outlined),
              ),

              /// Save.
              IconButton(
                onPressed: () async {
                  await provider.save();
                },
                icon: const Icon(Icons.save),
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(8),
            child: FutureBuilder(
                future: provider.model,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    /// Data from the database is received.
                    if (snapshot.hasData) {
                      /// Initialization of widgets.
                      provider.reportController ??=
                          TextEditingController(text: snapshot.data!.report);

                      _widgets = <Widget>[
                        /// Points.
                        TaskWidget(
                          task: snapshot.data!,
                        ),

                        /// Report.
                        TextField(
                          decoration: const InputDecoration(
                            hintText:
                                'Здесь можно написать отчёт о выполненной работе.',
                          ),
                          controller: provider.reportController,
                          onChanged: (action) {
                            provider.makeUnsaved();
                          },
                          maxLines: 100,
                        ),

                        /// Photos.
                        const PhotosWidget(),
                      ];

                      return _widgets.elementAt(_selectedIndex);

                      /// Error.
                    } else if (snapshot.hasError) {
                      return MessageWidget(mes: snapshot.error.toString());
                    }
                  }

                  /// Loading.
                  return const LoadingWidget();
                }),
          ),
          bottomNavigationBar: BottomNavigationBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                  icon: Icon(Icons.task_alt), label: 'Задание'),
              BottomNavigationBarItem(
                icon: Icon(Icons.edit_document),
                label: 'Отчёт',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.photo_library_outlined),
                label: 'Фотографии',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
