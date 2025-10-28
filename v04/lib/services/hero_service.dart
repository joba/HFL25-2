import 'package:cli_spin/cli_spin.dart';
import 'package:v04/di/service_locator.dart';
import 'package:v04/managers/api_manager.dart';
import 'package:v04/managers/hero_data_managing.dart';
import 'package:v04/managers/image_manager.dart';
import 'package:v04/models/hero_model.dart';
import 'package:v04/ui/hero_display.dart';
import 'package:v04/ui/input_handler.dart';

final _dataManager = getIt<HeroDataManaging>();
final _apiManager = ApiManager();
final _imageManager = ImageManager();

final CliSpin _spinnerLoading = CliSpin(
  text: 'Loading...',
  spinner: CliSpinners.dots2,
  color: CliSpinnerColor.green,
);

final CliSpin _spinnerSaving = CliSpin(
  text: 'Saving hero...',
  spinner: CliSpinners.dots3,
  color: CliSpinnerColor.cyan,
);

// Search for heroes in local database and external API
Future<void> searchHeroes() async {
  var searchTerm = getValidatedInput(
    'Enter hero name to search: ',
    allowEmpty: false,
  ).toLowerCase();

  // Search local data first
  var searchResults = await _dataManager.searchHeroes(searchTerm);
  if (searchResults.isEmpty) {
    printInfo('No heroes found matching "$searchTerm" in local database.');
  } else {
    printInfo('Results for "$searchTerm" in local database:');
    printHeroList(searchResults);
  }

  printInfo('Searching external API for "$searchTerm"...');
  _spinnerLoading.start();
  var apiResponse = await _apiManager.searchHeroes(searchTerm);
  _spinnerLoading.stop();

  if (apiResponse.response != 'success' || apiResponse.results.isEmpty) {
    printInfo('No heroes found matching "$searchTerm" in external API.');
    return;
  }

  printInfo('Results for "$searchTerm" in external API:');
  printHeroList(apiResponse.results);

  var saveHeroId = getUserInput<String>(
    '\nEnter the ID of the hero you want to save (or press Enter to skip): ',
  );

  if (saveHeroId.isNotEmpty) {
    try {
      var heroToSave = apiResponse.results.firstWhere(
        (hero) => hero.id == saveHeroId,
      );
      await saveHero(heroToSave);
    } catch (e) {
      printError('Hero with ID "$saveHeroId" not found in the search results.');
    }
  }
}

// Add a new hero manually
Future<void> addNewHero() async {
  var name = getValidatedInput('Enter hero name: ', allowEmpty: false);

  // Check if name already exists
  var searchResults = await _dataManager.searchHeroes(name.toLowerCase());
  if (searchResults.isNotEmpty) {
    printWarning(
      'A hero with the name "$name" already exists. Enter another name.',
    );
    return addNewHero();
  }

  var strength = getValidatedIntInput(
    'Enter hero strength (1-100): ',
    min: 1,
    max: 100,
  );

  var gender = getValidatedInput('Enter hero gender: ', allowEmpty: false);
  var race = getValidatedInput('Enter hero race: ', allowEmpty: false);

  var alignment = getChoiceInput('Enter hero alignment (good/bad): ', [
    'good',
    'bad',
  ]);

  var newHero = HeroModel.fromJson({
    // Trying to make an id that is unique but short, bc user has to type it when deleting
    'id': DateTime.now().millisecondsSinceEpoch.toRadixString(36),
    'name': name,
    'powerstats': {'strength': strength.toString()},
    'appearance': {'gender': gender, 'race': race},
    'biography': {'alignment': alignment},
  });

  await saveHero(newHero);
}

// Save a hero to the database
Future<void> saveHero(HeroModel heroToSave) async {
  _spinnerSaving.start();
  var result = await _dataManager.saveHero(heroToSave);

  if (result == 'success') {
    printSuccess('Hero "${heroToSave.name}" saved successfully.');

    if (heroToSave.image != null && heroToSave.image!.url.isNotEmpty) {
      await _apiManager.downloadHeroImageIfNeeded(
        heroToSave.name,
        heroToSave.id,
      );
    }
  } else if (result == 'duplicatedEntry') {
    printWarning('Hero "${heroToSave.name}" already exists in the database.');
  } else {
    printError('Failed to save hero "${heroToSave.name}".');
  }
  _spinnerSaving.stop();
}

// Delete a hero from the database
Future<void> deleteHero() async {
  var heroId = getValidatedInput(
    'Enter the ID of the hero to delete: ',
    allowEmpty: false,
  );

  _spinnerLoading.start();
  await _dataManager.deleteHero(heroId);
  _spinnerLoading.stop();

  printSuccess('Hero with ID "$heroId" deleted successfully.');
}

// Filter heroes
Future<void> filterHeroes(String filterBy, String filterValue) async {
  var heroes = _dataManager.filterHeroes(filterBy, filterValue);

  if (heroes.isEmpty) {
    printInfo('No heroes found for $filterBy: $filterValue.');
    return;
  }

  await _imageManager.addAsciiArtToHeroImages(heroes);
  printInfo('Heroes filtered by $filterBy: $filterValue:');
  printHeroList(heroes);
}

// View heroes sorted by a specific criteria
Future<void> viewHeroes(String sortBy, [int? limit]) async {
  await _dataManager.loadHeroes();
  var heroes = _dataManager.heroes;

  if (heroes.isEmpty) {
    printInfo('No heroes found.');
    return;
  }

  await _imageManager.addAsciiArtToHeroImages(heroes);
  heroes = _dataManager.sortHeroes(sortBy, limit);

  String limitText = limit != null ? ' (top $limit)' : '';
  printInfo('Heroes sorted by $sortBy$limitText:');
  printHeroList(heroes);
}
