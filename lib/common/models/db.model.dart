import 'package:postgres_dart/postgres_dart.dart';

/// A model with databases.
class DbModel {
  /// The geosurveys database.
  static final PostgresDb geosurveysDb = PostgresDb(
    host: '10.0.2.2',
    // host: '192.168.237.180',
    // port: 5432,
    databaseName: 'geosurveys',
    username: 'postgres',
    password: 'admin',
    // queryTimeoutInSeconds: 5,
    // timeoutInSeconds: 5,
  );
}
