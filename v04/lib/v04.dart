import 'dart:io';

import 'package:cli_spin/cli_spin.dart';
import 'package:v04/firebase_config.dart';
import 'package:v04/managers/api_manager.dart';
import 'package:v04/managers/firestore_hero_data_manager.dart';
import 'package:v04/models/hero_model.dart';

final heroDataManager = FirestoreHeroDataManager();
final apiManager = ApiManager();

final spinnerLoading = CliSpin(
  text: 'Loading...',
  spinner: CliSpinners.dots2,
  color: CliSpinnerColor.green,
);

final spinnerSaving = CliSpin(
  text: 'Saving hero...',
  spinner: CliSpinners.dots3,
  color: CliSpinnerColor.cyan,
);

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
  print('5. Delete a hero');
  print('6. Back to main menu');
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
      deleteHero();
      break;
    case '6':
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
    await heroDataManager.addAsciiArtToHeroImages();
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
  spinnerLoading.start();
  var apiResponse = await apiManager.searchHeroes(searchTerm);
  spinnerLoading.stop();
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
        spinnerSaving.start();
        await heroDataManager.saveHero(heroToSave);
        if (heroToSave.image != null && heroToSave.image!.url.isNotEmpty) {
          await apiManager.downloadHeroImageIfNeeded(
            heroToSave.image!.url,
            heroToSave.id,
          );
        }
        spinnerSaving.stop();
        print('Hero "${heroToSave.name}" saved successfully.');
      } else {
        print('Hero with ID "$saveHeroId" not found in the search results.');
      }
    }
    showMainMenu();
  }
}

void deleteHero() async {
  var heroId = getUserInput<String>('Enter the ID of the hero to delete: ');
  spinnerLoading.start();
  await heroDataManager.deleteHero(heroId);
  spinnerLoading.stop();
  print('\nHero with ID "$heroId" deleted successfully.');
  showMainMenu();
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
  return '${hero.image?.asciiArt}\n${hero.id}: ${hero.name} (${hero.appearance?.gender}, ${hero.appearance?.race}), strength: ${hero.powerstats?.strength}, alignment: ${hero.biography?.alignment}';
}
