import 'dart:io';

import 'package:v01/v01.dart' as v01;

void main(List<String> arguments) {
  print('Ange första talet: ');
  var firstNumber = int.parse(stdin.readLineSync()!);
  print('Ange andra talet: ');
  var secondNumber = int.parse(stdin.readLineSync()!);
  print('Vilken operation vill du göra? (+ eller -): ');
  var operation = stdin.readLineSync();
  print(
    'Resultatet är: ${v01.calculate(firstNumber, secondNumber, operation)}!',
  );
}
