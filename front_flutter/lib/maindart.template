import 'package:universal_io/io.dart';

import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter websocket client'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController controller = TextEditingController();
  // for only web
  late WebSocketChannel webSocketChannel = WebSocketChannel.connect(
    Uri.parse('ws://127.0.0.1:4040/'),
  );

  // for other platform

  //late WebSocketChannel webSocketChannel = IOWebSocketChannel.connect(
  //    (!Platform.isAndroid) ? 'ws://127.0.0.1:4040/' : 'ws://10.0.2.2:4040/');

  // 'ws://127.0.0.1:4040/');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          children: [
            TextField(
              controller: controller,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
                onPressed: () => webSocketChannel.sink.add(controller.text),
                child: const Text("Envoyer")),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder(
              stream: webSocketChannel.stream,
              builder: (context, snapshot) {
                return Text('Reiceved data from server ' +
                    (snapshot.hasData ? snapshot.data.toString() : ''));
              },
            )
          ],
        ),
      ),
    );
  }
}
