import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:malison/malison_web.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/src/entity.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/track.dart';

class MainGameScreen extends Screen<String> {
  final Game game;
  final math.Random random = math.Random();

  MainGameScreen(this.game);

  int currentTurn = 0;
  bool timeToUpdate = false;

  void endTurn() {
    timeToUpdate = true;
  }

  void startNewTurn() {
    game.advanceTurnCounter();
    timeToUpdate = false;
  }

  Track get track => game.track;
  PlayerCar get player => game.player;

  bool displayHint = false;
  bool displayGrid = false;
  bool debug = false;

  Vec cursor = Vec(0, 0);

  void setCursor(Vec vec) {
    cursor = vec;
  }

  void moveCursor(Vec dVec) {
    cursor += dVec;
    if (cursor.x < -1) {
      cursor = Vec(-1, cursor.y);
    }
    if (cursor.x > 1) {
      cursor = Vec(1, cursor.y);
    }
    if (cursor.y < -1) {
      cursor = Vec(cursor.x, -1);
    }
    if (cursor.y > 1) {
      cursor = Vec(cursor.x, 1);
    }
  }

  @override
  bool handleInput(String input) {
    switch (input) {
      case 'nw':
        setCursor(Direction.nw);
        endTurn();
        break;
      case 'n':
        setCursor(Direction.n);
        endTurn();
        break;
      case 'ne':
        setCursor(Direction.ne);
        endTurn();
        break;
      case 'w':
        setCursor(Direction.w);
        endTurn();
        break;
      case 'none':
        setCursor(Direction.none);
        endTurn();
        break;
      case 'e':
        setCursor(Direction.e);
        endTurn();
        break;
      case 'sw':
        setCursor(Direction.sw);
        endTurn();
        break;
      case 's':
        setCursor(Direction.s);
        endTurn();
        break;
      case 'se':
        setCursor(Direction.se);
        endTurn();
        break;

      case 'up':
        moveCursor(Direction.n);
        break;
      case 'down':
        moveCursor(Direction.s);
        break;
      case 'right':
        moveCursor(Direction.e);
        break;
      case 'left':
        moveCursor(Direction.w);
        break;

      case 'confirm':
        endTurn();
        break;
      case 'space':
        setCursor(Direction.none);
        endTurn();
        break;
      case 'comma':
        displayHint = !displayHint;
        break;

      case 'period':
        displayGrid = !displayGrid;
        break;

      case 'debug':
        debug = !debug;
        break;

      default:
        return false;
    }

    dirty();
    ui.refresh();
    return true;
  }

  @override
  void update() {
    if (timeToUpdate) {
      var speed = math.min(
          math.max(player.speed, game.roadMinSpeed), game.roadMaxSpeed);

      player.changeSpeed(Direction(cursor.x, cursor.y));

      for (var car in game.cars) {
        car.update();
        if (car.isAlive) {
          car.move();
        } else if (car is NPC) {
          if (random.nextBool()) {
            var spawnLocation =
                Vec(track.width ~/ 3 + track.randomInt(0, 6), 0);
            if (!track.isBlocked(spawnLocation)) {
              car.reset(spawnLocation);
            }
          }
        }
      }
      for (var entity in game.entities) {
        entity.rollDown(speed);
      }
      track.rollDown(speed);
      if (player.isAlive) {
        game.updateScore(game.currentTurn + player.speed);
        startNewTurn();
      } else {
        cursor = Direction.none;
        timeToUpdate = false;
        game.end();
      }
    }
  }

  @override
  void render(Terminal terminal) {
    terminal.clear();

    track.render(terminal, game.trackPanelPosition.x, game.trackPanelPosition.y,
        showGrid: displayGrid, debugMode: debug);
    renderScore(terminal);

    for (var entity in game.entities) {
      if (debug) {
        if (entity is Car) {
          entity.renderDebugInfo(terminal);
        }
      }

      if (entity is PlayerCar) {
        entity.renderProjectedMoves(terminal,
            cursorPos: cursor, showHint: displayHint);
      }
      entity.render(terminal);
    }
  }

  void renderScore(Terminal terminal) {
    var x = game.hudPanelPosition.x;
    var y = game.hudPanelPosition.y;
    terminal.writeAt(x, y, 'Highest score: ${game.highscore}');
    terminal.writeAt(x, y + 2, 'Score: ${game.score}');
  }
}
