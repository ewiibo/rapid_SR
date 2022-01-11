import 'dart:io';
import 'dart:async';

import 'model/board.dart';

String dbFileName = "mock_data.txt";
File dbFile = File(dbFileName);

addCoordinate(data) async {
  print(data.toString());
  for (var socket in sockets) {
    socket.add(data.toString());
  }
}

onClose(WebSocket socket) {
  sockets.remove(socket);
}

/// List of all cliens connected
List<WebSocket> sockets = [];

main() {
  print("Web socket started");
  // runZoned(() async {
  //   HttpServer server = await HttpServer.bind("127.0.0.1", 4040);
  //   await for (var request in server) {
  //     WebSocket socket = await WebSocketTransformer.upgrade(request);
  //     sockets.add(socket);
  //     socket.listen(addCoordinate).onDone(() {
  //       onClose(socket);
  //     });
  //   }
  // }, onError: (e) => print("Error occurred." + e.toString()));

  Board board = Board(50, 8);
  board.loadJewels();
  board.addPlayer();
  board.addPlayer(); //
  var player = board.getPlayer(1);
  board.movePlayer(player, Move.bottom);
  board.movePlayer(player, Move.left);
  board.movePlayer(player, Move.bottom);
  board.movePlayer(player, Move.right);
  board.movePlayer(player, Move.right);
  board.movePlayer(player, Move.top);

  //print(board.toJson());
}
