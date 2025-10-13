import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:v03/managers/hero_data_managing.dart';
import 'package:v03/models/hero_model.dart';

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
  HeroModel parseData(Map<String, dynamic> json) {
    return HeroModel.fromJson(json);
  }
}
