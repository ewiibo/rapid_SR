import 'dart:convert';

import '../model/board.dart';
import '../service/network_service.dart';
import 'player_colors.dart';

class GameCore {
  late Board? board;
  Set<int> colors = Set.from(playerColors);
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
        if (!gameStarted) {
          if (board == null) {
            board = Board(requestData['size']);
            board?.loadJewels(requestData['jewel']);
            responseData['owner'] = true;
          }
          var color = colors.first;
          colors.remove(color);
          final player =
              board?.addPlayer(pseudo: requestData['pseudo'], color: color);
          responseData['messageType'] = "connected";
          responseData['idPlayer'] = player!.id;
          responseData['players'] = board!.players;
          responseData['jewels'] = board!.jewels;
        } else {
          responseData['messageType'] = 'already_started';
        }

        break;
      case 'start':
        if (!gameStarted) {
          gameStarted = true;
          responseData['messageType'] = 'started';
          responseData['players'] = board!.players;
          responseData['jewels'] = board!.jewels;
        }
        break;
      case 'move':
        board?.movePlayer(
            board!.getPlayer(requestData['id']), _getMove(requestData['move']));
        responseData['messageType'] = "moved";
        responseData['players'] = board!.players;
        responseData['jewels'] = board!.jewels;

        if (board!.jewels.isEmpty) {
          board = null;
          colors = Set.from(playerColors);
          responseData['messageType'] = 'finished';
        }

        break;

      //TODO (sanfane) Add message for getting game by Id
      case 'finish':
        responseData['messageType'] = 'finished';
        board = null;
        colors = Set.from(playerColors);

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
