import 'dart:convert';
import 'dart:io';

import '../model/board.dart';

class GameCore {
  late Set<WebSocket> sockets;
  late Map<String, List<WebSocket>> mapSockets;
  // late List<Board> boards; For having multiple session of game
  late Board board;
  GameCore() {
    sockets = {};
  }

  createServer() async {
    HttpServer server = await HttpServer.bind(InternetAddress.anyIPv4, 4040);
    print("[INFO] Server running on : ${InternetAddress.anyIPv4.address}");
    await for (var request in server) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      print("[INFO] Client connection ....");
      socket.listen(processRequest).onDone(() {
        onClose(socket);
      });
    }
  }

  addClient(WebSocket socket) {
    sockets.add(socket);
  }

  onClose(WebSocket socket) {
    sockets.remove(socket);
    print("[INFO] client disconnected ....");
  }

  //TODO(sanfane) get movement message from front
  processRequest(data) async {
    final Map<String, dynamic> requestData = await jsonDecode(data);

    print(requestData.toString());

    Map<String, dynamic> responseData = {};
    switch (requestData['messageType']) {
      case 'create':
        print('dans create');
        board = Board(requestData['size']);
        board.loadJewels(requestData['jewel']);

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
      case 'start':
        responseData['messageType'] = 'started';
        break;
      case 'move':
        board.movePlayer(board.getPlayer(requestData['pseudo']),
            _getMove(requestData['move']));
        responseData['messageType'] = "moved";
        responseData['players'] = board.players;
        responseData['jewels'] = board.jewels;

        if (board.jewels.isEmpty) {
          responseData['messageType'] = 'finished';
        }

        break;

      //TODO (sanfane) Add message for getting game by Id
      case 'finish':
        responseData['messageType'] = 'finished';
        break;
      default:
    }

    print(responseData.toString());
    for (var socket in sockets) {
      socket.add(jsonEncode(responseData));
    }
  }

  _getMove(String move) {
    switch (move) {
      case 'left':
        return Move.left;
      case 'right':
        return Move.right;
      case 'top':
        return Move.top;
      case 'bottom':
        return Move.bottom;
    }
  }
}
