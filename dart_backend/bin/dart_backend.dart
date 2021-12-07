import 'dart:io';
import 'dart:async';

String dbFileName = "mock_data.txt";
File dbFile = File(dbFileName);

addCoordinate(data) async {
  print(data.toString());
  for (var socket in sockets) {
    socket.add(data.toString());
  }
}

onClose(WebSocket socket) {
  sockets.remove(socket);
}

/// List of all cliens connected
List<WebSocket> sockets = [];

main() {
  print("Web socket started");
  runZoned(() async {
    HttpServer server = await HttpServer.bind("127.0.0.1", 4040);
    await for (var request in server) {
      WebSocket socket = await WebSocketTransformer.upgrade(request);
      sockets.add(socket);
      socket.listen(addCoordinate).onDone(() {
        onClose(socket);
      });
    }
  }, onError: (e) => print("Error occurred." + e.toString()));
}
