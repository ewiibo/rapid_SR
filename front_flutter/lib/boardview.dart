import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'gamecommunication.dart';

class BoardView extends StatefulWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final FocusNode _focusNode = FocusNode();
  late int id = 1;
  int size = 20;
  int position = 0;
  int addPosition = 57;
  List<int> jewels = [1, 12, 35, 4, 50, 123, 22, 19];
  // List<int> ownJewels = [];

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
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
            height: 550,
            width: 550,
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
                                color: majPosition(index),
                              ));
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
                  onPressed: () => moveUp(), child: const Text('MoveUp')),
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
                        onPressed: () => moveLeft(),
                        child: const Text('MoveLeft')),
                  ),
                  SizedBox(
                    height: 35,
                    width: 183,
                    child: ElevatedButton(
                        onPressed: () => moveDown(),
                        child: const Text('MoveDown')),
                  ),
                  SizedBox(
                    height: 35,
                    width: 183,
                    child: ElevatedButton(
                        onPressed: () => moveRight(),
                        child: const Text('moveRight')),
                  ),
                ],
              )),
        ],
      ),
    );
  }

  _onGameJoin() {
    game.send('connect', size.toString());

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
    if (index == position) return Colors.blue;
    if (index == addPosition)
      return Colors.red;
    else
      return Colors.white;
  }

  indexCalcul(int x, int y) {
    return x * size + y;
  }

  startMoving() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      setState(() {
        position++;
      });
    });
  }

  // applyChange(int id) {
  //   if (GameCommunication.serverMessage['players'][0].idPlayer == id) {
  //     majPosition(indexCalcul(
  //         GameCommunication.serverMessage['players'][0].x, GameCommunication.serverMessage['players'][0].y));
  //   }
  // }

  getPositionByIndex(int index) {
    return {'x': index / size, 'y': index % size};
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
    print("in1");
    if (event.runtimeType.toString() == "RawKeyDownEvent") {
      print("in2");
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        moveUp();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
        print("in3");
        moveDown();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
        moveRight();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
        moveLeft();
      }
    }
  }
}
