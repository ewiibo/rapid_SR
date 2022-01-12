import 'dart:math';

import 'jewel.dart';
import 'player.dart';
import 'shape.dart';

enum Move { left, right, top, bottom }

class Board {
  int numberOfJewels;
  int size;
  late List<List<Shape>> cells;
  final players = [];
  final jewels = [];
  //must create a object for representing the null shape beacause of null-safety.
  final nullShape = Shape(0, 0, 0, '', 0);
  Board(this.numberOfJewels, this.size) {
    cells = List.generate(size, (i) => List.filled(size, nullShape));
  }

  // create jewels at random position.
  loadJewels() {
    int x, y;
    for (int i = 0; i < numberOfJewels; i++) {
      do {
        x = Random().nextInt(size);
        y = Random().nextInt(size);
      } while (cells[x][y] != nullShape);
      cells[x][y] = Jewel(i, x, y, 'color', size);
      jewels.add(cells[x][y]);
    }
  }

  getObjectAt(int x, int y) {
    //TODO(sanfane) create a method for getting object in position x, y
  }

  //create a new player and add him with random position
  Player addPlayer({pseudo = '', color = 'color'}) {
    int x, y;
    do {
      x = Random().nextInt(size);
      y = Random().nextInt(size);
    } while (cells[x][y] != nullShape || cells[x][y] is Jewel);
    cells[x][y] = Player("pseudo" + pseudo == '' ? players.length : pseudo, 0,
        players.length, x, y, color, size);
    players.add(cells[x][y]);
    return players.last;
  }

  // get a player by his id
  Player getPlayer(int idPlayer) {
    return players.firstWhere((player) => player.id == idPlayer);
  }

  int getIndexPlayer(int idPlayer) {
    return players.indexWhere((player) => player.id == idPlayer);
  }

  setPlayer(Player player) {
    getPlayer(player.id)
      ..x = player.x
      ..y = player.y
      ..score = player.score;
  }

  movePlayer(Player player, Move move) {
    switch (move) {
      case Move.bottom:
        if (player.y + 1 != size) {
          player.y++;
        }
        break;
      case Move.top:
        if (player.y - 1 != 0) {
          player.y--;
        }
        break;
      case Move.left:
        if (player.x - 1 != 0) {
          player.x--;
        }
        break;
      case Move.right:
        if (player.x + 1 != size) {
          player.x++;
        }
        break;
      default:
        return;
    }
    // check if there is not an other player in the position
    final otherPlayer =
        players.indexWhere((elt) => elt.x == player.x && elt.y == player.y);
    if (otherPlayer != -1) return;
    // update coordonate of the player
    final playerIndex = getIndexPlayer(player.id);
    players[playerIndex]
      ..x = player.x
      ..y = player.y;

    final index = jewels
        .indexWhere((jewel) => jewel.x == player.x && jewel.y == player.y);
    if (index != -1) {
      print("Jewel trouvé");
      players[playerIndex].score++;
      jewels.removeAt(index);
    }
  }

  //
  //TODO(sanfane)return a json format of the jewels and players.
  Map<String, dynamic> toJson() =>
      {'numberOfJewels': numberOfJewels, 'players': players, 'jewels': jewels};
  getJsonFromList(List<dynamic> list) {
    String result = '';
    for (var e in list) {
      result += e.toJson();
    }

    return result;
  }
}
