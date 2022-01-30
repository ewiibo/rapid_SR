import 'dart:convert';

import '../model/board.dart';
import '../service/network_service.dart';

class GameCore {
  late Board? board;
  late NetworkService networkService;
  bool gameStarted = false;
  GameCore({String? address}) {
    networkService = NetworkService(
        address: address, processRequestCallback: processRequest);
    board = null;
  }
  runServer() async {
    await networkService.createServer();
  }

  stopServer() async {
    await networkService.stopServer();
  }

  //TODO(sanfane) get movement message from front
  processRequest(data) async {
    print(data);
    final Map<String, dynamic> requestData = await jsonDecode(data);

    print(requestData.toString());

    Map<String, dynamic> responseData = {};
    switch (requestData['messageType']) {
      case 'connect':
        if (board == null) {
          board = Board(requestData['size']);
          board?.loadJewels(requestData['jewel']);
        }
        final player = board?.addPlayer(
            pseudo: requestData['pseudo'], color: requestData['color']);
        responseData['messageType'] = "connected";
        responseData['idPlayer'] = player!.id;
        responseData['players'] = board!.players;
        responseData['jewels'] = board!.jewels;
        responseData['started'] = gameStarted;
        break;
      case 'start':
        if (!gameStarted) {
          gameStarted = true;
          responseData['messageType'] = 'started';
        }
        break;
      case 'move':
        board?.movePlayer(board!.getPlayer(requestData['pseudo']),
            _getMove(requestData['move']));
        responseData['messageType'] = "moved";
        responseData['players'] = board!.players;
        responseData['jewels'] = board!.jewels;

        if (board!.jewels.isEmpty) {
          board = null;
          responseData['messageType'] = 'finished';
        }

        break;

      //TODO (sanfane) Add message for getting game by Id
      case 'finish':
        responseData['messageType'] = 'finished';
        board = null;
        break;
      default:
    }

    print(responseData.toString());
    for (var socket in networkService.sockets) {
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
