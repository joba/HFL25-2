import 'package:v01/v01.dart';
import 'package:test/test.dart';

void main() {
  test('calculate', () {
    expect(calculate(6, 5, '+'), 11);
    expect(calculate(6, 5, '-'), 1);
  });
}
