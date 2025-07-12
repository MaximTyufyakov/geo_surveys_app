import 'package:postgres_dart/postgres_dart.dart';

/// A model with databases.
class DbModel {
  /// The geosurveys database.
  static final PostgresDb geosurveysDb = PostgresDb(
    // host: '10.0.2.2', // Only for emulator.
    host: '192.168.141.180', // For closed network (real device or emulator).
    databaseName: 'geosurveys',
    username: 'postgres',
    password: 'admin',
    queryTimeoutInSeconds: 10,
    timeoutInSeconds: 10,
  );
}
