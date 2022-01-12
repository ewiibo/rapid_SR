import 'dart:io';
import 'dart:async';
import 'dart:convert';

import 'model/board.dart';

//TODO(sanfane) get movement message from front
processRequest(data) async {
  final Map<String, dynamic> requestData = await jsonDecode(data);

  print(requestData.toString());

  Map<String, dynamic> responseData = {};
  switch (requestData['messageType']) {
    case 'create':
      print('dans create');
      board = Board(requestData['jewel'], requestData['size']);

      responseData['messageType'] = "created";
      responseData['boardId'] = 1;
      break;
    case 'connect':
      final player = board.addPlayer(
          pseudo: requestData['pseudo'], color: requestData['color']);
      responseData['messageType'] = "connected";
      responseData['idPlayer'] = player.id;
      responseData['players'] = board.players;
      break;
    case 'finish':
      break;
    case 'move':
      break;
    default:
  }

  print(responseData.toString());
  for (var socket in sockets) {
    socket.add(jsonEncode(responseData));
  }
}

onClose(WebSocket socket) {
  sockets.remove(socket);
}
// TODO(sanfane) create web service for create and join game
// TODO(sanfane) create a list board for each game and the board must have an random id

/// List of all cliens connected
List<WebSocket> sockets = [];

late Board board;

main() {
  print("Web socket started");
  runZoned(() async {
    HttpServer server = await HttpServer.bind("127.0.0.1", 4040);
    await for (var request in server) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      print("Ajout d'un client");
      sockets.add(socket);
      socket.listen(processRequest).onDone(() {
        onClose(socket);
      });
    }
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

  //print(board.toJson());
}
