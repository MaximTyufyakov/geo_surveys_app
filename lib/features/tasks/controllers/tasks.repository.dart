import 'package:dio/dio.dart';
import 'package:geo_surveys_app/common/api.dart';
import 'package:geo_surveys_app/features/tasks/models/base_task.model.dart';

/// A repository of /tasks endpoints.
class TasksRepository {
  /// Retrieves all tasks from api.
  ///
  /// Returns a [Future] that completes when the response is successful.
  /// Throws a [Future.error] with [String] message if database fails.
  Future<List<BaseTaskModel>> get() async {
    try {
      // Api response.
      final Response<Map<String, dynamic>> response = await dio.get(
        '/tasks/all',
        options: Options(
          validateStatus: (status) => status == 200 || status == 403,
        ),
      );

      switch (response.statusCode) {
        // Ok.
        case 200:
          // Create list.
          return (response.data!['tasks'] as List<dynamic>)
              .map(
                (task) => BaseTaskModel.fromJson(task as Map<String, dynamic>),
              )
              .toList();

        // Forbidden
        case 403:
          return Future.error('Нет доступа.');

        default:
          return Future.error('Ошибка при обращении к серверу.');
      }
    } on DioException {
      return Future.error('Ошибка при обращении к серверу.');
    }
  }
}
