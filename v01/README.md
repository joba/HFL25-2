This is a simple calculator that runs in your terminal.

## Getting Started

Run the program:

```bash
dart run
```

## Learn more

To create a function in Dart:

```bash
# specify the return type followed by the function name and parameters(optional)
int add(int number1, int number b) {
  return number1 + number2;
}

#or use a generic type parameter to allow for different return types
T returnInput<T>(String input) {
  if (T == int) {
    return int.parse(input!) as T;
  } else {
    return input as T;
  }
}
```
