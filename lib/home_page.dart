import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snake_game/pixels/blank_pixel.dart';
import 'package:snake_game/pixels/food_pixel.dart';
import 'package:snake_game/pixels/snake_pixel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

enum snake_Direction { UP, DOWN, LEFT, RIGHT }

class _HomePageState extends State<HomePage> {
  // dimensions of the grid
  int rowSize = 10;
  int totalNumberOfSquares = 100;

  // snake position
  List<int> snakePos = [0, 1, 2];

  // food position
  int foodPos = 55;

  // snake direction is initially to the right
  var currentDirection = snake_Direction.RIGHT;

  // user score
  int currentScore = 0;

  bool gameHasStarted = false;

  // start the game!
  void startGame() {
    gameHasStarted = true;
    Timer.periodic(Duration(milliseconds: 200), (timer) {
      setState(() {
        moveSnake();

        // check if game is over
        if (gameOver()) {
          timer.cancel();

          // display a message
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) {
              return AlertDialog(
                title: Text('Game Over'),
                content: Column(
                  children: [
                    Text('Your score is $currentScore'),
                    TextField(
                      decoration: InputDecoration(hintText: 'Enter name'),
                    ),
                  ],
                ),
                actions: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.pop(context);
                      submitScore();
                      newGame();
                    },
                    child: Text('Submit'),
                    color: Colors.pink,
                  )
                ],
              );
            },
          );
        }
      });
    });
  }

  void moveSnake() {
    switch (currentDirection) {
      case snake_Direction.RIGHT:
        {
          // add a new head
          // if snake at right wall need to re-adjust
          if (snakePos.last % rowSize == rowSize - 1) {
            snakePos.add(snakePos.last + 1 - rowSize);
          } else {
            snakePos.add(snakePos.last + 1);
          }
        }
        break;

      case snake_Direction.LEFT:
        {
          // add a new head
          // if snake at left wall need to re-adjust
          if (snakePos.last % rowSize == 0) {
            snakePos.add(snakePos.last - 1 + rowSize);
          } else {
            snakePos.add(snakePos.last - 1);
          }
        }
        break;

      case snake_Direction.DOWN:
        {
          // add a new head
          // if snake at the wall below need to re-adjust
          if (snakePos.last + rowSize > totalNumberOfSquares) {
            snakePos.add(snakePos.last + rowSize - totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last + rowSize);
          }
        }
        break;

      case snake_Direction.UP:
        {
          // add a new head
          // if snake at the wall above need to re-adjust
          if (snakePos.last < rowSize) {
            snakePos.add(snakePos.last - rowSize + totalNumberOfSquares);
          } else {
            snakePos.add(snakePos.last - rowSize);
          }
        }
        break;
      default:
    }

    if (snakePos.last == foodPos) {
      eatFood();
    } else {
      // remove the tail
      snakePos.removeAt(0);
    }
  }

  void eatFood() {
    currentScore += 10;
    // make sure food is not where snake is
    while (snakePos.contains(foodPos)) {
      foodPos = Random().nextInt(totalNumberOfSquares);
    }
  }

  bool gameOver() {
    List<int> bodySnake = snakePos.sublist(0, snakePos.length - 1);

    if (bodySnake.contains(snakePos.last)) {
      return true;
    }
    return false;
  }

  void submitScore() {}

  void newGame() {
    setState(() {
      snakePos = [0, 1, 2];
      foodPos = 55;
      currentDirection = snake_Direction.RIGHT;
      currentScore = 0;
      gameHasStarted = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            // higscores
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  // users current score
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Current Score',
                      ),
                      Text(
                        currentScore.toString(),
                        style: TextStyle(
                          fontSize: 36,
                        ),
                      ),
                    ],
                  ),

                  // top 5 highscores
                  Text('Highscores...'),
                ],
              ),
            ),

            // game grid
            Expanded(
              flex: 3,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy > 0 &&
                      currentDirection != snake_Direction.UP) {
                    currentDirection = snake_Direction.DOWN;
                  } else if (details.delta.dy < 0 &&
                      currentDirection != snake_Direction.DOWN) {
                    currentDirection = snake_Direction.UP;
                  }
                },
                onHorizontalDragUpdate: (details) {
                  if (details.delta.dx > 0 &&
                      currentDirection != snake_Direction.LEFT) {
                    currentDirection = snake_Direction.RIGHT;
                  } else if (details.delta.dx < 0 &&
                      currentDirection != snake_Direction.RIGHT) {
                    currentDirection = snake_Direction.LEFT;
                  }
                },
                child: GridView.builder(
                  itemCount: totalNumberOfSquares,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: rowSize,
                  ),
                  itemBuilder: (context, index) {
                    if (snakePos.contains(index))
                      return SnakePixel();
                    else if (foodPos == index)
                      return FoodPixel();
                    else
                      return BlankPixel();
                  },
                ),
              ),
            ),

            // play button
            Expanded(
              child: Center(
                child: MaterialButton(
                  child: Text('PLAY'),
                  color: gameHasStarted ? Colors.grey : Colors.pink,
                  onPressed: gameHasStarted ? () {} : () => startGame(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
