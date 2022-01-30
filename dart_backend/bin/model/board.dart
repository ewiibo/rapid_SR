import 'dart:math';

import 'jewel.dart';
import 'player.dart';
import 'shape.dart';

enum Move { left, right, top, bottom }

class Board {
  int size;
  final players = <Player>[];
  final jewels = <Jewel>[];
  //must create a object for representing the null shape beacause of null-safety.
  Board(this.size);

  // create jewels at random position.
  loadJewels(int numberOfJewels) {
    int x, y;
    for (int i = 0; i < numberOfJewels; i++) {
      do {
        x = Random().nextInt(size);
        y = Random().nextInt(size);
      } while (getObjectAt(x, y).isNotEmpty);
      jewels.add(Jewel(i, x, y));
    }
  }

  // use this method to avoid using cells var
  List<Shape> getObjectAt(int x, int y) {
    List<Shape> shapes = [];
    shapes.addAll(jewels.where((jewel) => jewel.x == x && jewel.y == y));
    shapes.addAll(players.where((player) => player.x == x && player.y == y));
    return shapes;
  }

  //create a new player and add him with random position
  Player addPlayer({pseudo = '', int color = 0}) {
    int x, y;
    do {
      x = Random().nextInt(size);
      y = Random().nextInt(size);
    } while (getObjectAt(x, y).isNotEmpty);
    players.add(Player("pseudo" + pseudo == '' ? players.length : pseudo, 0,
        players.length, x, y, color, size));
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
        } else {
          return;
        }
        break;
      case Move.top:
        if (player.y - 1 != 0) {
          player.y--;
        } else {
          return;
        }
        break;
      case Move.left:
        if (player.x - 1 != 0) {
          player.x--;
        } else {
          return;
        }
        break;
      case Move.right:
        if (player.x + 1 != size) {
          player.x++;
        } else {
          return;
        }
        break;
      default:
        return;
    }
    // check if there is not an other player in the position
    final otherPlayer = players.indexWhere(
        (elt) => elt.x == player.x && elt.y == player.y && elt.id != player.id);
    if (otherPlayer != -1) return;
    // update coordonate of the player
    final playerIndex = getIndexPlayer(player.id);
    players[playerIndex]
      ..x = player.x
      ..y = player.y;

    final index = jewels
        .indexWhere((jewel) => jewel.x == player.x && jewel.y == player.y);
    if (index != -1) {
      players[playerIndex].score++;
      jewels.removeAt(index);
    }
  }

  //
  //TODO(sanfane)return a json format of the jewels and players.
  Map<String, dynamic> toJson() => {'players': players, 'jewels': jewels};
  getJsonFromList(List<dynamic> list) {
    String result = '';
    for (var e in list) {
      result += e.toJson();
    }

    return result;
  }
}
