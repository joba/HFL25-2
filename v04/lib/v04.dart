import 'dart:io';

import 'package:cli_spin/cli_spin.dart';
import 'package:cli_table/cli_table.dart';
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
  print('2. Show only heroes');
  print('3. Show only villains');
  print('4. Sort heroes by race');
  print('5. Sort heroes by gender');
  print('6. Delete a hero');
  print('7. Back to main menu');
  var filterOption = stdin.readLineSync();

  switch (filterOption) {
    case '1':
      viewHeroes('strength', 3);
      break;
    case '2':
      filterHeroes('alignment', 'good');
      break;
    case '3':
      filterHeroes('alignment', 'bad');
      break;
    case '4':
      viewHeroes('race');
      break;
    case '5':
      viewHeroes('gender');
      break;
    case '6':
      deleteHero();
      break;
    case '7':
      showMainMenu();
      break;
    default:
      print('Invalid option. Please try again.');
      showFilterHeroesMenu();
  }
}

void filterHeroes(String filterBy, String filterValue) async {
  await heroDataManager.loadHeroes();
  var heroes = heroDataManager.filterHeroes(filterBy, filterValue);
  if (heroes.isEmpty) {
    print('No heroes found for $filterBy: $filterValue.');
    showMainMenu();
  } else {
    await heroDataManager.addAsciiArtToHeroImages();
    print('Heroes filtered by $filterBy: $filterValue:');
    printHeroList(heroes);
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
  // Search local data first
  var searchResults = await heroDataManager.searchHeroes(searchTerm);
  if (searchResults.isEmpty) {
    print('\nNo heroes found matching "$searchTerm" in local database.');
  } else {
    print('\nResults for "$searchTerm" in local database:');
    printHeroList(searchResults);
  }
  print('\nSearching external API for "$searchTerm"...');
  spinnerLoading.start();
  var apiResponse = await apiManager.searchHeroes(searchTerm);
  spinnerLoading.stop();
  if (apiResponse.response != 'success' || apiResponse.results.isEmpty) {
    print('\nNo heroes found matching "$searchTerm" in external API.');
    showMainMenu();
  } else {
    print('\nResults for "$searchTerm" in external API:');
    printHeroList(apiResponse.results);

    var saveHeroId = getUserInput<String>(
      '\nEnter the ID of the hero you want to save (or press Enter to skip): ',
    );
    if (saveHeroId.isNotEmpty) {
      var heroToSave = apiResponse.results.firstWhere(
        (hero) => hero.id == saveHeroId,
      );
      if (heroToSave.id.isNotEmpty) {
        await saveHero(heroToSave);
      } else {
        print('Hero with ID "$saveHeroId" not found in the search results.');
      }
    }
    showMainMenu();
  }
}

Future<void> saveHero(HeroModel heroToSave) async {
  spinnerSaving.start();
  var result = await heroDataManager.saveHero(heroToSave);

  if (result == 'success') {
    print('Hero "${heroToSave.name}" saved successfully.');

    if (heroToSave.image != null && heroToSave.image!.url.isNotEmpty) {
      await apiManager.downloadHeroImageIfNeeded(
        heroToSave.name,
        heroToSave.id,
      );
    }
  } else if (result == 'duplicatedEntry') {
    print('Hero "${heroToSave.name}" already exists in the database.');
  } else {
    print('Failed to save hero "${heroToSave.name}".');
  }
  spinnerSaving.stop();
}

Future<void> deleteHero() async {
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
    if (hero.image?.asciiArt != '') {
      final table = Table(
        header: [
          {
            'content':
                '${hero.id}: ${hero.name} (${hero.appearance?.gender}, ${hero.appearance?.race})',
            'colSpan': 2,
          },
        ],
      );
      table.add([
        {'colSpan': 2, 'content': hero.image!.asciiArt},
      ]);
      table.add([
        hero.powerstats?.strength != null
            ? 'Strength: ${hero.powerstats!.strength}'
            : 'Strength: N/A',
        hero.biography?.alignment != null
            ? 'Alignment: ${hero.biography!.alignment}'
            : 'Alignment: N/A',
      ]);

      print(table.toString());
    } else {
      print(toString(hero));
    }
  }
}

String toString(HeroModel hero) {
  return '${hero.id}: ${hero.name} (${hero.appearance?.gender}, ${hero.appearance?.race}), strength: ${hero.powerstats?.strength}, alignment: ${hero.biography?.alignment}';
}
