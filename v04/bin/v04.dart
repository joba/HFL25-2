import 'package:v04/cli/cli_controller.dart';
import 'package:v04/di/service_locator.dart';
import 'package:v04/firebase_config.dart';

void main(List<String> arguments) {
  setupDependencies();
  FirebaseConfig.initialize();
  start();
}
