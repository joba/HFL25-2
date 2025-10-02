import 'dart:io';

import 'package:v02/hero.dart';
import 'package:v02/storage.dart';

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
      // Search Heroes
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

  var newHero = Hero.add(name, strength, gender, race, alignment);
  var heroes = await loadHeroes();
  await HeroStorage().saveHeroes([...heroes, newHero]);

  print('Hero ${newHero.name} successfully added!\n');
  showMainMenu();
}

void viewHeroes() async {
  var heroes = await loadHeroes();
  if (heroes.isEmpty) {
    print('No heroes found.');
  } else {
    print('Heroes:');
    for (var hero in heroes) {
      print(hero.toString());
    }
  }
  showMainMenu();
}

Future<List<Hero>> loadHeroes() async {
  return await HeroStorage().loadHeroes();
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
