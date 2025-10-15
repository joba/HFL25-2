import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:v04/managers/hero_data_managing.dart';
import 'package:v04/models/hero_model.dart';

class HeroDataManager implements HeroDataManaging {
  // Create a singleton instance
  HeroDataManager._internal();
  static final HeroDataManager _instance = HeroDataManager._internal();
  factory HeroDataManager() => _instance;

  bool _loaded = false;

  @override
  List<HeroModel> heroes = [];

  @override
  String get filePath => 'heroes.json';

  @override
  HeroModel createHero({
    required String name,
    PowerStats? powerStats,
    Biography? biography,
    Appearance? appearance,
    Work? work,
    Connections? connections,
    Image? image,
  }) {
    var id = Uuid().v4();
    final hero = HeroModel(
      id,
      name,
      powerStats,
      biography,
      appearance,
      work,
      connections,
      image,
    );
    return hero;
  }

  @override
  Future<void> saveHero(HeroModel hero) async {
    if (!_loaded) {
      await loadHeroes();
    }

    try {
      final file = File(filePath);
      final contents = jsonEncode([...heroes, hero]);
      await file.writeAsString(contents);
      _loaded = false;
    } catch (e) {
      print('Error saving heroes: $e');
    }
  }

  @override
  Future<void> loadHeroes() async {
    if (_loaded) return; // Prevent reloading if already loaded
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        heroes = jsonData.map((json) => HeroModel.fromJson(json)).toList();
        _loaded = true;
      }
    } catch (e) {
      print('Error loading heroes: $e');
    }
  }

  @override
  Future<List<HeroModel>> searchHeroes(String searchTerm) async {
    if (!_loaded) {
      await loadHeroes();
    }
    return heroes
        .where(
          (hero) => hero.name.toLowerCase().contains(searchTerm.toLowerCase()),
        )
        .toList();
  }

  @override
  HeroModel parseData(Map<String, dynamic> json) {
    return HeroModel.fromJson(json);
  }

  @override
  List<HeroModel> sortHeroes(String? sortBy, [int? limit]) {
    var sortedList = [...heroes]; // Create a copy to avoid mutating original

    switch (sortBy) {
      case 'race':
        sortedList.sort((a, b) {
          final raceA = a.appearance?.race ?? '';
          final raceB = b.appearance?.race ?? '';
          return raceA.compareTo(raceB);
        });
        break;
      case 'alignment':
        sortedList.sort((a, b) {
          final alignmentA = a.biography?.alignment ?? '';
          final alignmentB = b.biography?.alignment ?? '';
          return alignmentA.compareTo(alignmentB);
        });
        break;
      case 'gender':
        sortedList.sort((a, b) {
          final genderA = a.appearance?.gender ?? '';
          final genderB = b.appearance?.gender ?? '';
          return genderA.compareTo(genderB);
        });
        break;
      default: // strength
        sortedList.sort((a, b) {
          final strengthA = a.powerStats?.strength ?? 0;
          final strengthB = b.powerStats?.strength ?? 0;
          return strengthB.compareTo(strengthA);
        });
        break;
    }

    if (limit != null && limit > 0 && limit < sortedList.length) {
      sortedList = sortedList.sublist(0, limit);
    }
    return sortedList;
  }
}
