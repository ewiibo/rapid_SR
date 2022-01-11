import 'board.dart';
import 'shape.dart';

class Player extends Shape {
  String pseudo;
  Player(this.pseudo, int idPlayer, int x, int y, String color, int size)
      : super(idPlayer, x, y, color, size);
  //TODO(sanfane) fix border mover
  move(Move move) {
    switch (move) {
      case Move.bottom:
        y++;
        break;
      case Move.top:
        y--;
        break;
      case Move.left:
        x--;
        break;
      case Move.right:
        x++;
        break;
      default:
        return;
    }
  }

  @override
  String toString() {
    return '''Player { pseudi : $pseudo, ${super.toString()}}''';
  }

  Map<String, dynamic> toJson() => {'idPlayer': super.id, 'x': super.x};
}
