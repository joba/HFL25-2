// import 'package:v02/v02.dart' as v02;
import 'package:v02/hero.dart';

void main(List<String> arguments) {
  var thor = Hero.fromJson({
    "name": "Thor",
    "powerstats": {"strength": 100},
    "appearance": {"gender": "Male", "race": "Asgardian"},
    "biography": {"alignment": "good"},
  });

  var loki = Hero.add("Loki", 85, "Male", "Asgardian", "good");
  print('Hello hero: ${thor.toString()}!');
  print('Hello hero: ${loki.toString()}!');
}
