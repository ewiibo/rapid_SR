import 'dart:async';

import 'game.dart';

main() {
  print("Web socket started");
  runZoned(() async {
    Game game = Game();
    await game.createServer();
  }, onError: (e) => print("Error occurred." + e.toString()));

  // Board board = Board(50, 8);
  // board.loadJewels();
  // board.addPlayer();
  // board.addPlayer(); //
  // var player = board.getPlayer(1);
  // board.movePlayer(player, Move.bottom);
  // board.movePlayer(player, Move.left);
  // board.movePlayer(player, Move.bottom);
  // board.movePlayer(player, Move.right);
  // board.movePlayer(player, Move.right);
  // board.movePlayer(player, Move.top);

  // print(board.toJson());
}
