import 'dart:convert';
import 'dart:io';
import 'package:v04/managers/data_manager.dart';
import 'package:v04/managers/hero_data_managing.dart';
import 'package:v04/models/hero_model.dart';

class MockDataManager implements HeroDataManaging {
  @override
  List<HeroModel> heroes = [];

  // Use real DataManager for business logic
  final DataManager _dataManager = DataManager();

  @override
  Future<void> deleteHero(String heroId) async {
    // Mock delete - remove from list
    heroes.removeWhere((hero) => hero.id == heroId);
  }

  @override
  Future<List<HeroModel>> searchHeroes(String searchTerm) async {
    // Search through the loaded heroes
    if (heroes.isEmpty) {
      await loadHeroes();
    }

    return heroes
        .where(
          (hero) => hero.name.toLowerCase().contains(searchTerm.toLowerCase()),
        )
        .toList();
  }

  @override
  Future<void> loadHeroes() async {
    // Load mock data from JSON file
    try {
      final file = File('test/mocks/heroes-mock.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      heroes = jsonData.map((json) => HeroModel.fromJson(json)).toList();
    } catch (e) {
      print('Error loading mock heroes: $e');
      heroes = []; // Empty list on error
    }
  }

  @override
  HeroModel parseData(Map<String, dynamic> json) {
    // Use real parsing logic
    return HeroModel.fromJson(json);
  }

  @override
  Future<String> saveHero(HeroModel hero) async {
    // Mock save - check for duplicates and add to list
    if (heroes.any((h) => h.id == hero.id)) {
      return 'duplicatedEntry';
    }
    heroes.add(hero);
    return 'success';
  }

  @override
  List<HeroModel> filterHeroes(String? filterBy, String? filterValue) {
    // Use real business logic for filtering
    return _dataManager.filterHeroes(heroes, filterBy, filterValue);
  }

  @override
  List<HeroModel> sortHeroes(String? sortBy, [int? limit]) {
    // Use real business logic for sorting
    return _dataManager.sortHeroes(heroes, sortBy, limit);
  }
}
