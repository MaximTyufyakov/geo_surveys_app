import 'dart:async';
import 'dart:io';
import 'package:geo_surveys_app/features/task/models/task.model.dart';

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
    required this.file,
    required this.latitude,
    required this.longitude,
  }) : format = file?.path.split('.').last;

  /// Parent model.
  late TaskModel parent;

  /// The video identifier.
  final int? videoid;

  /// The video name.
  final String title;

  /// The video format.
  final String? format;

  /// Local video file.
  File? file;

  /// Start geographic latitude.
  double latitude;

  /// Start geographic longitude.
  double longitude;

  // /// Rename video file, delete from tmpDir and save in docDir.
  // Future<String> _saveFileLocal() async {
  //   /// Video created.
  //   if (file != null) {
  //     final Directory docDir = await getApplicationDocumentsDirectory();
  //     final Directory videosDir = Directory('${docDir.path}/videos');
  //     await videosDir.create(recursive: true);
  //     final String videoPath =
  //         '${videosDir.path}/${DateTime.now().millisecondsSinceEpoch}.$format';
  //     file = await file!.rename(videoPath);
  //     return ('Успешно.');
  //   } else {
  //     return Future.error('Ошибка. Файл не найден.');
  //   }
  // }

  /// Delete video file from local storage.
  Future<String> deleteFileLocal() async {
    /// File exists.
    if (file != null) {
      try {
        await file!.delete();
        file = null;
        return 'Успешно.';
      } catch (e) {
        return Future.error(
            'Ошибка при удалении видео из локального хранилища.');
      }
    } else {
      return 'Локальный файл уже удалён.';
    }
  }

  /// Delete file and video from task model.
  void deleteFromTask() async {
    await deleteFileLocal();
    parent.deleteVideo(this);
  }
}
