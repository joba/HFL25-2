import 'package:v04/models/hero_model.dart';

abstract class HeroDataManaging {
  List<HeroModel> heroes = [];

  Future<void> saveHero(HeroModel hero);
  Future<void> loadHeroes();
  HeroModel parseData(Map<String, dynamic> json);
  Future<List<HeroModel>> searchHeroes(String searchTerm);
  List<HeroModel> sortHeroes(String? sortBy, [int? limit]);
}
