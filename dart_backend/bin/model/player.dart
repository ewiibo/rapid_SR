import 'shape.dart';

class Player extends Shape {
  String pseudo;
  int score;
  int color;
  Player(
      this.pseudo, this.score, int idPlayer, int x, int y, this.color, int size)
      : super(idPlayer, x, y);

  @override
  String toString() {
    return '''Player { pseudi : $pseudo, score : $score, color : $color ${super.toString()}}''';
  }

  Map<String, dynamic> toJson() => {
        'idPlayer': id,
        'x': x,
        'y': y,
        'pseudo': pseudo,
        'color': color,
        'score': score
      };
}
