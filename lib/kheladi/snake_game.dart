import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
enum Direction { up, down, left, right }

class SnakeGame extends StatefulWidget {
  final Function(int) onScoreUpdate;
  final bool isPlaying;

  const SnakeGame({Key? key, required this.onScoreUpdate, required this.isPlaying}) : super(key: key);

  @override
  State<SnakeGame> createState() => _SnakeGameState();
}

class _SnakeGameState extends State<SnakeGame> {
  // Down or right - head val is grater than other
  //up or left - head val is less than other
  // head refers to last element of array
  List<int> snakePosition = [24, 44, 64];
  int foodLocation = Random().nextInt(700);
  bool start = false;
  Direction direction = Direction.down;
  List<int> totalSpot = List.generate(760, (index) => index); //totalspot
  Timer? _gameTimer;

  @override
  void didUpdateWidget(SnakeGame oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying != oldWidget.isPlaying) {
      if (widget.isPlaying) {
        startGame();
      } else {
        _gameTimer?.cancel();
      }
    }
  }

  startGame() {
    start = true;
    snakePosition = [24, 44, 64];
    _gameTimer = Timer.periodic(const Duration(milliseconds: 300), (timer) {
      updateSnake();
      if (gameOver()) {
        gameOverAlert();
        timer.cancel();
      }
    });
  }

  updateSnake() {
    setState(() {
      switch (direction) {
        case Direction.down:
          if (snakePosition.last > 740) {
            snakePosition.add(snakePosition.last - 760 + 20);
          } else {
            snakePosition.add(snakePosition.last + 20);
          }
          break;
        case Direction.up:
          if (snakePosition.last < 20) {
            snakePosition.add(snakePosition.last + 760 - 20);
          } else {
            snakePosition.add(snakePosition.last - 20);
          }
          break;
        case Direction.right:
          if ((snakePosition.last + 1) % 20 == 0) {
            snakePosition.add(snakePosition.last + 1 - 20);
          } else {
            snakePosition.add(snakePosition.last + 1);
          }
          break;
        case Direction.left:
          if (snakePosition.last % 20 == 0) {
            snakePosition.add(snakePosition.last - 1 + 20);
          } else {
            snakePosition.add(snakePosition.last - 1);
          }
          break;
        default:
      }
      if (snakePosition.last == foodLocation) {
        totalSpot.removeWhere((element) => snakePosition.contains(element));

        foodLocation = totalSpot[Random().nextInt(totalSpot.length -
            1)]; //new food location is everywhere expect snackPosition
      } else {
        snakePosition.removeAt(0);
      }
      widget.onScoreUpdate(snakePosition.length - 3);
    });
  }

  bool gameOver() {
    final copyList = List.from(snakePosition);
    if (snakePosition.length > copyList.toSet().length) {
      return true;
    } else {
      return false;
    }
  }

  gameOverAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Game Over'),
          content:
              Text('your score is ' + (snakePosition.length - 3).toString()),
          actions: [
            TextButton(
                onPressed: () {
                  startGame();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Play Again')),
            TextButton(
                onPressed: () {
                  SystemNavigator.pop();
                },
                child: const Text('Exit'))
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragUpdate: (details) {
        if (direction != Direction.up && details.delta.dy > 0) {
          direction = Direction.down;
        }
        if (direction != Direction.down && details.delta.dy < 0) {
          direction = Direction.up;
        }
      },
      onHorizontalDragUpdate: (details) {
        if (direction != Direction.left && details.delta.dx > 0) {
          direction = Direction.right;
        }
        if (direction != Direction.right && details.delta.dx < 0) {
          direction = Direction.left;
        }
      },
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 760,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 20),
        itemBuilder: (context, index) {
          if (snakePosition.contains(index)) {
            return Container(
              color: Colors.white,
            );
          }
          if (index == foodLocation) {
            return Container(
              color: Colors.red,
            );
          }
          return Container(
            color: Colors.black,
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    super.dispose();
  }
}
