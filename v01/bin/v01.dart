import 'package:v01/v01.dart' as v01;

void main(List<String> arguments) {
  var firstNumber = v01.getUserInput<int>('Ange första talet:');
  var secondNumber = v01.getUserInput<int>('Ange andra talet:');
  var operation = v01.getUserInput<String>(
    'Vilken operation vill du göra? (+ eller -): ',
  );

  print(
    'Resultatet är: ${v01.calculate(firstNumber, secondNumber, operation)}!',
  );
}
