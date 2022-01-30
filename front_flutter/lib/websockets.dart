import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

///
/// Variable globale d'accès aux WebSockets
///
WebSocketsNotifications sockets = WebSocketsNotifications();

///
/// Remplacez la ligne suivante par l'adresse IP et le numéro de port de votre serveur
///
const String _SERVER_ADDRESS = "ws://127.0.0.1:4040";

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets =
      WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  WebSocketsNotifications._internal();

  ///
  /// Le canal de communication WebSocket
  ///
  // IOWebSocketChannel _channel = IOWebSocketChannel.connect('ws://127.0.0.1:4040');
  WebSocketChannel _channel =
      WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:4040'));

  ///
  /// La connexion est-elle établie ?
  ///
  bool _isOn = false;

  ///
  /// Listeners
  /// Liste des méthodes à appeler à chaque fois d'un message est reçu
  ///
  ObserverList<Function> _listeners = ObserverList<Function>();

  /// ----------------------------------------------------------
  /// Initialisation de la connexion WebSockets avec le serveur
  /// ----------------------------------------------------------
  initCommunication() async {
    ///
    /// Juste au cas..., ferture d'un autre connexion
    ///
    //reset();

    ///
    /// Ouvrir une nouvelle communication WebSockets
    ///
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:4040'));

      ///
      /// Démarrage de l'écoute des nouveaux messages
      ///
      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {
      ///
      /// Gestion des erreurs globales
      /// TODO
      ///
    }
  }

  /// ----------------------------------------------------------
  /// Fermer la communication WebSockets
  /// ----------------------------------------------------------
  reset() {
    _channel.sink.close();
    _isOn = false;
  }

  /// ---------------------------------------------------------
  /// Envoie un message au serveur
  /// ---------------------------------------------------------
  send(String message) {
    _channel.sink.add(message);
    // if (_channel != null) {
    //   if (_channel.sink != null && _isOn) {
    //     _channel.sink.add(message);
    //   }
    // }
  }

  /// ---------------------------------------------------------
  /// Gestion des routines à appeler lors de la réception
  /// des messages issus du serveur
  /// ---------------------------------------------------------
  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  /// ----------------------------------------------------------
  /// Appel de toutes les méthodes à l'écoute des messages entrants
  /// ----------------------------------------------------------
  _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}
