import 'package:test/test.dart';
import 'dart:io';
import '../bin/model/board.dart';
import '../bin/model/jewel.dart';
import '../bin/model/player.dart';
import '../bin/business/game_core.dart';

void main() {
  test('Board creation', () {
    Board board = Board(4);
    board.loadJewels(7);

    expect(board.jewels.length, 7);
    board.addPlayer();
    board.addPlayer();
    board.addPlayer();

    expect(board.players.length, 3);

    final player1 = board.getPlayer(1);
    final player2 = board.getPlayer(2);

    expect(player1.id, 1);
    expect(player2.id, 2);
    final x = player1.x;
    final y = player2.y;
    board.movePlayer(player1, Move.left);
    board.movePlayer(player1, Move.bottom);

    // expect(player1.x, x - 1);
    // expect(player1.y, y + 1);
  });

  test('connection test', () async {
    GameCore game = GameCore();
    await game.createServer();

    // WebSocket.connect(
    //   'ws://127.0.0.1:4040/',
    // );
    // var socket = await Socket.connect("ws://127.0.0.1", 4040);
    // WebSocket.fromUpgradedSocket(socket);
    expect(game.sockets.length, 1);
  });
}
