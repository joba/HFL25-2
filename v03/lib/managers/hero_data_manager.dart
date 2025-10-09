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

  @override
  String get filePath => 'heroes.json';

  @override
  HeroModel createHero(
    String name, [
    PowerStats? powerStats,
    Biography? biography,
    Appearance? appearance,
    Work? work,
    Connections? connections,
    Image? image,
  ]) {
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
  Future<void> saveHeroes(List<HeroModel> heroes) async {
    try {
      final file = File(filePath);
      final contents = jsonEncode(heroes);
      await file.writeAsString(contents);
    } catch (e) {
      print('Error saving heroes: $e');
    }
  }

  @override
  Future<List<HeroModel>> loadHeroes() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        return jsonData.map((json) => HeroModel.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading heroes: $e');
      return [];
    }
  }
}
