import 'dart:async';
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/widget/input_field.dart';
import 'gamecommunication.dart';

class BoardView extends StatefulWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final FocusNode _focusNode = FocusNode();
  int myId = 0;
  int size = 20;
  int position = 0;
  List<dynamic> players = [];
  List<dynamic> jewels1 = [];
  List<int> jewels = [];

  @override
  void initState() {
    super.initState();

    game.addListener(_onAction);
  }

  @override
  void dispose() {
    _focusNode.dispose();
    game.removeListener(_onAction);
    super.dispose();
  }

  final TextEditingController _pseudoController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Column(
            children: [
              CustumTextInput(
                controller: _pseudoController,
                label: "Nom du joueur",
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: _onConnect,
                child: const SizedBox(
                  height: 30,
                  width: 180,
                  child: Center(
                    child: Text(
                      "Se connecter",
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.topLeft,
            child: SizedBox(
              height: 35,
              width: 150,
              child: ElevatedButton(
                  onPressed: _onGameJoin, child: const Text('Start')),
            ),
          ),
          Container(
            color: Colors.grey[300],
            height: 500,
            width: 500,
            child: RawKeyboardListener(
                focusNode: _focusNode,
                autofocus: true,
                onKey: _handleKeyEvent,
                child: AnimatedBuilder(
                  animation: _focusNode,
                  builder: (BuildContext context, Widget? child) {
                    return GestureDetector(
                      onTap: () {
                        FocusScope.of(context).requestFocus(_focusNode);
                      },
                      child: GridView.builder(
                        itemCount: size * size,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: size),
                        itemBuilder: (BuildContext context, index) {
                          return Padding(
                              padding: const EdgeInsets.all(1.5),
                              child: Container(
                                  // color: majPosition(index),
                                  color: Color(
                                indexColor[index] ?? Colors.black12.value,
                              )));
                        },
                      ),
                    );
                  },
                )),
          ),
          Container(
            height: 35,
            width: 550,
            alignment: Alignment.center,
            child: SizedBox(
              height: 35,
              width: 183,
              child: ElevatedButton(
                  onPressed: () => _onUpMove(), child: const Text('MoveUp')),
            ),
          ),
          Container(
              height: 35,
              width: 550,
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    height: 35,
                    width: 183,
                    child: ElevatedButton(
                        onPressed: () => _onLeftMove(),
                        child: const Text('MoveLeft')),
                  ),
                  SizedBox(
                    height: 35,
                    width: 183,
                    child: ElevatedButton(
                        onPressed: () => _onDownMove(),
                        child: const Text('MoveDown')),
                  ),
                  SizedBox(
                    height: 35,
                    width: 183,
                    child: ElevatedButton(
                        onPressed: () => _onRightMove(),
                        child: const Text('moveRight')),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  /// ---------------------------------------------------------
  /// L'adversaire a émis une action.
  /// Gestion de ces actions.
  /// ---------------------------------------------------------
  _onAction(message) {
    List<int> inJewels = [];
    switch (message["messageType"]) {
      case 'connected':
        for (Map el in message["players"]) {
          if (el["pseudo"] == _pseudoController.text) {
            myId = message["idPlayer"];
            break;
          }
        }
        break;
      case 'started':
        print("in the connected");
        for (Map el in message["players"]) {
          moveTo(indexCalcul(el['x'], el['y']));
        }
        for (Map el in message["jewels"]) {
          inJewels.add(indexCalcul(el['x'], el['y']));
        }
        setState(() {
          jewels = inJewels;
        });
        jewels1 = message['jewels'];
        players = message['players'];
        getAllIndex();
        break;
      case 'moved':
        for (Map el in message["players"]) {
          moveTo(indexCalcul(el['x'], el['y']));
        }
        for (Map el in message["jewels"]) {
          inJewels.add(indexCalcul(el['x'], el['y']));
        }
        setState(() {
          jewels = inJewels;
        });
        jewels1 = message['jewels'];
        players = message['players'];
        getAllIndex();
        break;
    }
  }

  _onGameJoin() {
    game.send('start', size, 10, game.playerId, _pseudoController.text, "");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onConnect() {
    print(game.playerId.toString());
    game.send('connect', size, 10, game.playerId, _pseudoController.text, "");
  }

  _onLeftMove() {
    print('chat');
    print(game.playerId.toString());
    game.send('move', size, 10, game.playerId, game.playerName, "left");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onRightMove() {
    print(game.playerId.toString());
    game.send('move', size, 10, game.playerId, game.playerName, "right");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onDownMove() {
    print(game.playerId.toString());
    game.send('move', size, 10, game.playerId, game.playerName, "bottom");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onUpMove() {
    print(game.playerId.toString());
    game.send('move', size, 10, game.playerId, game.playerName, "top");

    /// Forcer un rafraîchissement
    setState(() {});
  }

//
//Moving Functions
//
  majPosition(int index) {
    for (int el in jewels) {
      if (index == el) return Colors.green;
    }
    if (index == position)
      return Colors.blue;
    // if (index == addPosition)
    //   return Colors.red;
    else
      return Colors.white;
  }

  indexCalcul(int x, int y) {
    return y * size + x;
  }

  startMoving() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        position++;
      });
    });
  }

  getPositionByIndex(int index) {
    return {'x': index / size, 'y': index % size};
  }

  getIndexForPosition(int x, int y) {
    return y * size + x;
  }

  moveTo(int index) {
    setState(() {
      position = index;
    });
  }

  moveUp() {
    setState(() {
      position = position - size;
    });
  }

  moveDown() {
    setState(() {
      position = position + size;
    });
  }

  moveRight() {
    setState(() {
      position++;
    });
  }

  moveLeft() {
    setState(() {
      position--;
    });
  }

  void _handleKeyEvent(RawKeyEvent event) {
    if (event.runtimeType == RawKeyDownEvent) {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        _onUpMove();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        _onDownMove();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        _onRightMove();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        _onLeftMove();
      }
    }
  }

  Map<int, int> indexColor = {};

  getAllIndex() {
    indexColor = {};
    for (var player in players) {
      indexColor[getIndexForPosition(player['x'], player['y'])] =
          player['color'];
    }
    for (var jewel in jewels1) {
      indexColor[getIndexForPosition(jewel['x'], jewel['y'])] =
          Colors.black.value;
    }
  }
}
