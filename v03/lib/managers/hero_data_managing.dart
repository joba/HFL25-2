import 'package:v03/models/hero_model.dart';

abstract class HeroDataManaging {
  String get filePath;
  List<HeroModel> heroes = [];

  Future<void> saveHero(HeroModel hero);
  Future<void> loadHeroes();
  HeroModel createHero({
    required String name,
    PowerStats? powerStats,
    Biography? biography,
    Appearance? appearance,
    Work? work,
    Connections? connections,
    Image? image,
  });
  HeroModel parseData(Map<String, dynamic> json);
}
