import 'package:v03/v03.dart';
import 'package:test/test.dart';

void main() {
  group('Hero Management Tests', () {
    test('Add Hero Test', () {
      final initialCount = heroStorage.heroes.length;
      heroStorage.addHero('TestHero', 80, 'Male', 'Human', 'Good');
      expect(heroStorage.heroes.length, initialCount + 1);
      expect(heroStorage.heroes.last['name'], 'TestHero');
    });
    test('View Heroes Test', () async {
      final heroes = await heroStorage.loadHeroes();
      expect(heroes, isA<List<Map<String, dynamic>>>());
    });
    test('Search Heroes Test', () async {
      final heroes = await heroStorage.loadHeroes();
      final searchTerm = 'TestHero'.toLowerCase();
      final results = heroes
          .where(
            (hero) =>
                (hero['name'] as String).toLowerCase().contains(searchTerm),
          )
          .toList();
      expect(results, isA<List<Map<String, dynamic>>>());
    });
  });
}
