import 'shape.dart';

class Jewel extends Shape {
  Jewel(int id, int x, int y, String color, int size)
      : super(id, x, y, color, size);

  @override
  String toString() {
    return '''
Jewel ${super.toString()}''';
  }
}