import 'dart:convert';
import 'dart:io';

import 'model/board.dart';

class Game {
  late List<WebSocket> sockets;
  late Board board;
  Game() {
    sockets = [];
  }
  createServer() async {
    HttpServer server = await HttpServer.bind("127.0.0.1", 4040);
    await for (var request in server) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      print("Ajout d'un client");
      sockets.add(socket);
      socket.listen(processRequest).onDone(() {
        onClose(socket);
      });
    }
  }

  createBoard(int numberOfJewels, int size) {
    board = Board(numberOfJewels, size);
  }

  addClient(WebSocket socket) {
    sockets.add(socket);
  }

  onClose(WebSocket socket) {
    sockets.remove(socket);
  }

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
        responseData['jewels'] = board.jewels;
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
}
