import 'dart:math';

import 'jewel.dart';
import 'player.dart';
import 'shape.dart';

class Board {
  int numberOfJewels;
  int size;
  late List<List<Shape>> cells;
  final _players = [];
  final _jewels = [];
  //must create a object for representing the null shape beacause of null-safety.
  final nullShape = Shape(0, 0, '', 0);
  Board(this.numberOfJewels, this.size) {
    cells = List.generate(size, (i) => List.filled(size, nullShape));
  }

  // create jewels and random position.
  loadJewels() {
    int x, y;
    for (int i = 0; i < numberOfJewels; i++) {
      do {
        x = Random().nextInt(size);
        y = Random().nextInt(size);
      } while (cells[x][y] != nullShape);
      cells[x][y] = Jewel(x, y, 'color', size);
      _jewels.add(cells[x][y]);
    }
  }

  //create a new player and add him with random position
  addPlayer() {
    int x, y;
    do {
      x = Random().nextInt(size);
      y = Random().nextInt(size);
    } while (cells[x][y] != nullShape || cells[x][y] is Jewel);
    cells[x][y] = Player(_players.length, x, y, 'color', size);
    _players.add(cells[x][y]);
  }

  //return a json format of the jewels and players.
  toJson() {
    return ''' ''';
  }
}
