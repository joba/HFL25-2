import 'dart:convert';
import 'dart:io';

import 'package:v04/firebase_config.dart';
import 'package:v04/managers/firestore_hero_data_manager.dart';
import 'package:v04/models/hero_model.dart';
import 'package:test/test.dart';

void main() {
  group('Hero Management Tests', () {
    late List<HeroModel> mockHeroes;

    setUpAll(() async {
      FirebaseConfig.initialize();
      // Load mock data before running tests
      final file = File('test/heroes-mock.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      mockHeroes = jsonData.map((json) => HeroModel.fromJson(json)).toList();
    });

    test('Search Heroes', () async {
      final manager = FirestoreHeroDataManager();
      final results = await manager.searchHeroes('batman');
      expect(results, isA<List<HeroModel>>());
    });

    test('List three strongest heroes', () {
      final manager = FirestoreHeroDataManager();
      final sortedHeroes = manager.sortHeroes('strength', 3);
      expect(sortedHeroes.length, lessThanOrEqualTo(3));
      expect(
        sortedHeroes.first.powerStats?.strength,
        greaterThanOrEqualTo(sortedHeroes.last.powerStats?.strength ?? 0),
      );
    });
  });
}
