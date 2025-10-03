import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

class HeroStorage {
  final List<Map<String, dynamic>> heroes = [];

  final String filePath = 'heroes.json';

  Future<List<Map<String, dynamic>>> loadHeroes() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        return List<Map<String, dynamic>>.from(jsonData);
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading heroes: $e');
      return [];
    }
  }

  // Write heroes to a local JSON file
  Future<void> saveHeroes(List<Map<String, dynamic>> heroes) async {
    try {
      final file = File(filePath);
      final contents = jsonEncode(heroes);
      await file.writeAsString(contents);
    } catch (e) {
      print('Error saving heroes: $e');
    }
  }

  Map<String, dynamic> addHero(
    String name,
    int strength,
    String gender,
    String race,
    String alignment,
  ) {
    Map<String, dynamic> hero = {
      'id': Uuid().v4(),
      'name': name,
      'powerstats': {"strength": strength},
      'appearance': {"gender": gender, "race": race},
      'biography': {"alignment": alignment},
    };
    heroes.add(hero);
    return hero;
  }
}
