import 'shape.dart';

class Jewel extends Shape {
  Jewel(int id, int x, int y) : super(id, x, y);

  @override
  String toString() {
    return '''
Jewel ${super.toString()}''';
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'x': x,
        'y': y,
      };
}
