import 'dart:convert';
import 'dart:io';

import 'package:v04/managers/hero_data_manager.dart';
import 'package:v04/models/hero_model.dart';
import 'package:test/test.dart';

void main() {
  group('Hero Management Tests', () {
    late List<HeroModel> mockHeroes;

    setUpAll(() async {
      // Load mock data before running tests
      final file = File('test/heroes-mock.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      mockHeroes = jsonData.map((json) => HeroModel.fromJson(json)).toList();
    });

    test('Create new Hero', () {
      final manager = HeroDataManager();
      final newHero = manager.createHero(name: 'Test Hero');
      expect(newHero.name, 'Test Hero');
      expect(newHero.id, isNotNull);
    });

    test('Search Heroes', () async {
      final manager = HeroDataManager();
      manager.heroes = mockHeroes; // Use mock data directly
      final results = await manager.searchHeroes('batman');
      expect(results, isA<List<HeroModel>>());
    });

    test('List three strongest heroes', () {
      final manager = HeroDataManager();
      manager.heroes = mockHeroes; // Use mock data directly
      final sortedHeroes = manager.sortHeroes('strength', 3);
      expect(sortedHeroes.length, lessThanOrEqualTo(3));
      expect(
        sortedHeroes.first.powerStats?.strength,
        greaterThanOrEqualTo(sortedHeroes.last.powerStats?.strength ?? 0),
      );
    });
  });
}
