import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

class BoardView extends StatefulWidget {
  const BoardView({Key? key}) : super(key: key);

  @override
  _BoardViewState createState() => _BoardViewState();
}

class _BoardViewState extends State<BoardView> {
  final FocusNode _focusNode = FocusNode();
  int size = 20;
  int position = 0;
  int newPosition = 150;

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
                  onPressed: startMoving, child: const Text('Start')),
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
                                color: index == position
                                    ? Colors.black87
                                    : Colors.white,
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

//
//Moving Functions
//
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

  getPosition() {
    print(position);
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
    if (event.runtimeType.toString() == "RawKeyDownEvent") {
      if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
        moveUp();
      }
      if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
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
