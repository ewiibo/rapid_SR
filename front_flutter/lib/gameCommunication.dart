import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'websockets.dart';

///
/// A nouveau, variable globale
///
GameCommunication game = GameCommunication();

class GameCommunication {
  static final GameCommunication _game = GameCommunication._internal();

  ///
  /// A la première initialisation, le joueur n'a pas encore de nom
  ///
  String _playerName = "";

  ///
  /// Avant d'émettre l'action "join", le joueur n'a pas encore d'identifiant unique
  ///
  String _playerID = "";

  factory GameCommunication() {
    return _game;
  }

  GameCommunication._internal() {
    ///
    /// Initialisons la communication WebSockets
    ///
    sockets.initCommunication();

    ///
    /// et demandons d'être notifié à chaque fois qu'un message est envoyé par le serveur
    ///
    sockets.addListener(_onMessageReceived);
  }

  ///
  /// Retourne le nom du joueur
  ///
  String get playerName => _playerName;

  /// ----------------------------------------------------------
  /// Gestion de tous les messages en provenance du serveur
  /// ----------------------------------------------------------
  _onMessageReceived(serverMessage) {
    ///
    /// Comme les messages sont envoyés sous forme de chaîne de caractères
    /// récupérons l'objet JSON correspondant
    ///
    Map message = json.decode(serverMessage);

    switch (message["messageType"]) {

      ///
      /// Quand la communication est établie, le serveur
      /// renvoie l'identifiant du joueur.
      /// Mémorisons-le
      ///
      case 'created':
        print("ok");
        // _playerID = message["data"];
        break;

      ///
      /// Pour tout autre message entrant,
      /// envoyons-le à tous les "listeners".
      ///
      default:
        _listeners.forEach((Function callback) {
          callback(message);
        });
        break;
    }
  }

  /// ----------------------------------------------------------
  /// Méthode d'envoi des messages au serveur
  /// ----------------------------------------------------------
  send(String action, String data) {
    ///
    /// Quand un joueur rejoint, nous devons mémoriser son nom
    ///
    if (action == 'connect') {
      _playerName = data;
    }

    ///
    /// Envoi d'une action au serveur
    /// Pour envoyer le message, nous transformons l'objet
    /// JSON en chaîne de caractères
    ///
    sockets.send(
        json.encode({"messageType": action, "size": data, "jewel": 10, "color": 'red', "pseudo": "Kiko"}));
     }

  /// ==========================================================
  ///
  /// Listeners pour permettre aux différentes pages/écrans
  /// d'être notifiés à chaque réception d'un message du serveur
  ///
  ObserverList<Function> _listeners = ObserverList<Function>();

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }
}
