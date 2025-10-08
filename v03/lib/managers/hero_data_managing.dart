import 'package:v03/models/hero_model.dart';

abstract class HeroDataManaging {
  String get filePath;

  void saveHeroes(List<HeroModel> heroes);
  Future<List<HeroModel>> loadHeroes();
  HeroModel createHero(
    String name, [
    powerStats,
    biography,
    appearance,
    work,
    connections,
    image,
  ]);
}
