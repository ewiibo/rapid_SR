import 'dart:convert';

import '../model/board.dart';
import 'network_service.dart';

class GameCore {
  late Board board;
  late NetworkService networkService;
  GameCore({String? address}) {
    networkService = NetworkService(
        address: address, processRequestCallback: processRequest);
  }
  runServer() async {
    await networkService.createServer();
  }

  stopServer() async {
    await networkService.stopServer();
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
