import 'shape.dart';

class Player extends Shape {
  String pseudo;
  int score;
  Player(this.pseudo, this.score, int idPlayer, int x, int y, String color,
      int size)
      : super(idPlayer, x, y, color, size);

  @override
  String toString() {
    return '''Player { pseudi : $pseudo, score : $score, ${super.toString()}}''';
  }

  Map<String, dynamic> toJson() => {
        'idPlayer': id,
        'x': x,
        'y': y,
        'color': color,
        'size': size,
        'score': score
      };
}
