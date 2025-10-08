import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';
import 'package:v03/managers/hero_data_managing.dart';
import 'package:v03/models/hero_model.dart';

class HeroDataManager implements HeroDataManaging {
  @override
  String get filePath => 'heroes.json';

  @override
  HeroModel createHero(
    String name, [
    powerStats,
    biography,
    appearance,
    work,
    connections,
    image,
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
        return List<HeroModel>.from(jsonData);
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading heroes: $e');
      return [];
    }
  }
}
