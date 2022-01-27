import 'dart:io';

class NetworkService {
  List<WebSocket> sockets = [];
  late HttpServer server;
  int? port;
  Function(dynamic) processRequestCallback;
  NetworkService({required this.processRequestCallback, this.port = 4040});

  createServer() async {
    server = await HttpServer.bind(InternetAddress.anyIPv4, port!);
    print("[INFO] Server running on : ${InternetAddress.anyIPv4.address}");
    await for (var request in server) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      print("[INFO] Client connection ....");
      socket.listen(processRequestCallback).onDone(() {
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

  boardCastMessage(String message) {
    for (var socket in sockets) {
      socket.add(message);
    }
  }

  broadCastMessageGame(String gameKey, String message) {}
}
