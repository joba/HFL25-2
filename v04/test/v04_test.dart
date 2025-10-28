import 'package:v04/di/service_locator.dart';
import 'package:v04/managers/hero_data_managing.dart';
import 'package:v04/models/hero_model.dart';
import 'package:test/test.dart';

import 'mocks/mock_managers.dart';

void main() {
  group('Hero Management Tests', () {
    late MockDataManager mockDataManager;

    setUp(() async {
      // Reset the DI container before each test
      await getIt.reset();

      // Create a shared mock instance
      mockDataManager = MockDataManager();

      // Register the mock manually since we can't import it in service_locator
      getIt.registerSingleton<HeroDataManaging>(mockDataManager);

      // Wait for any async initialization to complete
      await Future.delayed(Duration(milliseconds: 10));
    });

    tearDown(() async {
      // Clean up after each test
      await getIt.reset();
    });

    test('Should load data from JSON file', () async {
      await mockDataManager.loadHeroes();
      expect(mockDataManager.heroes.isNotEmpty, true);
      print('Loaded ${mockDataManager.heroes.length} heroes from mock data');
    });

    test('Search Heroes', () async {
      final results = await mockDataManager.searchHeroes('batman');
      expect(results, isA<List<HeroModel>>());
      expect(results.length, 1);
      expect(results.first.name, 'Batman');
    });

    test('Search should be case insensitive', () async {
      final resultsLowercase = await mockDataManager.searchHeroes('batman');
      final resultsUppercase = await mockDataManager.searchHeroes('BATMAN');
      final resultsMixed = await mockDataManager.searchHeroes('BaTmAn');

      expect(resultsLowercase.length, equals(resultsUppercase.length));
      expect(resultsLowercase.length, equals(resultsMixed.length));
    });

    test('List three strongest heroes', () async {
      // Load heroes first
      await mockDataManager.loadHeroes();

      final sortedHeroes = mockDataManager.sortHeroes('strength', 3);
      expect(sortedHeroes.length, lessThanOrEqualTo(3));

      // Compare strength values as integers (since they're stored as strings)
      final firstStrength =
          int.tryParse(sortedHeroes.first.powerstats?.strength ?? '0') ?? 0;
      final lastStrength =
          int.tryParse(sortedHeroes.last.powerstats?.strength ?? '0') ?? 0;
      expect(firstStrength, greaterThanOrEqualTo(lastStrength));
    });

    test('Sort by strength (default) should work correctly', () {
      final sorted = mockDataManager.sortHeroes('strength');

      // Verify descending order
      for (int i = 0; i < sorted.length - 1; i++) {
        final currentStrength =
            int.tryParse(sorted[i].powerstats?.strength ?? '0') ?? 0;
        final nextStrength =
            int.tryParse(sorted[i + 1].powerstats?.strength ?? '0') ?? 0;
        expect(currentStrength, greaterThanOrEqualTo(nextStrength));
      }
    });

    test('Sort with limit should return correct number of results', () {
      final sorted = mockDataManager.sortHeroes('strength', 2);
      expect(sorted.length, lessThanOrEqualTo(2));
      expect(sorted.length, lessThanOrEqualTo(mockDataManager.heroes.length));
    });

    test('Filter by alignment should work correctly', () {
      final goodHeroes = mockDataManager.filterHeroes('alignment', 'good');

      for (final hero in goodHeroes) {
        expect(hero.biography?.alignment?.toLowerCase(), equals('good'));
      }
    });

    test('Save hero should work with mock data', () async {
      await mockDataManager.loadHeroes();
      final initialCount = mockDataManager.heroes.length;

      final newHero = HeroModel.fromJson({
        'id': 'test-999',
        'name': 'Test Hero',
        'powerstats': {'strength': '100'},
        'biography': {'alignment': 'good'},
      });

      final result = await mockDataManager.saveHero(newHero);
      expect(result, equals('success'));
      expect(mockDataManager.heroes.length, equals(initialCount + 1));
    });

    test('Should prevent duplicate hero saves', () async {
      await mockDataManager.loadHeroes();
      final existingHero = mockDataManager.heroes.first;

      final result = await mockDataManager.saveHero(existingHero);
      expect(result, equals('duplicatedEntry'));
    });

    test('Delete hero should remove from mock data', () async {
      await mockDataManager.loadHeroes();
      final initialCount = mockDataManager.heroes.length;
      final heroToDelete = mockDataManager.heroes.first;

      await mockDataManager.deleteHero(heroToDelete.id);
      expect(mockDataManager.heroes.length, equals(initialCount - 1));
      expect(mockDataManager.heroes.any((h) => h.id == heroToDelete.id), false);
    });
  });
}
