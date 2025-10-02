import 'dart:convert';
import 'dart:io';

import 'package:v02/hero.dart';

class HeroStorage {
  final String filePath = 'heroes.json';

  Future<List<Hero>> loadHeroes() async {
    try {
      final file = File(filePath);
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        return jsonData.map((json) => Hero.fromJson(json)).toList();
      } else {
        return [];
      }
    } catch (e) {
      print('Error loading heroes: $e');
      return [];
    }
  }

  // Write heroes to a local JSON file
  Future<void> saveHeroes(List<Hero> heroes) async {
    try {
      final file = File(filePath);
      final contents = jsonEncode(heroes.map((hero) => hero.toJson()).toList());
      await file.writeAsString(contents);
    } catch (e) {
      print('Error saving heroes: $e');
    }
  }
}
