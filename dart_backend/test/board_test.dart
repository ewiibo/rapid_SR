import 'package:test/test.dart';
import 'package:web_socket_channel/io.dart';
import 'dart:io';
import '../bin/model/board.dart';
import '../bin/model/jewel.dart';
import '../bin/model/player.dart';
import '../bin/business/game_core.dart';

void main() {
  var serverPort = 4040;
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
    await GameCore().runServer();
    final websocket = await WebSocket.connect('ws://127.0.0.1:4040');
    final channel = IOWebSocketChannel(websocket);

    // WebSocket.connect(
    //   'ws://127.0.0.1:4040/',
    // );
    // var socket = await Socket.connect("ws://127.0.0.1", 4040);
    // WebSocket.fromUpgradedSocket(socket);
  });

  HttpServer server;

  test('communicates using existing WebSockets', () async {
    server = await HttpServer.bind('localhost', 0);
    addTearDown(server.close);
    server.transform(WebSocketTransformer()).listen((WebSocket webSocket) {
      final channel = IOWebSocketChannel(webSocket);
      channel.sink.add('hello!');
      channel.stream.listen((request) {
        expect(request, equals('ping'));
        channel.sink.add('pong');
        channel.sink.close(5678, 'raisin');
      });
    });

    final webSocket = await WebSocket.connect('ws://localhost:${server.port}');
    final channel = IOWebSocketChannel(webSocket);

    var n = 0;
    channel.stream.listen((message) {
      if (n == 0) {
        expect(message, equals('hello!'));
        channel.sink.add('ping');
      } else if (n == 1) {
        expect(message, equals('pong'));
      } else {
        fail('Only expected two messages.');
      }
      n++;
    }, onDone: expectAsync0(() {
      expect(channel.closeCode, equals(5678));
      expect(channel.closeReason, equals('raisin'));
    }));
  });
}
