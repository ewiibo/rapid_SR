import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'websockets.dart';

GameCommunication game = GameCommunication();

class GameCommunication {
  static final GameCommunication _game = GameCommunication._internal();

  String _playerName = "";

  int _playerID = 0;

  factory GameCommunication() {
    return _game;
  }

  GameCommunication._internal() {
    sockets.initCommunication();

    sockets.addListener(_onMessageReceived);
  }

  String get playerName => _playerName;

  int get playerId => _playerID;

  _onMessageReceived(serverMessage) {
    Map message = json.decode(serverMessage);

    switch (message["messageType"]) {
      // case 'connected':
      // for (Map el in message["players"]) {
      //     el[]
      //   }
      // _playerID = message["idPlayer"];
      //   print("player ID " + playerId.toString());
      //   break;
      default:
        _listeners.forEach((Function callback) {
          callback(message);
        });
        break;
    }
  }

  send(String action, int size, int jewel, int id, String pseudo,
      String moveDir) {
    if (action == 'connect') {
      _playerName = pseudo;
    }

    sockets.send(json.encode({
      "messageType": action,
      "size": size,
      "jewel": jewel,
      "id": id,
      "pseudo": playerName,
      "move": moveDir
    }));
  }

  ObserverList<Function> _listeners = ObserverList<Function>();

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }
}
