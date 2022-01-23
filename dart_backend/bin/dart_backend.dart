import 'dart:async';
import 'business/game_core.dart';

main() {
  print("[INFO] Server started .........");
  runZoned(() async {
    GameCore game = GameCore();
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
