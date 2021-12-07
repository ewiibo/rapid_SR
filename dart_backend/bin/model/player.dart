import 'shape.dart';

class Player extends Shape {
  int idPlayer;
  Player(this.idPlayer, int x, int y, String color, int size)
      : super(x, y, color, size);

  @override
  String toString() {
    return '''Player {idPlayer : $idPlayer, ${super.toString()}}''';
  }
}
