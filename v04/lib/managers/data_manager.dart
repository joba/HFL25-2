import 'package:v04/models/hero_model.dart';

class DataManager {
  DataManager._internal();
  static final DataManager _instance = DataManager._internal();
  factory DataManager() => _instance;

  List<HeroModel> sortHeroes(
    List<HeroModel> heroes,
    String? sortBy, [
    int? limit,
  ]) {
    var sortedList = [...heroes]; // Create a copy to avoid mutating original

    switch (sortBy?.toLowerCase()) {
      case 'race':
        sortedList.sort((a, b) {
          final raceA = a.appearance?.race ?? '';
          final raceB = b.appearance?.race ?? '';
          return raceA.compareTo(raceB);
        });
        break;
      case 'alignment':
        sortedList.sort((a, b) {
          final alignmentA = a.biography?.alignment ?? '';
          final alignmentB = b.biography?.alignment ?? '';
          return alignmentA.compareTo(alignmentB);
        });
        break;
      case 'gender':
        sortedList.sort((a, b) {
          final genderA = a.appearance?.gender ?? '';
          final genderB = b.appearance?.gender ?? '';
          return genderA.compareTo(genderB);
        });
        break;
      default: // strength
        sortedList.sort((a, b) {
          final strengthA = int.tryParse(a.powerstats?.strength ?? '0') ?? 0;
          final strengthB = int.tryParse(b.powerstats?.strength ?? '0') ?? 0;
          return strengthB.compareTo(strengthA); // Descending order
        });
        break;
    }

    if (limit != null && limit > 0 && limit < sortedList.length) {
      sortedList = sortedList.sublist(0, limit);
    }
    return sortedList;
  }

  // This can be used to filter more values
  List<HeroModel> filterHeroes(
    List<HeroModel> heroes,
    String? filterBy,
    String? filterValue,
  ) {
    if (filterBy == null || filterValue == null || filterValue.isEmpty) {
      return [...heroes];
    }

    switch (filterBy.toLowerCase()) {
      case 'alignment':
        return heroes
            .where(
              (hero) =>
                  hero.biography?.alignment?.toLowerCase() ==
                  filterValue.toLowerCase(),
            )
            .toList();
      default:
        return [...heroes]; // Return copy if filterBy is not recognized
    }
  }

  // Search heroes by name (case-insensitive)
  List<HeroModel> searchHeroes(List<HeroModel> heroes, String searchTerm) {
    if (searchTerm.isEmpty) {
      return [...heroes];
    }

    return heroes
        .where(
          (hero) => hero.name.toLowerCase().contains(searchTerm.toLowerCase()),
        )
        .toList();
  }
}
