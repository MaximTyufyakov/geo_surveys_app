import 'package:postgres_dart/postgres_dart.dart';

/// A model with databases.
class DbModel {
  /// A geocontrol surveys Database.
  static final PostgresDb geosurveysDb = PostgresDb(
    host: '10.0.2.2',
    databaseName: 'geosurveys',
    username: 'postgres',
    password: 'admin',
    queryTimeoutInSeconds: 5,
    timeoutInSeconds: 5,
  );
}
