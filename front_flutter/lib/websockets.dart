import 'package:flutter/foundation.dart';
import 'package:universal_io/io.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

WebSocketsNotifications sockets = WebSocketsNotifications();

const String _SERVER_ADDRESS = "ws://127.0.0.1:4040";

class WebSocketsNotifications {
  static final WebSocketsNotifications _sockets =
      WebSocketsNotifications._internal();

  factory WebSocketsNotifications() {
    return _sockets;
  }

  WebSocketsNotifications._internal();

  WebSocketChannel _channel =
      WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:4040'));

  bool _isOn = false;

  ObserverList<Function> _listeners = ObserverList<Function>();

  initCommunication() async {
    try {
      _channel = WebSocketChannel.connect(Uri.parse('ws://127.0.0.1:4040'));

      _channel.stream.listen(_onReceptionOfMessageFromServer);
    } catch (e) {}
  }

  reset() {
    _channel.sink.close();
    _isOn = false;
  }

  send(String message) {
    _channel.sink.add(message);
  }

  addListener(Function callback) {
    _listeners.add(callback);
  }

  removeListener(Function callback) {
    _listeners.remove(callback);
  }

  _onReceptionOfMessageFromServer(message) {
    _isOn = true;
    _listeners.forEach((Function callback) {
      callback(message);
    });
  }
}
