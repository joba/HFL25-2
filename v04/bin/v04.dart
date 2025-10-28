import 'package:v04/di/service_locator.dart';
import 'package:v04/firebase_config.dart';
import 'package:v04/v04.dart';

void main(List<String> arguments) {
  setupDependencies();
  FirebaseConfig.initialize();
  showMainMenu();
}
