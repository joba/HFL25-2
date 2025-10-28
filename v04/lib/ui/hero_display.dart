import 'package:cli_table/cli_table.dart';
import 'package:v04/models/hero_model.dart';

// Print a formatted list of heroes
void printHeroList(List<HeroModel> heroes) {
  for (var hero in heroes) {
    if (hero.image != null && hero.image?.asciiArt != '') {
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
      print(heroToString(hero));
    }
  }
}

// Convert hero to string representation
String heroToString(HeroModel hero) {
  return '${hero.id}: ${hero.name} (${hero.appearance?.gender}, ${hero.appearance?.race}), strength: ${hero.powerstats?.strength}, alignment: ${hero.biography?.alignment}';
}

// Print success message with formatting
void printSuccess(String message) {
  print('\n✅ $message\n');
}

// Print error message with formatting
void printError(String message) {
  print('\n❌ $message\n');
}

// Print info message with formatting
void printInfo(String message) {
  print('\nℹ️  $message\n');
}

// Print warning message with formatting
void printWarning(String message) {
  print('\n⚠️  $message\n');
}
