import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:aws_s3_api/s3-2006-03-01.dart';
import 'package:geo_surveys_app/features/task/models/task.model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:postgres/postgres.dart';
import 'package:uuid/uuid.dart';

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
  }) : _format = file?.path.split('.').last;

  /// Parent model.
  late TaskModel parent;

  /// The video identifier.
  int? videoid;

  /// The video name.
  String title;

  /// The video format.
  final String? _format;

  /// The video url in cloud.
  String? url;

  /// Local video file.
  File? file;

  /// Save video info in database and file in storage.
  Future<String> save() async {
    /// If did not save later.
    if (videoid == null) {
      try {
        await _saveFileCloud();
        await _deleteFileLocal();
        await _saveInDB();
        return 'Успешно.';
      } catch (e) {
        return Future.error(e.toString());
      }
    } else {
      return 'Видео уже сохранено.';
    }
  }

  /// Save video file in cloud storage.
  Future<String> _saveFileCloud() async {
    /// Not saved in cloud.
    if (url == null) {
      /// File exists.
      if (file != null) {
        try {
          // URL generated.
          url = '${const Uuid().v4()}.$_format';

          // String b64 = base64Encode(await file!.readAsBytes());

          // Loading file.
          await _s3.putObject(
            bucket: dotenv.env['S3_BUCKET_NAME'] as String,
            key: url!,
            body: await file!.readAsBytes(),
            contentType: 'video/$_format',
          );

          return ('Успешно.');
        } catch (e) {
          url = null;
          return Future.error('Ошибка при загрузке видео в облако.');
        }
      } else {
        return Future.error('Ошибка. Файл не найден.');
      }
    } else {
      return 'Файл уже сохранён в облаке.';
    }
  }

  /// Rename video file, delete from tmpDir and save in docDir.
  Future<String> _saveFileLocal() async {
    /// Video created.
    if (file != null) {
      final Directory docDir = await getApplicationDocumentsDirectory();
      final Directory videosDir = Directory('${docDir.path}/videos');
      await videosDir.create(recursive: true);
      final String videoPath =
          '${videosDir.path}/${DateTime.now().millisecondsSinceEpoch}.$_format';
      file = await file!.rename(videoPath);
      return ('Успешно.');
    } else {
      return Future.error('Ошибка. Файл не найден.');
    }
  }

  /// Save video info in database.
  Future<String> _saveInDB() async {
    try {
      final conn = await Connection.open(
        GeosurveysDB.endpoint,
        settings: GeosurveysDB.settings,
      );

      Result result = await conn.execute(
        Sql.named(
          ''' INSERT INTO video (task_id, title, url)
              VALUES (@taskid, @title, @url)
              RETURNING (video_id);''',
        ),
        parameters: {
          'taskid': parent.taskid,
          'title': title,
          'url': url,
        },
      );

      await conn.close();

      videoid = result[0][0] as int?;

      return 'Успешно.';
    } on SocketException {
      return Future.error('Ошибка: нет соеденинения с базой данных.');
    } on TimeoutException {
      return Future.error(
          'Ошибка: время ожидания подключения к базе данных истекло.');
    } on TypeError {
      return Future.error(
          'Ошибка: из базы данных получен неправильный тип данных.');
    } catch (e) {
      if (e is ServerException) {
        log(e.message);
        return Future.error('Ошибка: запрос к базе данных отклонён.');
      }
      return Future.error('Неизвестная ошибка при обращении к базе данных.');
    }
  }

  /// Delete video info from database and file from storage.
  Future<String> delete() async {
    try {
      await _deleteFileCloud();
      await _deleteFromDB();
      return 'Успешно.';
    } catch (e) {
      return Future.error(e.toString());
    }
  }

  /// Delete video file from cloud storage.
  Future<String> _deleteFileCloud() async {
    /// The file is saved in cloud.
    if (url != null) {
      try {
        // Delete file.
        await _s3.deleteObject(
          bucket: dotenv.env['S3_BUCKET_NAME'] as String,
          key: url!,
        );

        url = null;
        return ('Успешно.');
      } catch (e) {
        return Future.error('Ошибка при удалении видео из облака.');
      }
    } else {
      return Future.error('Ошибка. Файл не сохранён в облаке.');
    }
  }

  /// Delete video file from local storage.
  Future<String> _deleteFileLocal() async {
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

  /// Delete video info from db.
  Future<String> _deleteFromDB() async {
    /// If saved in db.
    if (videoid != null) {
      try {
        final conn = await Connection.open(
          GeosurveysDB.endpoint,
          settings: GeosurveysDB.settings,
        );

        await conn.execute(
          Sql.named(
            ''' DELETE FROM video
                WHERE video_id = @videoid;''',
          ),
          parameters: {
            'videoid': videoid,
          },
        );

        await conn.close();

        return 'Успешно.';
      } on SocketException {
        return Future.error('Ошибка: нет соеденинения с базой данных.');
      } on TimeoutException {
        return Future.error(
            'Ошибка: время ожидания подключения к базе данных истекло.');
      } catch (e) {
        if (e is ServerException) {
          log(e.message);
          return Future.error('Ошибка: запрос к базе данных отклонён.');
        }
        return Future.error('Неизвестная ошибка при обращении к базе данных.');
      }
    } else {
      return 'Видео уже удалено из базы данных.';
    }
  }

  /// Delete this video from task model.
  void deleteFromTask() {
    parent.deleteVideo(this);
  }
}
