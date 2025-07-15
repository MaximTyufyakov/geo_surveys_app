import 'dart:io';

import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:path_provider/path_provider.dart';

/// The video model.
///
/// The [parent] parameter is the task.
/// The [videoid] parameter is the video identifier.
/// The [title] parameter is the video name.
/// The [url] parameter is the video url in cloud.
class VideoModel {
  VideoModel({
    required this.videoid,
    required this.title,
    required this.url,
    required this.file,
  });

  /// Parent model.
  late TaskModel parent;

  /// The video identifier.
  int? videoid;

  /// The video name.
  String title;

  /// The video url in cloud.
  String? url;

  /// Local video file.
  File? file;

  /// Save video info in database and file in storage.
  Future<String> save() async {
    /// If did not save later.
    if (videoid == null) {
      await _saveFileLocal();

      try {
        if (DbModel.geosurveysDb.db.isClosed) {
          await DbModel.geosurveysDb.open();
        }
        await DbModel.geosurveysDb.table('video').insert(
          columns: [
            'taskid',
            'title',
            'url',
            'path',
          ],
          values: [
            parent.taskid,
            title,
            url,
            file?.path,
          ],
        );
        return 'Успешно.';
      } catch (e) {
        return Future.error('Ошибка при обращении к базе данных.');
      }
    } else {
      return 'Файл уже сохранён.';
    }
  }

  /// Save video file in local storage.
  Future<String> _saveFileLocal() async {
    if (file != null) {
      final Directory docDir = await getApplicationDocumentsDirectory();
      final Directory videosDir = Directory('${docDir.path}/videos');
      await videosDir.create(recursive: true);
      final String videoPath =
          '${videosDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';
      file = await file!.rename(videoPath);
      return ('Успешно.');
    } else {
      return Future.error('Ошибка. Файл не найден.');
    }
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void makeUnsaved() {
    parent.makeUnsaved();
  }

  // // Save video file in cloud storage.
  // Future<String> _saveFileCloud() async {}

  // // Delete video info from database and file from storage.
  // Future<String> delete() async {}

  // // Delete video file from local storage.
  // Future<String> _deleteFileLocal() async {}

  // // Delete video file from cloud storage.
  // Future<String> _deleteFileCloud() async {}
}
