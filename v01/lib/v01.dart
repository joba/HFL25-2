import 'dart:io';

int calculate(int a, int b, String? operation) {
  if (operation == '+') {
    return a + b;
  } else if (operation == '-') {
    return a - b;
  } else {
    throw Exception('Ogiltig operation');
  }
}

// Use a generic type parameter to allow different return types
T getUserInput<T>(String prompt) {
  print(prompt);
  var input = stdin.readLineSync();
  if (T == int) {
    // input can be null
    return int.parse(input!) as T;
  } else {
    return input as T;
  }
}
