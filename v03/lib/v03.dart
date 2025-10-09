import 'dart:io';

import 'package:v03/managers/hero_data_manager.dart';
import 'package:v03/models/hero_model.dart';

final heroDataManager = HeroDataManager();

void showMainMenu() {
  print('\nWelcome, make your choice below:');
  print('1. Add Hero');
  print('2. View Heroes');
  print('3. Search Heroes');
  print('4. Exit');
  var menuItem = stdin.readLineSync();

  print('\nYou selected: $menuItem\n');
  switch (menuItem) {
    case '1':
      addNewHero();
      break;
    case '2':
      viewHeroes('strength');
      break;
    case '3':
      searchHeroes();
      break;
    case '4':
      print('Goodbye for now!');
      exit(0);
    default:
      print('Invalid option. Please try again.\n');
      showMainMenu();
  }
}

void showFilterHeroesMenu() {
  print('\nFilter and sort heroes:');
  print('1. Show top 3 strongest heroes');
  print('2. Sort heroes by race');
  print('3. Sort heroes by alignment');
  print('4. Sort heroes by gender');
  print('5. Back to main menu');
  var filterOption = stdin.readLineSync();

  switch (filterOption) {
    case '1':
      viewHeroes('strength', 3);
      break;
    case '2':
      viewHeroes('race');
      break;
    case '3':
      viewHeroes('alignment');
      break;
    case '4':
      viewHeroes('gender');
      break;
    case '5':
      showMainMenu();
      break;
    default:
      print('Invalid option. Please try again.');
      showFilterHeroesMenu();
  }
}

void addNewHero() async {
  var name = getUserInput<String>('Enter hero name: ');
  var strength = getUserInput<int>('Enter hero strength (number): ');
  var gender = getUserInput<String>('Enter hero gender: ');
  var race = getUserInput<String>('Enter hero race: ');
  var alignment = getUserInput<String>('Enter hero alignment (good, evil): ');

  // TODO: not pretty, use named parameters instead(?). Make more options optional?
  var newHero = heroDataManager.createHero(
    name,
    PowerStats(0, strength, 0, 0, 0, 0),
    Biography('', '', [], '', '', '', alignment),
    Appearance(gender, race, [], [], '', ''),
  );
  var heroes = await loadHeroes();
  await heroDataManager.saveHeroes([...heroes, newHero]);

  print('Hero ${newHero.name} successfully added!\n');
  showMainMenu();
}

void viewHeroes(String sortBy, [int? limit]) async {
  var heroes = await loadHeroes();
  if (heroes.isEmpty) {
    print('No heroes found.');
    showMainMenu();
  } else {
    heroes = sortHeroes(sortBy, heroes);
    if (limit != null && limit > 0 && limit < heroes.length) {
      heroes = heroes.sublist(0, limit);
    }
    print('Heroes sorted by $sortBy:');
    printHeroList(heroes);
    showFilterHeroesMenu();
  }
}

void searchHeroes() async {
  var heroes = await loadHeroes();
  var searchTerm = getUserInput<String>(
    'Enter hero name to search: ',
  ).toLowerCase();
  var results = heroes
      .where((hero) => hero.name.toLowerCase().contains(searchTerm))
      .toList();

  if (results.isEmpty) {
    print('No heroes found matching "$searchTerm".');
  } else {
    print('Search results:');
    printHeroList(results);
  }
  showMainMenu();
}

List<HeroModel> sortHeroes(String sortBy, List<HeroModel> heroes) {
  switch (sortBy) {
    case 'race':
      heroes.sort((a, b) {
        final raceA = a.appearance?.race ?? '';
        final raceB = b.appearance?.race ?? '';
        return raceA.compareTo(raceB);
      });
      break;
    case 'alignment':
      heroes.sort((a, b) {
        final alignmentA = a.biography?.alignment ?? '';
        final alignmentB = b.biography?.alignment ?? '';
        return alignmentA.compareTo(alignmentB);
      });
      break;
    case 'gender':
      heroes.sort((a, b) {
        final genderA = a.appearance?.gender ?? '';
        final genderB = b.appearance?.gender ?? '';
        return genderA.compareTo(genderB);
      });
      break;
    default:
      heroes.sort((a, b) {
        final strengthA = a.powerStats?.strength ?? 0;
        final strengthB = b.powerStats?.strength ?? 0;
        return strengthB.compareTo(strengthA);
      });
      break;
  }
  return heroes;
}

Future<List<HeroModel>> loadHeroes() async {
  return await heroDataManager.loadHeroes();
}

T getUserInput<T>(String prompt) {
  stdout.write(prompt);
  var input = stdin.readLineSync();
  if (T == int && input != null) {
    return int.parse(input) as T;
  } else {
    return input as T;
  }
}

void printHeroList(List<HeroModel> heroes) {
  for (var hero in heroes) {
    print(toString(hero));
  }
}

String toString(HeroModel hero) {
  return '${hero.id}: ${hero.name} (${hero.appearance?.gender}, ${hero.appearance?.race}), strength: ${hero.powerStats?.strength}, alignment: ${hero.biography?.alignment}';
}
