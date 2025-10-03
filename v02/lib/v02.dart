import 'dart:io';

import 'package:v02/storage.dart';

final heroStorage = HeroStorage();

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
      viewHeroes();
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

void addNewHero() async {
  var name = getUserInput<String>('Enter hero name: ');
  var strength = getUserInput<int>('Enter hero strength (number): ');
  var gender = getUserInput<String>('Enter hero gender: ');
  var race = getUserInput<String>('Enter hero race: ');
  var alignment = getUserInput<String>('Enter hero alignment (good, evil): ');

  var newHero = heroStorage.addHero(name, strength, gender, race, alignment);
  var heroes = await loadHeroes();
  await heroStorage.saveHeroes([...heroes, newHero]);

  print('Hero ${newHero['name']} successfully added!\n');
  showMainMenu();
}

void viewHeroes() async {
  var heroes = await loadHeroes();
  if (heroes.isEmpty) {
    print('No heroes found.');
  } else {
    print('Heroes:');
    heroes.sort(
      (a, b) =>
          b['powerstats']['strength'].compareTo(a['powerstats']['strength']),
    );
    printHeroList(heroes);
  }
  showMainMenu();
}

void searchHeroes() async {
  var heroes = await loadHeroes();
  var searchTerm = getUserInput<String>(
    'Enter hero name to search: ',
  ).toLowerCase();
  var results = heroes
      .where(
        (hero) => (hero['name'] as String).toLowerCase().contains(searchTerm),
      )
      .toList();

  if (results.isEmpty) {
    print('No heroes found matching "$searchTerm".');
  } else {
    print('Search results:');
    printHeroList(results);
  }
  showMainMenu();
}

Future<List<Map<String, dynamic>>> loadHeroes() async {
  return await heroStorage.loadHeroes();
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

void printHeroList(List<Map<String, dynamic>> heroes) {
  for (var hero in heroes) {
    print(toString(hero));
  }
}

String toString(Map<String, dynamic> hero) {
  return '${hero["id"]}: ${hero["name"]} (${hero["appearance"]["gender"]}, ${hero["appearance"]["race"]}), strength: ${hero["powerstats"]["strength"]}, alignment: ${hero["biography"]["alignment"]}';
}
