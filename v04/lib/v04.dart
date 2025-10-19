import 'dart:io';

import 'package:v04/firebase_config.dart';
import 'package:v04/managers/api_manager.dart';
import 'package:v04/managers/firestore_hero_data_manager.dart';
import 'package:v04/models/hero_model.dart';

final heroDataManager = FirestoreHeroDataManager();
final apiManager = ApiManager();

void showMainMenu() {
  FirebaseConfig.initialize();
  print('\nWelcome, make your choice below:');
  print('1. View Heroes');
  print('2. Search Heroes');
  print('3. Exit');
  var menuItem = stdin.readLineSync();

  print('\nYou selected: $menuItem\n');
  switch (menuItem) {
    case '1':
      viewHeroes('strength');
      break;
    case '2':
      searchHeroes();
      break;
    case '3':
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

void viewHeroes(String sortBy, [int? limit]) async {
  await heroDataManager.loadHeroes();
  var heroes = heroDataManager.heroes;
  if (heroes.isEmpty) {
    print('No heroes found.');
    showMainMenu();
  } else {
    heroes = heroDataManager.sortHeroes(sortBy, limit);
    print('Heroes sorted by $sortBy:');
    printHeroList(heroes);
    showFilterHeroesMenu();
  }
}

void searchHeroes() async {
  var searchTerm = getUserInput<String>(
    'Enter hero name to search: ',
  ).toLowerCase();
  var apiResponse = await apiManager.searchHeroes(searchTerm);

  if (apiResponse.response != 'success' || apiResponse.results.isEmpty) {
    print('\nNo heroes found matching "$searchTerm".');
    showMainMenu();
  } else {
    print('\nResults for "$searchTerm":');
    printHeroList(apiResponse.results);

    var saveHeroId = getUserInput<String>(
      '\nEnter the ID of the hero you want to save (or press Enter to skip): ',
    );
    if (saveHeroId.isNotEmpty) {
      var heroToSave = apiResponse.results.firstWhere(
        (hero) => hero.id == saveHeroId,
      );
      if (heroToSave.id.isNotEmpty) {
        await heroDataManager.saveHero(heroToSave);
        print('Hero "${heroToSave.name}" saved successfully.');
      } else {
        print('Hero with ID "$saveHeroId" not found in the search results.');
      }
    }
    showMainMenu();
  }
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
  return '${hero.id}: ${hero.name} (${hero.appearance?.gender}, ${hero.appearance?.race}), strength: ${hero.powerstats?.strength}, alignment: ${hero.biography?.alignment}';
}
