import 'dart:html' as html;
import 'dart:math' as math;

import 'package:malison/malison.dart';
import 'package:piecemeal/piecemeal.dart';
import 'package:speedvector7drl/main.dart';
import 'package:speedvector7drl/src/colorscheme.dart';
import 'package:speedvector7drl/src/entity.dart';
import 'package:speedvector7drl/src/game.dart';
import 'package:speedvector7drl/src/linearfunctions.dart';
import 'package:speedvector7drl/src/track.dart';
import 'package:speedvector7drl/src/ui.dart';

class MainGameScreen extends ScreenWithMouse<String> {
  final Game _game;
  final math.Random random = math.Random();

  List<String> options = ['Show hint', 'Show grid', 'Show instructions'];
  List<Button> buttons = [];

  MainGameScreen(this._game) {
    var buttonX = game.buttonPanelPosition.x;
    var buttonY = game.buttonPanelPosition.y;
    for (var text in options) {
      buttons
          .add(Button(Vec(buttonX, buttonY), text, Color.darkGold, Color.gold));
      buttonY += 2;
    }
  }

  Game get game => _game;

  Track get track => game.track;
  PlayerCar get player => game.player;

  bool displayHint = false;
  bool displayGrid = false;
  bool displayInstructions = true;
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

  void toggleSetting(int n) {
    switch (n) {
      case 0:
        displayHint = !displayHint;
        break;
      case 1:
        displayGrid = !displayGrid;
        break;
      case 2:
        displayInstructions = !displayInstructions;
        break;
      default:
        return;
    }
  }

