import 'package:get_it/get_it.dart';
import 'package:v04/managers/firestore_data_manager.dart';
import 'package:v04/managers/hero_data_managing.dart';

final GetIt getIt = GetIt.instance;

void setupDependencies() {
  getIt.registerSingleton<HeroDataManaging>(FirestoreDataManager());
}

HeroDataManaging get heroDataManager => getIt<HeroDataManaging>();
