import 'dart:io';
import 'package:v04/services/hero_service.dart';
import 'package:v04/ui/hero_display.dart';
import 'package:v04/ui/input_handler.dart';

// Start the CLI application
void start() {
  printSuccess('Welcome to Hero Management System!');
  showMainMenu();
}

// Show the main menu
void showMainMenu() {
  print('\nWelcome, make your choice below:');
  print('1. View Heroes');
  print('2. Search Heroes');
  print('3. Add new Hero');
  print('4. Exit');

  var menuItem = getChoiceInput('\nEnter your choice (1-4): ', [
    '1',
    '2',
    '3',
    '4',
  ]);

  print('\nYou selected: $menuItem\n');

  switch (menuItem) {
    case '1':
      _handleViewHeroes();
      break;
    case '2':
      _handleSearchHeroes();
      break;
    case '3':
      _handleAddNewHero();
      break;
    case '4':
      _handleExit();
      break;
    default:
      printError('Invalid option. Please try again.');
      showMainMenu();
  }
}

/// Show the filter/sort heroes menu
void showFilterHeroesMenu() {
  print('\nFilter and sort heroes:');
  print('1. Show top 3 strongest heroes');
  print('2. Show only heroes');
  print('3. Show only villains');
  print('4. Sort heroes by race');
  print('5. Sort heroes by gender');
  print('6. Delete a hero');
  print('7. Back to main menu');

  var filterOption = getChoiceInput('\nEnter your choice (1-7): ', [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
  ]);

  switch (filterOption) {
    case '1':
      _handleTopStrongestHeroes();
      break;
    case '2':
      _handleFilterByAlignment('good');
      break;
    case '3':
      _handleFilterByAlignment('bad');
      break;
    case '4':
      _handleSortByRace();
      break;
    case '5':
      _handleSortByGender();
      break;
    case '6':
      _handleDeleteHero();
      break;
    case '7':
      showMainMenu();
      break;
    default:
      printError('Invalid option. Please try again.');
      showFilterHeroesMenu();
  }
}

// Private handler methods
void _handleViewHeroes() async {
  await viewHeroes('strength');
  showFilterHeroesMenu();
}

void _handleSearchHeroes() async {
  await searchHeroes();
  showMainMenu();
}

void _handleAddNewHero() async {
  await addNewHero();
  showMainMenu();
}

void _handleExit() {
  printSuccess('Goodbye for now!');
  exit(0);
}

void _handleTopStrongestHeroes() async {
  await viewHeroes('strength', 3);
  showFilterHeroesMenu();
}

void _handleFilterByAlignment(String alignment) async {
  await filterHeroes('alignment', alignment);
  showFilterHeroesMenu();
}

void _handleSortByRace() async {
  await viewHeroes('race');
  showFilterHeroesMenu();
}

void _handleSortByGender() async {
  await viewHeroes('gender');
  showFilterHeroesMenu();
}

void _handleDeleteHero() async {
  await deleteHero();
  showMainMenu();
}
