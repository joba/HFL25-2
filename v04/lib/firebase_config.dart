import 'package:dotenv/dotenv.dart';

class FirebaseConfig {
  static late String projectId;
  static late String apiKey;
  static late String databaseUrl;

  static void initialize() {
    var env = DotEnv()..load();

    projectId = env['FIREBASE_PROJECT_ID'] ?? '';
    apiKey = env['FIREBASE_API_KEY'] ?? '';
    databaseUrl =
        'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents';

    if (projectId.isEmpty || apiKey.isEmpty) {
      throw Exception('Firebase configuration missing. Check your .env file.');
    }
  }
}
