import 'dart:convert';
import 'dart:io';

import 'package:v04/firebase_config.dart';
import 'package:v04/managers/firestore_data_manager.dart';
import 'package:v04/models/hero_model.dart';
import 'package:test/test.dart';

void main() {
  group('Hero Management Tests', () {
    late List<HeroModel> mockHeroes;

    setUpAll(() async {
      // FirebaseConfig.initialize();
      // Load mock data before running tests
      final file = File('test/heroes-mock.json');
      final jsonString = await file.readAsString();
      final List<dynamic> jsonData = jsonDecode(jsonString);
      mockHeroes = jsonData.map((json) => HeroModel.fromJson(json)).toList();
    });

    test(
      'Search Heroes',
      () async {
        final manager = FirestoreDataManager();
        // Use mock data for testing
        manager.heroes = mockHeroes;

        final results = await manager.searchHeroes('batman');
        expect(results, isA<List<HeroModel>>());
        expect(results.length, 1);
        expect(results.first.name, 'Batman');
      },
      skip: 'Skipped because search is now done via Firestore queries',
    );

    test('List three strongest heroes', () {
      final manager = FirestoreDataManager();
      // Use mock data for testing
      manager.heroes = mockHeroes;

      final sortedHeroes = manager.sortHeroes('strength', 3);
      expect(sortedHeroes.length, lessThanOrEqualTo(3));

      // Compare strength values as integers (since they're stored as strings)
      final firstStrength =
          int.tryParse(sortedHeroes.first.powerstats?.strength ?? '0') ?? 0;
      final lastStrength =
          int.tryParse(sortedHeroes.last.powerstats?.strength ?? '0') ?? 0;
      expect(firstStrength, greaterThanOrEqualTo(lastStrength));
    });
  });

  // group('Integration Tests (Real Database)', () {
  //   // These tests would actually connect to Firestore

  //   late FirestoreHeroDataManager manager;

  //   setUpAll(() {
  //     FirebaseConfig.initialize();
  //   });

  //   setUp(() {
  //     manager = FirestoreHeroDataManager();
  //   });

  //   test(
  //     'should load heroes from actual Firestore',
  //     () async {
  //       // This would make a real HTTP call to Firestore
  //       await manager.loadHeroes();

  //       // Verify we can load data (assuming some test data exists)
  //       expect(manager.heroes, isA<List<HeroModel>>());
  //     },
  //     skip:
  //         'Integration test - requires Firestore setup (works locally but not in CI)',
  //   );

  //   test(
  //     'should save and retrieve hero from actual Firestore',
  //     () async {
  //       // Create test hero
  //       final testHero = HeroModel(
  //         'test-id',
  //         'Test Hero',
  //         null,
  //         null,
  //         null,
  //         null,
  //         null,
  //         null,
  //       );

  //       // Save to Firestore
  //       await manager.saveHero(testHero);

  //       // Clear local cache and reload
  //       manager.heroes.clear();
  //       await manager.refreshFromFirestore();

  //       // Verify it was saved and loaded
  //       final found = manager.heroes.where((h) => h.id == 'test-id').toList();
  //       expect(found.length, 1);
  //       expect(found.first.name, 'Test Hero');

  //       // Cleanup - delete test hero
  //       await manager.deleteHero('test-id');
  //     },
  //     skip:
  //         'Integration test - requires Firestore setup (works locally but not in CI)',
  //   );
  // });
}
