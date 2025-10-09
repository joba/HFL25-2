import 'package:v03/models/hero_model.dart';

abstract class HeroDataManaging {
  String get filePath;

  void saveHeroes(List<HeroModel> heroes);
  Future<List<HeroModel>> loadHeroes();
  HeroModel createHero(
    String name, [
    PowerStats? powerStats,
    Biography? biography,
    Appearance? appearance,
    Work? work,
    Connections? connections,
    Image? image,
  ]);
}
