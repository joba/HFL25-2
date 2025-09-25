int calculate(int a, int b, String? operation) {
  if (operation == '+') {
    return a + b;
  } else if (operation == '-') {
    return a - b;
  } else {
    throw Exception('Ogiltig operation');
  }
}