  @override
  bool handleInput(String input) {
    switch (input) {
      case 'nw':
        setCursor(Direction.nw);
        game.endTurn();
        break;
      case 'n':
        setCursor(Direction.n);
        game.endTurn();
        break;
      case 'ne':
        setCursor(Direction.ne);
        game.endTurn();
        break;
      case 'w':
        setCursor(Direction.w);
        game.endTurn();
        break;
      case 'none':
        setCursor(Direction.none);
        game.endTurn();
        break;
      case 'e':
        setCursor(Direction.e);
        game.endTurn();
        break;
      case 'sw':
        setCursor(Direction.sw);
        game.endTurn();
        break;
      case 's':
        setCursor(Direction.s);
        game.endTurn();
        break;
      case 'se':
        setCursor(Direction.se);
        game.endTurn();
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
        game.endTurn();
        break;

      case 'comma':
        toggleSetting(0);
        break;
      case 'period':
        toggleSetting(1);
        break;
      case 'space':
        toggleSetting(2);
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
  bool mouseUp(html.MouseEvent mouseEvent) {
    var p = mousePosition16 - trackPanelPosition;
    if (track.withinBounds(p)) {
      if (game.entityAtPosition(p) == null) {
        game.endTurn();
        dirty();
        return true;
      }
      for (var dVec in player.standardDirectionVectors) {
        if (player.nextC() + dVec == p) {
          setCursor(dVec);
          game.endTurn();
          dirty();
          return true;
        }
      }
    } else {
      for (var i = 0; i < buttons.length; i++) {
        if (buttons[i].hoveredOver(mousePosition16)) {
          toggleSetting(i);
          dirty();
          return true;
        }
      }
    }
    dirty();
    return true;
  }

  @override
  bool mouseMove(html.MouseEvent mouseEvent) {
    var p = mousePosition16 - trackPanelPosition;
    if (track.withinBounds(p)) {
      var mouseDirVec = p - player.nextC();
      cursor = mouseDirVec.nearestDirection;

      for (var dVec in player.standardDirectionVectors) {
        if (player.nextC() + dVec == p) {
          setCursor(dVec);
          continue;
        }
      }
    }
    dirty();
    return true;
  }

  @override
  void update() {
    if (game.gameIsRunning) {
      var cars = game.cars;
      var speed = math.min(
          math.max(player.speed, game.roadMinSpeed), game.roadMaxSpeed);

      if (game.turnOver) {
        player.changeSpeed(Direction(cursor.x, cursor.y));

        // Sort cars in order of speed
        cars.sort((a, b) => a.speed.compareTo(b.speed));

        // Process cars acording to speed, in descending order
        for (var car in cars.reversed) {
          car.update();
        }

        var opponentNotSpawnedThisTurn = true;
        for (var car in cars.reversed) {
          if (car.isAlive) {
            car.move();
          } else if (car is NPC && car.isOffScreen()) {
            if (random.nextBool()) {
              var spawnLocation =
                  Vec(track.width ~/ 3 + track.randomInt(0, 18), 0);
              if (!track.isBlocked(spawnLocation) &&
                  opponentNotSpawnedThisTurn) {
                car.reset(spawnLocation);
                opponentNotSpawnedThisTurn = false;
              }
            }
          }
        }

        if (debug) {
          for (var car in cars.reversed) {
            var otherCars = game.cars;
            otherCars.remove(car);

            for (var other in otherCars) {
              var potentialCollision = car.pathIntersects(other);
              if (potentialCollision != null) {
                game.log(
                    'Path of ${car.name} intersects with that of ${other.name}!',
                    fgColor: car.fgColor);
              }
            }
          }
        }

        for (var car in cars) {
          if (car.isAlive && track.withinBounds(car.position)) {
            var otherEntities = [];
            otherEntities.addAll(game.entities);
            otherEntities.remove(car);
            for (var other in otherEntities) {
              var line = Line(car.trail.start, car.trail.end);

              if (onLine(line, other.position)) {
                car.checkCollision(other);
              }
            }
          }
        }

        var collision;
        do {
          collision = false;
          for (var car in game.cars) {
            if (car.isAlive) {
              var entitiesAtSamePosition = car.getEntitiesAtSamePosition();
              if (entitiesAtSamePosition.isNotEmpty) {
                for (var entity in entitiesAtSamePosition) {
                  if (car.checkCollision(entity)) {
                    collision = true;
                  }
                }
              }
            }
          }
        } while (collision);

        for (var entity in game.entities) {
          entity.rollDown(speed);
        }
        track.rollDown(speed);
        if (player.isAlive) {
          game.updateScore(game.currentTurn + player.speed);
          game.startNewTurn();
        } else {
          cursor = Direction.none;
          game.turnOver = false;
          game.log(
              'You have crashed. Your car is a wreck. A burning wreck. Seriously, you\'re on fire. And not in a good way...',
              fgColor: ColorScheme.danger);
          game.end();
        }

        if (player.positionIsOffScreen && !player.destinationIsOffScreen) {
          game.log(
              'Uh oh! You need to go faster if you want to stay in the race!',
              fgColor: ColorScheme.warning);
        }
        if (!player.positionIsOffScreen && player.destinationIsOffScreen) {
          game.log('Whoa, slow down!', fgColor: ColorScheme.warning);
        }
      }
    }
  }

  @override
  void render(Terminal terminal) {
    terminal.clear();

    buttons[0].render(terminal, displayHint);
    buttons[1].render(terminal, displayGrid);
    buttons[2].render(terminal, displayInstructions);

    track.render(terminal, game.trackPanelPosition.x, game.trackPanelPosition.y,
        showGrid: displayGrid, debugMode: debug);
    renderHud(terminal);
    // renderInstructions(terminal);

    player.renderProjectedMoves(terminal,
        cursorPos: cursor, showHint: displayHint);

    for (var entity in game.entities) {
      if (debug) {
        if (entity is Car) {
          entity.renderDebugInfo(terminal);
        }
      }

      entity.render(terminal);
    }

    game.messageLog.render(terminal, game.logPanelPosition.x,
        game.logPanelPosition.y, game.logPanelSize.x, game.logPanelSize.y);

    renderEntitiesUnderMouse(terminal);
    if (displayInstructions) {
      renderInstructions(terminal);
    }
    renderTooltip(terminal);
  }

  void renderTooltip(Terminal terminal) {
    for (var i = 0; i < buttons.length; i++) {
      if (buttons[i].hoveredOver(mousePosition16)) {
        var text = [];
        switch (i) {
          case 0:
            text = [
              'Display where your next center',
              'movement option will be.',
              'Shortcut: [,]'
            ];
            break;
          case 1:
            text = [
              'Display the grid to help',
              'visualize possible movements.',
              'Shortcut: [.]'
            ];
            break;
          case 2:
            text = [
              'Display on-screen',
              'instructions below.',
              'Shortcut: [space]'
            ];
            break;
          default:
          // text = '';
        }
        var p = mousePosition16 + Vec(2, -1);
        for (var i = 0; i < text.length; i++) {
          terminal.writeAt(p.x, p.y + i, text[i]);
        }
      }
    }
  }

  void renderHud(Terminal terminal) {
    var x = game.hudPanelPosition.x;
    var y = game.hudPanelPosition.y;
    terminal.writeAt(x, y, 'Highest score: ${game.highscore}');
    terminal.writeAt(x, y + 2, 'Score: ${game.score}');
    terminal.writeAt(x, y + 5, 'Speed: ${player.speed}');
    terminal.writeAt(x, y + 6, 'Hitpoints: ${player.hp} / ${player.maxHp}');
  }

  List<String> instructions = [
    '[↑↓→←] Move cursor to',
    '  pick direction',
    '[enter] Confirm choice',
    '[numpad] Pick direction',
    '  AND confirm',
  ];

  void renderInstructions(Terminal terminal) {
    var x = game.instructionsPanelPosition.x;
    var y = game.instructionsPanelPosition.y;
    for (var i = 0; i < instructions.length; i++) {
      terminal.writeAt(x, y + i * 2, instructions[i], Color.gray);
    }
  }

  void renderEntitiesUnderMouse(Terminal terminal) {
    var results = [];
    for (var entity in game.entities) {
      if (mousePosition16 == entity.position + trackPanelPosition) {
        results.add(entity);
      }
    }
    if (track.withinBounds(mousePosition16 - trackPanelPosition)) {
      var p = mousePosition16 + Vec(1, -2);
      if (results.isNotEmpty) {
        terminal.writeAt(p.x, p.y, results.toString());
        p += Direction.s;
        terminal.drawChar(p.x, p.y, CharCode.slash);
      }
    }
  }
}
