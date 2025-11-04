import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:postgres/postgres.dart';

/// Main database.
class GeosurveysDB {
  static Endpoint endpoint = Endpoint(
    host: dotenv.env['DB_HOST'] as String,
    database: dotenv.env['DB_NAME'] as String,
    username: dotenv.env['DB_USERNAME'] as String,
    password: dotenv.env['DB_PASSWORD'] as String,
  );

  static ConnectionSettings settings = ConnectionSettings(
      queryTimeout: Duration(
        seconds: int.parse(dotenv.env['DB_QUERY_TIMEOUT'] as String),
      ),
      connectTimeout: Duration(
        seconds: int.parse(dotenv.env['DB_CONNECT_TIMEOUT'] as String),
      ),
      // Change in release.
      sslMode: SslMode.disable);
}
