import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres_dart/postgres_dart.dart';

/// The model with all databases in system.
class Databases {
  /// Main database.
  static PostgresDb geosurveys = PostgresDb(
    host: dotenv.env['DB_HOST'] as String,
    databaseName: dotenv.env['DB_NAME'] as String,
    username: dotenv.env['DB_USERNAME'] as String,
    password: dotenv.env['DB_PASSWORD'] as String,
    queryTimeoutInSeconds: int.parse(dotenv.env['DB_QUERY_TIMEOUT'] as String),
    timeoutInSeconds: int.parse(dotenv.env['DB_TIMEOUT'] as String),
  );
}
