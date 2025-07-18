import 'dart:io';

import 'package:geo_surveys_app/common/models/db.model.dart';
import 'package:geo_surveys_app/features/task/models/point.model.dart';
import 'package:geo_surveys_app/features/task/models/report.model.dart';
import 'package:geo_surveys_app/features/task/models/video.model.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// The task model.
///
/// The [taskid] parameter is the task identifier.
/// The [title] parameter is the task name.
/// The [description] parameter is the text task description.
/// The [coordinates] parameter is the task geographic coordinates.
/// The [completed] parameter is the completed flag.
/// The [report] parameter is the report model.
/// The [points] parameter is the list of points that need to be completed.
/// The [saved] parameter is the saved flag.
class TaskModel {
  /// Private constructor.
  TaskModel._create({
    required this.taskid,
    required this.title,
    required this.description,
    required this.coordinates,
    required this.completed,
    required this.points,
    required this.saved,
    required this.report,
    required this.videos,
  });

  /// The task identifier.
  final int taskid;

  /// The task name.
  final String title;

  /// The text task description.
  final String description;

  /// The task geographic coordinates.
  final PgPoint coordinates;

  /// The completed flag.
  bool completed;

  /// The text that the user writes (optional).
  ReportModel report;

  /// The list of points that need to be completed.
  final List<PointModel> points;

  /// The list of videos.
  final List<VideoModel> videos;

  /// The list of deleted videos.
  final List<VideoModel> deletedVideos = [];

  /// The saved flag.
  bool saved;

  /// Public factory.
  /// Retrieves task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<TaskModel> create({required int taskid}) async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response = await DbModel.geosurveysDb.table('task').select(
        columns: [
          Column('taskid'),
          Column('title'),
          Column('description'),
          Column('coordinates'),
          Column('completed'),
          Column('report')
        ],
        where: Where(
          'taskid',
          WhereOperator.isEqual,
          taskid,
        ),
      );

      /// Call the private constructor
      TaskModel component = TaskModel._create(
        taskid: response.data[0][0] as int,
        title: response.data[0][1] as String,
        description: response.data[0][2] as String,
        coordinates: response.data[0][3] as PgPoint,
        completed: response.data[0][4] as bool,
        report: ReportModel(text: response.data[0][5] as String? ?? ''),
        saved: true,
        points: await _getPoints(taskid: taskid),
        videos: await _getVideos(taskid: taskid),
      ).._setParent();

      return component;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }

  /// Retrieves all points for task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<List<PointModel>> _getPoints({required int taskid}) async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response = await DbModel.geosurveysDb.table('point').select(
        columns: [
          Column('pointid'),
          Column('taskid'),
          Column('number'),
          Column('description'),
          Column('completed'),
        ],
        where: Where(
          'taskid',
          WhereOperator.isEqual,
          taskid,
        ),
        orderBy: OrderBy(
          'number',
          ascending: true,
        ),
      );
      List<PointModel> result = [];
      for (List<dynamic> d in response.data) {
        result.add(PointModel(
          pointid: d[0] as int,
          number: d[2] as int,
          description: d[3] as String,
          completed: d[4] as bool,
        ));
      }
      return result;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }

  /// Retrieves all videos for task from the database.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  static Future<List<VideoModel>> _getVideos({required int taskid}) async {
    try {
      if (DbModel.geosurveysDb.db.isClosed) {
        await DbModel.geosurveysDb.open();
      }
      DbResponse response = await DbModel.geosurveysDb.table('video').select(
        columns: [
          Column('videoid'),
          Column('taskid'),
          Column('title'),
          Column('url'),
          Column('path'),
        ],
        where: Where(
          'taskid',
          WhereOperator.isEqual,
          taskid,
        ),
        orderBy: OrderBy(
          'title',
          ascending: true,
        ),
      );
      List<VideoModel> result = [];
      for (List<dynamic> d in response.data) {
        result.add(VideoModel(
          videoid: d[0] as int,
          title: d[2] as String,
          url: d[3] as String?,
          file: (d[4] as String?) == null ? null : File(d[4] as String),
        ));
      }
      return result;
    } catch (e) {
      return Future.error('Ошибка при обращении к базе данных.');
    }
  }

  /// Set task as a parent for childs.
  void _setParent() {
    report.parent = this;
    for (PointModel point in points) {
      point.parent = this;
    }
    for (VideoModel video in videos) {
      video.parent = this;
    }
  }

  /// Marks the task as unsaved.
  /// Run when widgets change.
  void makeUnsaved() {
    saved = false;
  }

  /// Add new video in the list.
  void addVideo(VideoModel video) {
    video.parent = this;
    videos.add(video);
    makeUnsaved();
  }

  /// Delete a video from the main list and add in the deleted list.
  void deleteVideo(VideoModel video) {
    videos.remove(video);
    deletedVideos.add(video);
    makeUnsaved();
  }

  /// Save task progress (points, report, videos).
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails or
  /// no update.
  Future<String> save() async {
    final (bool completedCheck, String checkMessage) = _completedCheck();
    if (!saved) {
      completed = completedCheck;
      try {
        if (DbModel.geosurveysDb.db.isClosed) {
          await DbModel.geosurveysDb.open();
        }

        /// Task update.
        await DbModel.geosurveysDb.table('task').update(
          update: {
            'completed': completedCheck,
            'report': report.text,
          },
          where: Where(
            'taskid',
            WhereOperator.isEqual,
            taskid,
          ),
        );
      } catch (e) {
        return Future.error('Ошибка при обращении к базе данных.');
      }
      try {
        /// Point update.
        for (PointModel point in points) {
          await point.comletedUpdate();
        }

        /// Videos delete.
        for (VideoModel video in deletedVideos) {
          await video.delete();
        }

        /// Videos create (created only null-id videos).
        for (VideoModel video in videos) {
          await video.save();
        }
      } catch (e) {
        return Future.error(e.toString());
      }
      saved = true;
      return 'Успешно. $checkMessage';
    } else {
      return 'Нет изменений. $checkMessage';
    }
  }

  /// Check task completed (all points completed, add video).
  ///
  /// Returns a true if task completed else false and message.
  (bool, String) _completedCheck() {
    for (PointModel point in points) {
      if (!point.completed) {
        return (false, 'Для завершения задания окончите все пункты.');
      }
    }
    if (videos.isEmpty) {
      return (false, 'Для завершения задания прикрепите видео.');
    }
    return (true, 'Задание завершено.');
  }
}
