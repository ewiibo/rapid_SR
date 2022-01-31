import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:front/result_view.dart';
import 'package:front/widget/input_field.dart';
import 'gamecommunication.dart';

class BoardView extends StatefulWidget {
  final int myId;
  final String myName;
  final dynamic players;
  const BoardView({
    Key? key,
    required this.myId,
    required this.myName,
    required this.players,
  }) : super(key: key);

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
    myId = widget.myId;
    players = widget.players; //dans l'init state !
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
              SizedBox(
                  width: 800,
                  child: Text(
                    widget.myName,
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 60),
                  )),
              const SizedBox(
                height: 30,
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
          Row(
            children: [
              Spacer(),
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
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
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
              Flexible(
                child: Container(
                  height: 500,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          var player = players[index];
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                player['pseudo'],
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 20,
                              ),
                              Text(
                                player['score'].toString(),
                                style: const TextStyle(
                                    fontSize: 17, fontWeight: FontWeight.w600),
                              )
                            ],
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: players.length),
                  ),
                ),
              ),
            ],
          ),
          Container(
            height: 35,
            width: 480,
            alignment: Alignment.center,
            child: SizedBox(
              height: 35,
              width: 160,
              child: ElevatedButton(
                  onPressed: () => _onUpMove(), child: const Text('MoveUp')),
            ),
          ),
          Container(
              height: 35,
              width: 480,
              alignment: Alignment.center,
              child: Row(
                children: [
                  SizedBox(
                    height: 35,
                    width: 160,
                    child: ElevatedButton(
                        onPressed: () => _onLeftMove(),
                        child: const Text('MoveLeft')),
                  ),
                  SizedBox(
                    height: 35,
                    width: 160,
                    child: ElevatedButton(
                        onPressed: () => _onDownMove(),
                        child: const Text('MoveDown')),
                  ),
                  SizedBox(
                    height: 35,
                    width: 160,
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
      case 'started':
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
      case 'finished':
        Navigator.push(context,
            MaterialPageRoute(builder: (BuildContext context) {
          return ResultView(players: message["players"]);
        }));
        break;
    }
  }

  _onGameJoin() {
    game.send('start', size, 10, myId, _pseudoController.text, "");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onConnect() {
    myId = DateTime.now().microsecondsSinceEpoch;
    game.send('connect', size, 3, myId, _pseudoController.text, "");
  }

  _onLeftMove() {
    game.send('move', size, 10, myId, game.playerName, "left");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onRightMove() {
    game.send('move', size, 10, myId, game.playerName, "right");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onDownMove() {
    game.send('move', size, 10, myId, game.playerName, "bottom");

    /// Forcer un rafraîchissement
    setState(() {});
  }

  _onUpMove() {
    game.send('move', size, 10, myId, game.playerName, "top");

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
