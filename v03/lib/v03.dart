import 'dart:io';

import 'package:v03/managers/hero_data_manager.dart';
import 'package:v03/models/hero_model.dart';
import 'package:v03/storage.dart';

final heroStorage = HeroStorage();
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

  var newHero = heroStorage.addHero(name, strength, gender, race, alignment);
  // var heroes = await loadHeroes();
  // await heroStorage.saveHeroes([...heroes, newHero]);

  print('Hero ${newHero['name']} successfully added!\n');
  showMainMenu();
}

void viewHeroes(String sortBy, [int? limit]) async {
  var heroes = await loadHeroes();
  if (heroes.isEmpty) {
    print('No heroes found.');
  } else {
    heroes = sortHeroes(sortBy, heroes);
    if (limit != null && limit > 0 && limit < heroes.length) {
      heroes = heroes.sublist(0, limit);
    }
    print('Heroes sorted by $sortBy:');
    printHeroList(heroes);
  }
  showFilterHeroesMenu();
}

void searchHeroes() async {
  // var heroes = await loadHeroes();
  // var searchTerm = getUserInput<String>(
  //   'Enter hero name to search: ',
  // ).toLowerCase();
  // var results = heroes
  //     .where(
  //       (hero) => (hero['name'] as String).toLowerCase().contains(searchTerm),
  //     )
  //     .toList();

  // if (results.isEmpty) {
  //   print('No heroes found matching "$searchTerm".');
  // } else {
  //   print('Search results:');
  //   printHeroList(results);
  // }
  showMainMenu();
}

List<HeroModel> sortHeroes(String sortBy, List<HeroModel> heroes) {
  // switch (sortBy) {
  //   case 'race':
  //     heroes.sort(
  //       (a, b) => a['appearance']['race'].compareTo(b['appearance']['race']),
  //     );
  //     break;
  //   case 'alignment':
  //     heroes.sort(
  //       (a, b) =>
  //           a['biography']['alignment'].compareTo(b['biography']['alignment']),
  //     );
  //     break;
  //   case 'gender':
  //     heroes.sort(
  //       (a, b) =>
  //           a['appearance']['gender'].compareTo(b['appearance']['gender']),
  //     );
  //     break;
  //   default:
  //     heroes.sort(
  //       (a, b) =>
  //           b['powerstats']['strength'].compareTo(a['powerstats']['strength']),
  //     );
  //     break;
  // }
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
  return '${hero.id}: ${hero.name} (${hero.appearance.gender}, ${hero.appearance.race}), strength: ${hero.powerStats.strength}, alignment: ${hero.biography.alignment}';
}
