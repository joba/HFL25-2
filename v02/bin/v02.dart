// import 'package:v02/v02.dart' as v02;
import 'package:v02/hero.dart';
import 'package:v02/v02.dart';

void main(List<String> arguments) {
  var name = getUserInput<String>('Enter hero name: ');
  var strength = getUserInput<int>('Enter hero strength (number): ');
  var gender = getUserInput<String>('Enter hero gender: ');
  var race = getUserInput<String>('Enter hero race: ');
  var alignment = getUserInput<String>('Enter hero alignment (good, evil): ');
  // var thor = Hero.fromJson({
  //   "name": "Thor",
  //   "powerstats": {"strength": 100},
  //   "appearance": {"gender": "Male", "race": "Asgardian"},
  //   "biography": {"alignment": "good"},
  // });

  var hero = Hero.add(name, strength, gender, race, alignment);
  print('Saved hero: ${hero.toString()}!');
}
