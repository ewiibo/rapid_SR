import 'shape.dart';

class Jewel extends Shape {
  Jewel(int x, int y, String color, int size) : super(x, y, color, size);

  @override
  String toString() {
    return '''
Jewel ${super.toString()}''';
  }
}
