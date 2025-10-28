import 'dart:io';

// Generic method to get user input with type safety
T getUserInput<T>(String prompt) {
  stdout.write(prompt);
  var input = stdin.readLineSync();

  if (T == int && input != null) {
    try {
      return int.parse(input) as T;
    } catch (e) {
      print('Invalid input. Please enter a valid number.');
      return getUserInput<T>(prompt);
    }
  } else {
    return (input ?? '') as T;
  }
}

// Get user input with validation
String getValidatedInput(String prompt, {bool allowEmpty = true}) {
  String input = getUserInput<String>(prompt);

  if (!allowEmpty && input.trim().isEmpty) {
    print('Input cannot be empty. Please try again.');
    return getValidatedInput(prompt, allowEmpty: allowEmpty);
  }

  return input.trim();
}

// Get integer input with range validation
int getValidatedIntInput(String prompt, {int? min, int? max}) {
  int input = getUserInput<int>(prompt);

  if (min != null && input < min) {
    print('Value must be at least $min. Please try again.');
    return getValidatedIntInput(prompt, min: min, max: max);
  }

  if (max != null && input > max) {
    print('Value must be at most $max. Please try again.');
    return getValidatedIntInput(prompt, min: min, max: max);
  }

  return input;
}

// Get choice from a list of valid options
String getChoiceInput(
  String prompt,
  List<String> validChoices, {
  bool caseSensitive = false,
}) {
  String input = getUserInput<String>(prompt);

  List<String> choices = caseSensitive
      ? validChoices
      : validChoices.map((c) => c.toLowerCase()).toList();
  String checkInput = caseSensitive ? input : input.toLowerCase();

  if (!choices.contains(checkInput)) {
    print('Invalid choice. Valid options are: ${validChoices.join(', ')}');
    return getChoiceInput(prompt, validChoices, caseSensitive: caseSensitive);
  }

  return caseSensitive ? input : input.toLowerCase();
}
